import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:handoff_vdb_2025/core/extensions/string_extension.dart';
import 'package:handoff_vdb_2025/data/services/firebase_presence_service.dart';
import 'package:handoff_vdb_2025/firebase_options.dart';
import 'package:handoff_vdb_2025/config/routes/route_path/auth_routers.dart';
import 'package:handoff_vdb_2025/core/enums/auth_enums.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/shared_pref/shared_preference_helper.dart';
import 'package:handoff_vdb_2025/data/services/deep_link_service.dart';
import 'package:handoff_vdb_2025/data/model/post/post_input_model.dart';
import 'package:handoff_vdb_2025/data/model/post/post_link_meta.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'data/services/app_local_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');
  } catch (e) {
    if (e.toString().contains('duplicate-app')) {
      print('Firebase already initialized (duplicate app error caught)');
    } else {
      print('Firebase initialization failed: $e');
      rethrow;
    }
  }

  await AppInit.instance.init();

  if (!kIsWeb) {
    await Hive.initFlutter();
    Hive.registerAdapter(PostInputModelAdapter());
    Hive.registerAdapter(PostLinkMetaAdapter());
    await Hive.openBox<PostInputModel>('pending_posts');
  }

  final createPostStore = AppInit.instance.createPostStore;
  createPostStore.listenNetwork();

  usePathUrlStrategy();



  await AppLocalNotificationService().init();

  runApp(
      const MyApp()
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // --- Services & Helpers ---
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  late StreamSubscription _intentSub;
  late final DeepLinkService _deepLinkService;

  final _sharedFiles = <SharedMediaFile>[];
  final SharedPreferenceHelper _sharedPreferenceHelper = AppInit.instance.sharedPreferenceHelper;
  final FirebasePresenceService _firebasePresenceService = AppInit.instance.firebasePresenceService;

  bool _isAppReady = false;
  String? _userId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // --- Init Deep Link Service ---
    _deepLinkService = DeepLinkService();
    _deepLinkService.initialize(router);

    // --- Init Deep Links ---
    _initDeepLinks();

    // --- Load UserId for presence tracking ---
    _loadUserId();

    // --- Init ReceiveSharingIntent (only mobile) ---
    if (!kIsWeb) {
      _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen(
            (value) {
          _handleReceivedFiles(value);
          ReceiveSharingIntent.instance.reset();
        },
        onError: (err) => print("getIntentDataStream error: $err"),
      );

      _handleInitialMedia();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Đánh dấu app sẵn sàng khi load xong dependencies
    if (!_isAppReady) {
      _isAppReady = true;
      _checkPendingSharedFiles();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (_userId == null) return;

    // Khi app quay lại foreground → refresh online status
    if (state == AppLifecycleState.resumed) {
      _firebasePresenceService.setupUserPresence(_userId!);
    }

  }

  @override
  void dispose() {
    if (!kIsWeb) {
      _intentSub.cancel();
    }
    _linkSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // --------------------------
  // 🔗 Deep Link Handling
  // --------------------------
  void _initDeepLinks() async {
    _appLinks = AppLinks();

    // Lấy deeplink đầu tiên khi mở app
    final initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      _handleDeepLink(initialLink);
    }

    // Lắng nghe deeplink khi app đang chạy
    _linkSubscription = _appLinks.uriLinkStream.listen(
          (Uri uri) => _handleDeepLink(uri),
      onError: (err) => print('Deep link error: $err'),
    );
  }

  void _handleDeepLink(Uri uri) {
    if (mounted) {
      _deepLinkService.handleDeepLink(uri);
    }
  }

  // --------------------------
  // 📂 Receive Sharing Intent
  // --------------------------
  void _handleReceivedFiles(List<SharedMediaFile> files) async {
    if (files.isEmpty) return;

    _sharedFiles
      ..clear()
      ..addAll(files);

    try {
      await _sharedPreferenceHelper.setReceivedValue(
        _sharedFiles.map((f) => f.path).toList(),
      );

      if (_isAppReady && !_sharedFiles[0].path.isDeepLink) {
        await _navigateToCreatePost();
      }

    } catch (e) {
      print('Error handling shared files: $e');
    }
  }

  Future<void> _handleInitialMedia() async {
    if (kIsWeb) return;

    try {
      final value = await ReceiveSharingIntent.instance.getInitialMedia();
      if (value.isNotEmpty) {
        _handleReceivedFiles(value);
        ReceiveSharingIntent.instance.reset();
      }
    } catch (e) {
      print('Error handling initial media: $e');
    }
  }

  void _checkPendingSharedFiles() {
    if (_sharedFiles.isNotEmpty) {
      _navigateToCreatePost();
    }
  }

  Future<void> _navigateToCreatePost() async {
    try {
      final token = await _sharedPreferenceHelper.getAccessToken;
      final isLoggedIn = token != null && token.isNotEmpty;

      if (isLoggedIn && mounted) {
        router.push(AuthRoutes.CREATE_POST);
      } else if (mounted) {
        router.push(AuthRoutes.LOGIN);
      }
    } catch (e) {
      print('Error navigating to create post: $e');
    }
  }

  // --------------------------
  // 👤 User Presence Handling
  // --------------------------
  Future<void> _loadUserId() async {
    final token = _sharedPreferenceHelper.getAccessToken;
    if (token != null && token.isNotEmpty) {
      _userId = _sharedPreferenceHelper.getIdUser;
      _firebasePresenceService.setupUserPresence(_userId!);
    }
  }

  // --------------------------
  // 🖼 UI
  // --------------------------
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      ensureScreenSize: true,
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: const Size(360, 800),
      useInheritedMediaQuery: true,
      builder: (context, child) {
        // Init ScreenUtil with AppInit
        AppInit.instance.initScreenUtil(context);

        return Portal(
          child: MaterialApp.router(
            title: 'HandOff VDB 2025',
            routerConfig: router,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
          ),
        );
      },
    );
  }
}
