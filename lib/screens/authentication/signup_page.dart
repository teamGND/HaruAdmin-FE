import 'dart:js_interop';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haru_admin/utils/secure_storage.dart';
import 'package:haru_admin/widgets/colors.dart';
import 'package:haru_admin/widgets/divider.dart';
import 'package:haru_admin/widgets/rowitems.dart';

enum Rank {
  master('총 관리자'),
  content('콘텐츠 관리자'),
  translation('번역 관리자');

  const Rank(this.rankname);
  final String rankname;
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final dio = Dio();
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController rankController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Rank? selectedRank;

  String? idError;
  String? passwordError;
  String? confirmPasswordError;
  String? usernameError;
  String? rankError;
  String? phoneNumberError;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
          body: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Center(
                child: Column(children: [
                  const Text(
                    'HaruHangeul\nAdmin\nSign Up',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const LineDivider(thick: 2),
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
                            validator: (value) {
                              value != null;
                              return null;
                            },
                            onChanged: (String value) {
                              setState(() {
                                idError = value.isEmpty ? '아이디를 입력해주세요' : null;
                              });
                              idController;
                            },
                          ),
                          width: 10,
                          textbutton: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              backgroundColor: greycolor,
                            ),
                            child: const Text(
                              '중복확인',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            onPressed: () {}, // 중복확인 로직 짜야함
                          ),
                        ),
                        const LineDivider(thick: 1),
                        RowItems(
                          infoname: '비밀번호',
                          widget: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorText: passwordError,
                            ),
                            controller: passwordController,
                            validator: (value) {
                              value != null;
                              return null;
                            },
                            onChanged: (String value) {
                              setState(() {
                                passwordError =
                                    value.isEmpty ? '비밀번호를 입력해주세요' : null;
                              });
                              passwordController;
                            },
                          ),
                        ),
                        const LineDivider(thick: 1),
                        RowItems(
                          infoname: '비밀번호 확인', //비밀번호 맞을 때, 안 맞을 때 짜야함
                          widget: TextFormField(
                            validator: (value) {
                              value != null;
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorText: confirmPasswordError,
                            ),
                            controller: confirmPasswordController,
                            onChanged: (String value) {
                              setState(() {
                                confirmPasswordError =
                                    value.isEmpty ? '비밀번호를 입력해주세요' : null;
                              });
                              confirmPasswordController;
                            },
                          ),
                        ),
                        const LineDivider(thick: 1),
                        RowItems(
                          infoname: '요청권한',
                          widget: DropdownMenu<Rank>(
                            initialSelection: null,
                            controller: rankController,
                            width: MediaQuery.of(context).size.width * 0.2,
                            hintText: '관리자 유형을 선택해주세요.',
                            onSelected: (Rank? rankname) {
                              // This is called when the user selects an item.
                              setState(() {
                                selectedRank = rankname;
                                rankError = (selectedRank == null)
                                    ? '요청 권한을 입력해주세요'
                                    : null;
                              });
                            },
                            dropdownMenuEntries: Rank.values
                                .map<DropdownMenuEntry<Rank>>((Rank rankname) {
                              return DropdownMenuEntry<Rank>(
                                value: rankname,
                                label: rankname.rankname,
                                style: ButtonStyle(
                                  surfaceTintColor: MaterialStateProperty.all(
                                      const Color(0xFFD9D9D9)),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const LineDivider(thick: 1),
                        RowItems(
                          infoname: '이름',
                          widget: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorText: usernameError,
                            ),
                            controller: usernameController,
                            validator: (value) {
                              value != null;
                              return null;
                            },
                            onChanged: (String value) {
                              setState(() {
                                usernameError =
                                    value.isEmpty ? '비밀번호를 입력해주세요' : null;
                              });
                              usernameController;
                            },
                          ),
                        ),
                        const LineDivider(thick: 1),
                        RowItems(
                            infoname: '연락처',
                            widget: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorText: phoneNumberError,
                              ),
                              controller: phoneNumberController,
                              validator: (value) {
                                value != null;
                                return null;
                              },
                              onChanged: (String value) {
                                setState(() {
                                  phoneNumberError =
                                      value.isEmpty ? '를 입력해주세요' : null;
                                });
                                phoneNumberController;
                              },
                            )),
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
                            SecureStorage secureStorage = SecureStorage();
                            // 입력킨 모두 채웠는지 확인 + 서버로 post 보내야함
                            if (_formKey.currentState!.validate() == false) {
                              return;
                            } else {
                              //아이디 중복체크가 확인되면,
                              //if(userIdCheck == null ).
                              final response = await dio.post(
                                '/admin/signup',
                                data: {
                                  "adminId": idController.text,
                                  "name": usernameController.text,
                                  "password": passwordController.text,
                                  "phoneNumber": phoneNumberController.text,
                                  "ranks": rankController.selection,
                                },
                              );

                              if (response.statusCode == 200) {
                                dialog();
                              }
                            }
                          },
                          child: const Text('회원가입'),
                        ),
                      ],
                    ),
                  ),
                ]),
              ))),
    );
  }

  Future<dynamic> dialog() async {
    // code 200 이면,
    if (_formKey.currentState!.validate() == false) {
      return;
    } else {
      _formKey.currentState!.save();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              insetPadding: const EdgeInsets.all(130),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              surfaceTintColor: Colors.white,
              title: const Text(
                '회원가입 완료!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: const Text(
                '관리자의 승인을 기다리는 중입니다.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              actions: [
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: blueColor,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero),
                  ),
                  onPressed: () {
                    context.go('/login'); // login화면으로 이동해야함,
                  },
                  child: const Text('로그인 화면으로'),
                ),
              ],
            );
          });
    }
  }
}
