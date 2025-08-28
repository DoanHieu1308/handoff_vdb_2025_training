import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/config/routes/route_path/auth_routers.dart';
import 'package:handoff_vdb_2025/core/enums/auth_enums.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/shared_pref/shared_preference_helper.dart';
import 'package:handoff_vdb_2025/data/model/post/post_input_model.dart';
import 'package:handoff_vdb_2025/data/model/post/post_link_meta.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/create_post_store.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all app dependencies
  await AppInit.instance.init();

  await Hive.initFlutter();
  Hive.registerAdapter(PostInputModelAdapter());
  Hive.registerAdapter(PostLinkMetaAdapter());
  await Hive.openBox<PostInputModel>('pending_posts');

  final createPostStore = AppInit.instance.createPostStore;
  createPostStore.listenNetwork();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription _intentSub;
  final _sharedFiles = <SharedMediaFile>[];
  final SharedPreferenceHelper _sharedPreferenceHelper = AppInit.instance.sharedPreferenceHelper;
  bool _isAppReady = false;

  void _handleReceivedFiles(List<SharedMediaFile> files) async {
    if (files.isEmpty) return;

    _sharedFiles
      ..clear()
      ..addAll(files);

    print("Received ${_sharedFiles.length} shared files");
    
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

  @override
  void initState() {
    super.initState();

    print("Initial shared files: ${_sharedPreferenceHelper.getReceivedValues}");

    // Set up stream listener for shared files
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

  Future<void> _handleInitialMedia() async {
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

  @override
  void dispose() {
    _intentSub.cancel();
    super.dispose();
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
