import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haru_admin/api/auth_services.dart';
import 'package:haru_admin/themes/colors.dart';

import 'package:haru_admin/utils/secure_storage.dart';
import 'package:haru_admin/widgets/auth_input.dart';
import 'package:haru_admin/widgets/button.dart';
import 'package:haru_admin/widgets/colors.dart';
import 'package:haru_admin/widgets/dot.dart';
import 'package:haru_admin/widgets/gaps.dart';
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

  Future<void> login() async {
    if (_formKey.currentState!.validate() == false) {
      return;
    } else {
      await authRepository
          .loginPressed(adminIdController.text, passwordController.text)
          .then((response) => {
                print(response),
                if (response.statusCode == 200) // 로그인 성공
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
                        content: const Text('아이디와 비밀번호를 확인해주세요'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('확인'),
                          ),
                        ],
                      );
                    })
              });
    }
  }

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
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: 300,
          ),
          Gaps.v10,
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 노란 동그라미
              Dot(color: ColorPallete.wordColor),
              Gaps.h10,
              Dot(color: ColorPallete.grammarColor),
              Gaps.h10,
              Dot(color: ColorPallete.testColor),
            ],
          ),
          Gaps.v28,
          Form(
            key: _formKey,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(40),
                width: 700,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '관리자 로그인',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    AuthInput(
                      adminIdController: adminIdController,
                      label: '아이디',
                      hint: '아이디를 입력하세요',
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return '아이디를 입력해주세요';
                        }
                        return null;
                      },
                    ),
                    AuthInput(
                      adminIdController: passwordController,
                      label: '비밀번호',
                      hint: '비밀번호를 입력하세요',
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return '비밀번호를 입력해주세요';
                        }
                        return null;
                      },
                    ),
                    Gaps.v40,
                    ClickableButton(
                      onPressed: login,
                      color: Colors.black,
                      text: '로그인',
                      size: ButtonSize.extraLarge,
                    ),
                    Gaps.v10,
                    TextButton(
                        onPressed: () {
                          context.go('/signup');
                        },
                        child: const Text('회원가입',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            )))
                  ],
                ),
              ),
            ),
          ),
        ],
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
