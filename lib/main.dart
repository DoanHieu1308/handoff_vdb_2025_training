import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/config/routes/route_path/auth_routers.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/presentation/pages/sign_up/sign_up_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize all app dependencies
  await AppInit.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        
        return MaterialApp(
          title: 'Flutter Demo',
          onGenerateRoute: AuthRouters.routes,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: SignUpPage(),
        );
      },
    );
  }
}

