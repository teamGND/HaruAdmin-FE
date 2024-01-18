import 'package:flutter/material.dart';

import 'router.dart';
import 'package:haru_admin/screens/authentication/login_page.dart';

import 'screens/authentication/signup_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
