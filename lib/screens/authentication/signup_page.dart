import 'package:go_router/go_router.dart';
import 'package:haru_admin/api/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:haru_admin/widgets/colors.dart';
import 'package:haru_admin/widgets/divider.dart';
import 'package:haru_admin/widgets/rowitems.dart';

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
  TextEditingController rankController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    adminIdController = TextEditingController(text: '');
    passwordController = TextEditingController(text: '');
    confirmPasswordController = TextEditingController(text: '');
    adminNameController = TextEditingController(text: '');
    rankController = TextEditingController(text: '');
    phoneNumberController = TextEditingController(text: '');
    authRepository = AuthRepository();
  }

  @override
  void dispose() {
    adminIdController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    adminNameController.dispose();
    rankController.dispose();
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    context
                        .go('/login'); // Navigate back to the previous screen
                  },
                ),
                const Center(
                  child: Text(
                    'HaruHangeul\nAdmin\nSign Up',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Form(
                      key: _formKey,
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
                          rank(),
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
                                if (!saveAndValidateForm(_formKey)) {
                                  return;
                                }
                                await authRepository.signup(
                                  adminIdController.text,
                                  passwordController.text,
                                  adminNameController.text,
                                  selectedRank,
                                  phoneNumberController.text,
                                );
                              },
                              child: const Text('회원가입')),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget signUpuserId() {
    return RowItems(
      obscureText: false,
      useDropdownMenu: false,
      infoname: '아이디',
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
      width: 10,
      textbutton: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: hintTextColor,
        ),
        onPressed: () async {
          await authRepository.adminIdCheck(adminIdController.text);
        },
        child: isIdavailable ? const Icon(Icons.check) : const Text('중복확인'),
      ),
    );
  }

  Widget signUpPassword() {
    return RowItems(
      useDropdownMenu: false,
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
      useDropdownMenu: false,
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

  Widget rank() {
    return const RowItems(
      obscureText: false,
      infoname: '요청권한',
      validator: null,
      useDropdownMenu: true,
      controller: null,
    );
  }

  Widget signUpUsername() {
    return RowItems(
      useDropdownMenu: false,
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
      useDropdownMenu: false,
      infoname: '연락처',
      obscureText: false,
      controller: phoneNumberController,
      onSaved: (value) {
        phoneNumberController.text = value!;
      },
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return '연락처를 입력해주세요';
        }
        return null;
      },
    );
  }
}
