import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:haru_admin/utils/secure_storage.dart';

SecureStorage secureStorage = SecureStorage();
final dio = Dio();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  SecureStorage secureStorage = SecureStorage();
  final dio = Dio();
  var username = '';
  var password = '';

  @override // 위젯이 처음 생성되었을 때 하고 싶은 작업
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    top: 200.0,
                  ),
                ),
                const Text(
                  'HaruHangeul\nAdmin Page',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InputArea(
                  infoname: '아이디',
                  topwidth: 2,
                  value: username,
                ),
                InputArea(
                  infoname: '비밀번호',
                  topwidth: 0,
                  value: password,
                ),
                ElevatedButton(
                  // 로그인 버튼을 누를 때, 토큰 읽어오기
                  onPressed: () async {
                    secureStorage.getAccessToken(context);
                  },
                  child: const Text('로그인'),
                ),
              ],
            ),
          ),
        ));
  }
}

class InputArea extends StatelessWidget {
  final String infoname;
  final double topwidth;
  final String value;

  const InputArea({
    super.key,
    required this.infoname,
    required this.topwidth,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: 80,
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: topwidth, color: Colors.grey),
          bottom: const BorderSide(width: 1, color: Colors.grey),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              infoname,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            child: TextField(
              onChanged: (value) {
                value = value;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
