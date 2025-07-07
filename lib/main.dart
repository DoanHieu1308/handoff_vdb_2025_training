import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/config/routes/route_path/auth_routers.dart';
import 'package:handoff_vdb_2025/presentation/pages/login/login_page.dart';
import 'package:handoff_vdb_2025/presentation/pages/sign_up/sign_up_page.dart';
import './presentation/pages/dash_board/dash_board_page.dart';

void main() {
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

