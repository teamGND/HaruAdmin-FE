import 'package:go_router/go_router.dart';
import 'package:haru_admin/api/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:haru_admin/themes/colors.dart';
import 'package:haru_admin/widgets/auth_input.dart';
import 'package:haru_admin/widgets/button.dart';
import 'package:haru_admin/widgets/colors.dart';
import 'package:haru_admin/widgets/dot.dart';
import 'package:haru_admin/widgets/gaps.dart';
import 'package:haru_admin/widgets/popup_modal.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  late final AuthRepository authRepository;
  bool isIdavailable = false;
  TextEditingController adminIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController adminNameController = TextEditingController();

  String rankController = 'MASTER';
  TextEditingController phoneNumberController = TextEditingController();

  bool saveAndValidateForm(GlobalKey<FormState> formKey) {
    if (!formKey.currentState!.validate()) {
      return false;
    }
    formKey.currentState!.save();
    return true;
  }

  signup() async {
    if (!saveAndValidateForm(_formKey) || !isIdavailable) {
      return;
    }
    authRepository.signup(
      adminIdController.text,
      passwordController.text,
      adminNameController.text,
      rankController,
      phoneNumberController.text,
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('회원가입 성공'),
            content: const Text('회원가입이 완료되었습니다.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/login');
                },
                child: const Text('확인'),
              ),
            ],
          );
        });
  }

  checkId(value) async {
    await authRepository
        .adminIdCheck(adminIdController.text)
        .then((response) => {
              print(response),
              if (response.statusCode == 200)
                {
                  setState(() {
                    isIdavailable = true;
                  }),
                }
            })
        .catchError((e) {
      setState(() {
        isIdavailable = false;
      });
      showDialog<Widget>(
          context: context,
          builder: (BuildContext context) {
            return PopupModal(
                title: '아이디 중복',
                content: '아이디가 중복되었습니다.',
                actions: [
                  ClickableButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: Colors.black,
                    text: '확인',
                    size: ButtonSize.medium,
                  )
                ]);
          });
    });
  }

  @override
  void initState() {
    super.initState();
    adminIdController = TextEditingController(text: '');
    passwordController = TextEditingController(text: '');
    confirmPasswordController = TextEditingController(text: '');
    adminNameController = TextEditingController(text: '');
    phoneNumberController = TextEditingController(text: '');
    authRepository = AuthRepository();
  }

  @override
  void dispose() {
    adminIdController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    adminNameController.dispose();
    phoneNumberController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Center(
            child: Column(children: [
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
              SizedBox(
                width: 700,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.go('/login');
                      },
                      child: const Text(
                        '< 로그인 페이지',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF4A4A4A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Gaps.v5,
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
                        Row(
                          children: [
                            Expanded(
                              child: AuthInput(
                                adminIdController: adminIdController,
                                label: '아이디',
                                hint: '아이디를 입력하세요',
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return '아이디를 입력해주세요';
                                  }
                                  if (!isIdavailable) {
                                    return '아이디 중복확인을 해주세요';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            // 중복확인 버튼
                            TextButton(
                              style: TextButton.styleFrom(
                                fixedSize: const Size(80, 55),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                backgroundColor: hintTextColor,
                              ),
                              onPressed: () {
                                checkId(adminIdController.text);
                              },
                              child: isIdavailable
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 24,
                                    )
                                  : const Text('중복 확인',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500)),
                            ),
                            Gaps.h32
                          ],
                        ),
                        AuthInput(
                          adminIdController: passwordController,
                          label: '비밀번호',
                          hint: '비밀번호를 입력하세요',
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return '비밀번호를 입력해주세요';
                            }
                            if (value!.length >= 17 && value.length <= 9) {
                              return '비밀번호는 10~16자로 지정해주세요.';
                            }
                            return null;
                          },
                        ),
                        AuthInput(
                          adminIdController: confirmPasswordController,
                          label: '비밀번호 확인',
                          hint: '비밀번호를 다시 입력하세요',
                          validator: (value) {
                            if (value != passwordController.text) {
                              return '비밀번호가 일치하지 않습니다.';
                            } else if (value!.isEmpty) {
                              return '비밀번호를 입력해주세요';
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 30,
                            left: 20,
                            right: 30,
                          ),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 100,
                                child: Text(
                                  '권한',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              Gaps.h20,
                              Expanded(
                                child: DropdownButton<String>(
                                  value: rankController,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  isExpanded: true,
                                  style: const TextStyle(color: Colors.black),
                                  underline: Container(
                                    height: 1,
                                    color: const Color(0xFF676767),
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      rankController = newValue!;
                                    });
                                  },
                                  items: <String>[
                                    'MASTER',
                                    'CONTENTS',
                                    'TRANSLATION'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        AuthInput(
                          adminIdController: adminNameController,
                          label: '이름',
                          hint: '이름을 입력하세요',
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return '이름을 입력해주세요';
                            }
                            return null;
                          },
                        ),
                        AuthInput(
                          adminIdController: phoneNumberController,
                          label: '연락처',
                          hint: '010-0000-0000',
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return '연락처를 입력해주세요';
                            } else {
                              for (int i = 0; i < value!.length; i++) {
                                // 010-0000-0000 형태로 입력 확인
                                if (i == 3 || i == 8) {
                                  if (value[i] != '-') {
                                    return '연락처 형식에 맞게 입력해주세요';
                                  }
                                } else {
                                  if (int.parse(value[i]) < 0 ||
                                      int.parse(value[i]) > 9) {
                                    return '연락처 형식에 맞게 입력해주세요';
                                  }
                                }
                              }
                              return null;
                            }
                          },
                        ),
                        Gaps.v40,
                        ClickableButton(
                          onPressed: signup,
                          color: Colors.black,
                          text: '회원가입',
                          size: ButtonSize.extraLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          )),
    ));
  }
}
