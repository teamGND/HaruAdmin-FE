import 'package:flutter/material.dart';
import 'package:haru_admin/widgets/borderline.dart';
import 'package:haru_admin/widgets/phonenumber_area.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            const Text(
              'HaruHangeul\nAdmin Page\nSign Up',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
            const BorderLine(thick: 2),
            const InformantionArea(
              infoname: '아이디',
              hideword: false,
              memo: '',
            ),
            const BorderLine(thick: 1),
            const InformantionArea(
              infoname: '비밀번호',
              hideword: true,
              memo: '',
            ),
            const BorderLine(thick: 1),
            const InformantionArea(
              infoname: '비밀번호 확인',
              hideword: true,
              memo: '비밀번호는 10~16자로 지정해주세요.',
            ),
            const BorderLine(thick: 1),
            const AuthorityArea(),
            const BorderLine(thick: 1),
            const InformantionArea(
              infoname: '이름',
              hideword: false,
              memo: '',
            ),
            const BorderLine(thick: 1),
            const PhoneNumberArea(),
            const BorderLine(thick: 2),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF3F99F7),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 100,
                  vertical: 20,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
              onPressed: () {},
              child: const Text(
                '회원가입',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
