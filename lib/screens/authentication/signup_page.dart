import 'package:go_router/go_router.dart';
import 'package:haru_admin/api/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:haru_admin/widgets/colors.dart';
import 'package:haru_admin/widgets/divider.dart';
import 'package:haru_admin/widgets/rowitems.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  late final AuthRepository authRepository;
  bool isIdavailable = false;
  RankLabel? selectedRank;
  TextEditingController adminIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController adminNameController = TextEditingController();

  String rankController = 'MASTER';
  TextEditingController phoneNumberController = TextEditingController();

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

  bool saveAndValidateForm(GlobalKey<FormState> formKey) {
    if (!formKey.currentState!.validate()) {
      return false;
    }
    formKey.currentState!.save();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
          body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Center(
              child: Column(children: [
                const Text(
                  'HaruHangeul\nAdmin\nSign Up',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const LineDivider(thick: 2),
                      signUpuserId(),
                      const LineDivider(thick: 1),
                      signUpPassword(),
                      const LineDivider(thick: 1),
                      checkPassword(),
                      const LineDivider(thick: 1),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: const Text(
                              "권한",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: DropdownButton<String>(
                              value: rankController,
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              isExpanded: true,
                              style: const TextStyle(color: Colors.black),
                              underline: Container(
                                height: 2,
                                color: Colors.blue,
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
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      const LineDivider(thick: 1),
                      signUpUsername(),
                      const LineDivider(thick: 1),
                      phoneNumber(),
                      const LineDivider(thick: 2),
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
                            if (!saveAndValidateForm(_formKey) ||
                                !isIdavailable) {
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
                          },
                          child: const Text('회원가입')),
                    ],
                  ),
                ),
              ]),
            )),
      )),
    );
  }

  Widget signUpuserId() {
    return RowItems(
      obscureText: false,
      infoname: '아이디',
      controller: adminIdController,
      onSaved: (value) {
        adminIdController.text = value!;
      },
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return '아이디를 입력해주세요';
        }
        if (!isIdavailable) {
          return '아이디 중복확인을 해주세요';
        }
        return null;
      },
      width: MediaQuery.of(context).size.width * 0.4 - 100,
      textbutton: TextButton(
        style: TextButton.styleFrom(
          fixedSize: const Size(100, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: hintTextColor,
        ),
        onPressed: () async {
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
                  return AlertDialog(
                    title: const Text('아이디 중복'),
                    content: const Text('아이디가 중복되었습니다.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('확인'),
                      ),
                    ],
                  );
                });
          });
        },
        child: isIdavailable
            ? const Icon(Icons.check)
            : const Text(
                '중복확인',
                style: TextStyle(color: Colors.black),
              ),
      ),
    );
  }

  Widget signUpPassword() {
    return RowItems(
      infoname: '비밀번호',
      obscureText: true,
      hintText: '비밀번호는 10~16자로 지정해주세요.',
      controller: passwordController,
      onSaved: (value) {
        passwordController.text = value!;
      },
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return '비밀번호를 입력해주세요';
        }
        if (value!.length >= 17 && value.length <= 9) {
          return '비밀번호는 10~16자로 지정해주세요.';
        }
        return null;
      },
    );
  }

  Widget checkPassword() {
    return RowItems(
      infoname: '비밀번호 확인',
      obscureText: true,
      controller: confirmPasswordController,
      onSaved: (value) {
        confirmPasswordController.text = value!;
      },
      validator: (value) {
        if (value != passwordController.text) {
          return '비밀번호가 일치하지 않습니다.';
        } else if (value!.isEmpty) {
          return '비밀번호를 입력해주세요';
        }
        return null;
      },
    );
  }

  Widget signUpUsername() {
    return RowItems(
      infoname: '이름',
      obscureText: false,
      onSaved: (value) {
        adminNameController.text = value!;
      },
      controller: adminNameController,
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return '이름을 입력해주세요';
        }
        return null;
      },
    );
  }

  Widget phoneNumber() {
    return RowItems(
      infoname: '연락처',
      obscureText: false,
      controller: phoneNumberController,
      onSaved: (value) {
        phoneNumberController.text = value!;
      },
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
              if (int.parse(value[i]) < 0 || int.parse(value[i]) > 9) {
                return '연락처 형식에 맞게 입력해주세요';
              }
            }
          }
          return null;
        }
      },
    );
  }
}
