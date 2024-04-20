import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haru_admin/api/Auth_services.dart';

import 'package:haru_admin/utils/secure_storage.dart';
import 'package:haru_admin/widgets/colors.dart';
import 'package:haru_admin/widgets/rowitems.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late AuthRepository authRepository;
  final SecureStorage secureStorage = SecureStorage();
  TextEditingController adminIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    adminIdController = TextEditingController(text: '');
    passwordController = TextEditingController(text: '');
    authRepository = AuthRepository();
    //checkToken();
  }

  @override
  void dispose() {
    adminIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'HaruHangeul\nAdmin Page',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Column(
                    children: [
                      const Divider(thickness: 2),
                      userId(),
                      const Divider(thickness: 1),
                      password(),
                      const Divider(thickness: 1),
                      TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: blueColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 130,
                              vertical: 25,
                            ),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7)),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate() == false) {
                              return;
                            } else {
                              await authRepository
                                  .loginPressed(adminIdController.text,
                                      passwordController.text)
                                  .then((response) => {
                                        print(response),
                                        if (response.statusCode == 200)
                                          {
                                            context.go('/mypage'),
                                          }
                                      })
                                  .catchError((e) => {
                                        print('로그인 실패: $e'),
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('로그인 실패'),
                                                content: const Text(
                                                    '아이디와 비밀번호를 확인해주세요'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('확인'),
                                                  ),
                                                ],
                                              );
                                            })
                                      });
                            }
                          },
                          child: const Text('로그인')),
                      TextButton(
                          onPressed: () {
                            context.go('/signup');
                          },
                          child: const Text('회원가입'))
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Widget userId() {
    return RowItems(
      infoname: '아이디',
      obscureText: false,
      controller: adminIdController,
      onSaved: (value) {
        adminIdController.text = value!;
      },
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return '아이디를 입력해주세요';
        }
        return null;
      },
    );
  }

  Widget password() {
    return RowItems(
      infoname: '비밀번호',
      obscureText: true,
      onSaved: (value) {
        passwordController.text = value!;
      },
      controller: passwordController,
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return '비밀번호를 입력해주세요';
        }
        return null;
      },
    );
  }
}
