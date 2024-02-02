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
    checkToken();
  }

  void checkToken() async {
    final accessToken = await secureStorage.getAccessToken();
    if (accessToken == null) {
      //showdialog를 그 때가서 쓰도록, alertdialog만 뺴서 갖다 붙히던지 + context.go도
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actions: [
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: blueColor,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero),
                  ),
                  onPressed: () {
                    context.go('/login');
                    // login화면으로 이동해야함,
                  },
                  child: const Text('로그인 화면으로'),
                ),
              ],
              insetPadding: const EdgeInsets.all(130),
              surfaceTintColor: Colors.white,
              title: const Text('토큰이 없습니다./n회원가입을 진행해주세요.'),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            );
          });
      context.go('/login');
    } else {
      context.go('/mypage');
    }
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
/*로그인 버튼 클릭 횟수 추적 -> State<''>{int index = 0;}
onTap: (int index) {
  setState(({this.index = index;
currentIndex = index}));

}*/
