import 'package:flutter/material.dart';
import 'package:haru_admin/screens/authentication/signup_page.dart';
import 'package:haru_admin/widgets/borderline.dart';
import 'package:haru_admin/widgets/infoblank.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void onSignupTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          const Text(
            'HaruHangeul\nAdmin Page',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w900,
            ),
          ),
          const BorderLine(thickness: 2),
          const InfoBlank(
            infoname: '아이디',
            textalign: TextAlign.center,
          ),
          const BorderLine(thickness: 1),
          const InfoBlank(
            infoname: '비밀번호',
            textalign: TextAlign.center,
          ),
          const BorderLine(thickness: 2),
          const Text(
            '로그인 정보가 틀렸습니다. (1/10)',
            style: TextStyle(
              color: Color(0xFFF05A2A),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
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
              '로그인',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () => onSignupTap(context),
            child: const Text(
              '회원가입',
              style: TextStyle(
                color: Color(0xFF9C9C9C),
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
