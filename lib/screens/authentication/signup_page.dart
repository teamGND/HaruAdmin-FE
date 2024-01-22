import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:haru_admin/screens/authentication/login_page.dart';
import 'package:haru_admin/utils/secure_storage.dart';
import 'package:haru_admin/widgets/id_area.dart';
import 'package:haru_admin/widgets/divider.dart';
import 'package:haru_admin/widgets/phonenumber_area.dart';
import 'package:haru_admin/widgets/rank_area.dart';
import 'package:haru_admin/widgets/information_area.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  SecureStorage secureStorage = SecureStorage();
  final dio = Dio();
  var username = '';
  var password = '';
  var name = '';
  var rank = '';
  var phoneNumber = '';

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
            const LineDivider(thick: 2),
            const IdArea(),
            const LineDivider(thick: 1),
            const InformantionArea(
              Width: 330,
              infoname: '비밀번호',
              hideword: true,
              memo: '',
            ),
            const LineDivider(thick: 1),
            const InformantionArea(
              Width: 330,
              infoname: '비밀번호 확인',
              hideword: true,
              memo: '비밀번호는 10~16자로 지정해주세요.',
            ),
            const LineDivider(thick: 1),
            const RankArea(),
            const LineDivider(thick: 1),
            const InformantionArea(
              Width: 330,
              infoname: '이름',
              hideword: false,
              memo: '',
            ),
            const LineDivider(thick: 1),
            const PhoneNumberArea(),
            const LineDivider(thick: 2),
            const SizedBox(
              height: 20,
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
                onPressed: () async {
                  final rawString =
                      '$username:$password:$name:$rank:$phoneNumber';
                  // 토큰 발급을 위하여 string을  base64로 인코딩 코드
                  Codec<String, String> stringToBase64 = utf8.fuse(base64);
                  String token = stringToBase64.encode(rawString);

                  final resp = await dio.post(
                    'http://testUrl/login', // 아직 url 안 나온 상태
                    options:
                        Options(headers: {'Authorization': 'Basic $token'}),
                  );

                  // 회원가입 성공시 -> 회원가입 승인 대기중입니다. dialog띄워야함.
                  if (resp.statusCode == 200) {
                    // 일단은 api서버를 통해 발급받은 accessToken 저장하지 않음.
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('회원가입 완료!'),
                          content: Column(
                            children: [
                              const Text('관리자의 승인을 기다리는 중입니다.'),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  // 이 버튼이 눌렸을 때 로그인 화면으로 이동하도록 할 수 있습니다.
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const LoginPage()),
                                  );
                                },
                                child: const Text('로그인 화면으로'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
                child: const Text('회원가입'))
          ],
        ),
      ),
    );
  }
}
