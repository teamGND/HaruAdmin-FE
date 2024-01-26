import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:haru_admin/utils/secure_storage.dart';
import 'package:haru_admin/widgets/colors.dart';
import 'package:haru_admin/widgets/rowitems.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final dio = Dio();
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? idError;
  String? passwordError;

  @override // 위젯이 처음 생성되었을 때 하고 싶은 작업
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 200),
          child: Center(
            child: Column(children: [
              const Text(
                'HaruHangeul\nAdmin Page',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(
                  children: [
                    const Divider(
                      thickness: 2,
                    ),
                    RowItems(
                      infoname: '아이디',
                      widget: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorText: idError,
                        ),
                        controller: idController,
                        onChanged: (String value) {
                          setState(() {
                            idError = value.isEmpty ? '아이디를 입력해주세요' : null;
                          });
                          idController;
                        },
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    RowItems(
                      infoname: '비밀번호',
                      widget: TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            errorText: passwordError),
                        onChanged: (String value) {
                          passwordError = value.isEmpty ? '비밀번호를 입력해주세요' : null;
                        },
                      ),
                    ),

                    const Divider(
                      thickness: 1,
                    ),
                    // 로그인 버튼 누르는 숫자 카운트 10번까지 10이 되면, 로그인 접근 막기->관리자에게 문의해주세요 메세지 프린트
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: blueColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 130,
                          vertical: 25,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                        ),
                      ),

                      // 로그인 버튼을 누를 때, 토큰 발급
                      onPressed: () async {
                        SecureStorage secureStorage = SecureStorage();
                        dynamic value = secureStorage.getAccessToken();
                        if (value == null) {
                          // 토큰이 없으면 회원가입 알림 띄우기  넘기기
                        } else {
                          final rawString =
                              '${idController.text}:${passwordController.text}';
                          Codec<String, String> stringToBase64 =
                              utf8.fuse(base64);
                          print(stringToBase64);
                          String token = stringToBase64.encode(rawString);
                          print(token);
                          final response = await dio.post(
                            'http://3.38.61.170:8080/admin/login', //example
                            options: Options(
                              headers: {
                                'Authorization': 'Basic $token',
                              },
                            ),
                          );
                          print(response.data);
                          if (response.statusCode == 200) {
                            secureStorage.setAccessToken(token);
                            print(json.encode(response.data));
                            context.go('/mypage');
                          } else {
                            print(response.statusMessage);
                          }
                        }
                      },

                      //access 토큰 + refresh토큰 발급
                      child: const Text('로그인'),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void loginChenk() async {
    print(idController.text);
    print(passwordController.text);

    SecureStorage secureStorage = SecureStorage();
    dynamic value = secureStorage.getAccessToken();
    if (value == null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('계정정보가 없습니다. '),
              content: const Text('회원가입을 진행해주세요'),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    context.go('/login');
                  },
                  child: const Text('뒤로가기'),
                ),
              ],
            );
          });
    }
  }
}
