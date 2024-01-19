import 'package:flutter/material.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final content = ['사번', '아이디', '이름', '연락처', '관리자 권한', '상태'];
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child:
            // make a gride of column = content
            Text('Admin'),
      ),
    );
  }
}
