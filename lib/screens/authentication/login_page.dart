import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
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
  final dio = Dio();
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

  // void checkToken() async {
  //회원가입 이력이 있다.(get으로 admininfo에 요청 응답이 오면 정보가 있다는 의미) = 로그인화면으로 -> 로그인 -> 토큰 저장(final accessToken = await secureStorage.getAccessToken();) -> 마이페이지 화면
  //다음 번 접속시 토큰이 있다. = 자동 로그인(마이페이지로 보내기)
  //회원가입 안 한 상태에서 로그인 버튼을 누르면, showAlertDialog ('해당 관리자 계정이 존재하지 않습니다. 회원가입을 진행해주세요')
  //-> 아이디랑 비밀번호 입력받기 -> 서버로 보내기 -> 응답받아서 예전에 요청 보낸 적이 있는지 확인
//}
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
                    const Divider(thickness: 2),
                    userId(),
                    const Divider(thickness: 1),
                    password(),
                    const Divider(thickness: 1),
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
                          if (_formKey.currentState!.validate() == false) {
                            return;
                          } else {
                            authRepository.loginPressed(adminIdController.text,
                                passwordController.text);
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
      ),
    );
  }

  Widget userId() {
    return RowItems(
      useDropdownMenu: false,
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
      useDropdownMenu: false,
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
