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
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          ),
          dataTableTheme: DataTableThemeData(
            headingRowColor: MaterialStateColor.resolveWith(
                (states) => const Color(0xFFB9B9B9)), // 테이블 헤더 색상
            headingTextStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            dataTextStyle: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    ),
  );
}
