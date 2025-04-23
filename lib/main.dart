import 'package:flutter/material.dart';
import 'package:haru_admin/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp.router(
        routerConfig: router,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF2F2F2),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4A4A4A),
            primary: const Color(0xFF4A4A4A),
            secondary: const Color(0xFF4A4A4A),
            surface: const Color(0xFFFFFFFF),
          ),
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    ),
  );
}
