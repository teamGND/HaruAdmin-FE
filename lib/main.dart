import 'package:flutter/material.dart';
import 'package:haru_admin/router.dart';
import 'package:haru_admin/screens/test/entity/test_entity.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TestDataEntityProvider()),
      ],
      child: MaterialApp.router(
          routerConfig: router,
          theme: ThemeData(
            useMaterial3: true,
            dataTableTheme: DataTableThemeData(
              headingRowColor: MaterialStateColor.resolveWith(
                  (states) => const Color(0xFFB9B9B9)), // 테이블 헤더 색상
              dataTextStyle: const TextStyle(fontSize: 14),
              headingTextStyle: const TextStyle(fontSize: 14),
            ),
          )),
    );
  }
}
