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
      ),
    );
  }
}
