import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:handoff_vdb_2025/data/services/firebase_presence_service.dart';
import 'package:handoff_vdb_2025/firebase_options.dart';
import 'package:handoff_vdb_2025/config/routes/route_path/auth_routers.dart';
import 'package:handoff_vdb_2025/core/enums/auth_enums.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/shared_pref/shared_preference_helper.dart';
import 'package:handoff_vdb_2025/data/model/post/post_input_model.dart';
import 'package:handoff_vdb_2025/data/model/post/post_link_meta.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Sử dụng try-catch để xử lý duplicate app error
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    if (e.toString().contains('duplicate-app')) {
      print('Firebase already initialized (duplicate app error caught)');
    } else {
      print('Firebase initialization failed: $e');
      rethrow;
    }
  }

  // Initialize all app dependencies
  await AppInit.instance.init();

  // Initialize Hive only for non-web platforms
  if (!kIsWeb) {
    await Hive.initFlutter();
    Hive.registerAdapter(PostInputModelAdapter());
    Hive.registerAdapter(PostLinkMetaAdapter());
    await Hive.openBox<PostInputModel>('pending_posts');
  }

  final createPostStore = AppInit.instance.createPostStore;
  createPostStore.listenNetwork();

  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  late StreamSubscription _intentSub;
  final _sharedFiles = <SharedMediaFile>[];
  final SharedPreferenceHelper _sharedPreferenceHelper = AppInit.instance.sharedPreferenceHelper;
  final FirebasePresenceService _firebasePresenceService = AppInit.instance.firebasePresenceService;
  bool _isAppReady = false;

  String? _userId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Get userId after login
    _loadUserId();

    // Set up stream listener for shared files (only for mobile platforms)
    if (!kIsWeb) {
      _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen(
        (value) {
          _handleReceivedFiles(value);
          ReceiveSharingIntent.instance.reset();
        },
        onError: (err) {
          print("getIntentDataStream error: $err");
        },
      );

      // Handle initial media
      _handleInitialMedia();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Mark app as ready after dependencies change
    if (!_isAppReady) {
      _isAppReady = true;
      // Check for pending shared files
      _checkPendingSharedFiles();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (_userId == null) return;

    if (state == AppLifecycleState.resumed) {
      // Khi app quay lại foreground → refresh online
      _firebasePresenceService.setupUserPresence(_userId!);
    }
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      _intentSub.cancel();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _handleReceivedFiles(List<SharedMediaFile> files) async {
    if (files.isEmpty) return;

    _sharedFiles
      ..clear()
      ..addAll(files);

    try {
      await _sharedPreferenceHelper.setReceivedValue(
        _sharedFiles.map((f) => f.path).toList(),
      );

      // Only navigate when app is ready
      if (_isAppReady) {
        await _navigateToCreatePost();
      }
    } catch (e) {
      print('Error handling shared files: $e');
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

  Future<void> _handleInitialMedia() async {
    if (kIsWeb) return; // Skip on web
    
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

  Future<void> _loadUserId() async {
    final token = _sharedPreferenceHelper.getAccessToken;
    if (token != null && token.isNotEmpty) {
      // Ví dụ: decode token ra userId, hoặc fetch từ backend
      _userId = _sharedPreferenceHelper.getIdUser;
      _firebasePresenceService.setupUserPresence(_userId!);
    }
  }

  void _checkPendingSharedFiles() {
    if (_sharedFiles.isNotEmpty) {
      _navigateToCreatePost();
    }
  }


  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      ensureScreenSize: true,
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: const Size(360, 800),
      useInheritedMediaQuery: true,
      builder: (context, child) {
        // Initialize ScreenUtil with AppInit
        AppInit.instance.initScreenUtil(context);

        return Portal(
          child: MaterialApp.router(
            title: 'HandOff VDB 2025',
            routerConfig: router,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true, // Enable Material 3
            ),
          ),
        );
      },
    );
  }
}
