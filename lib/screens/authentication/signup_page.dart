import 'package:flutter/material.dart';
import 'package:haru_admin/widgets/borderline.dart';
import 'package:haru_admin/widgets/request_auth_area.dart';
import 'package:haru_admin/widgets/information_area.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Text(
              'HaruHangeul\nAdmin Page\nSign Up',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
            BorderLine(thick: 2),
            InformantionArea(
              infoname: '아이디',
              hideword: false,
              memo: '',
            ),
            BorderLine(thick: 1),
            InformantionArea(
              infoname: '비밀번호',
              hideword: true,
              memo: '',
            ),
            BorderLine(thick: 1),
            InformantionArea(
              infoname: '비밀번호 확인',
              hideword: true,
              memo: '비밀번호는 10~16자로 지정해주세요.',
            ),
            BorderLine(thick: 1),
            AuthorityArea(),
            BorderLine(thick: 1),
            InformantionArea(
              infoname: '이름',
              hideword: false,
              memo: '',
            ),
            BorderLine(thick: 1),
            InformantionArea(
              infoname: '연락처',
              hideword: false,
              memo: '',
            ),
            BorderLine(thick: 2),
          ],
        ),
      ),
    );
  }
}
