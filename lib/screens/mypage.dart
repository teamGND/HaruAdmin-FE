import 'package:flutter/material.dart';
import 'package:haru_admin/api/auth_services.dart';
import 'package:haru_admin/model/auth_model.dart';

class Mypage extends StatefulWidget {
  const Mypage({Key? key}) : super(key: key);

  @override
  State<Mypage> createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  dynamic myInfo;
  AuthRepository authRepository = AuthRepository();

  @override
  void initState() {
    super.initState();
    authRepository.getMyInfo().then((value) {
      setState(() {
        myInfo = value;
      });
    });
  }

  Widget buildInfoList(String text, String content, bool change) {
    return Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.6,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.8, color: Colors.grey),
          ),
        ),
        child: Row(
          children: [
            Container(
              color: const Color.fromARGB(255, 244, 244, 244),
              height: 48,
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.2,
              child: Text(text),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Text(content),
            ),
            const SizedBox(width: 30),
            if (change)
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return changeAdminPopUp(
                        context: context,
                        title: text,
                        content: content,
                      );
                    },
                  );
                },
                child: const Text(
                  '변경',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: const EdgeInsets.only(bottom: 10),
                    decoration: const BoxDecoration(
                        border: Border(
                      bottom: BorderSide(width: 0.8, color: Colors.grey),
                    )),
                    child: const Text('나의 관리자 정보',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))),
                buildInfoList('사번', myInfo.adminId.toString(), false),
                buildInfoList('아이디', myInfo.name.toString(), true),
                buildInfoList('등급', myInfo.rank.toString(), true),
                buildInfoList('연락처', myInfo.phoneNumber.toString(), true),
              ],
            )));
  }
}

AlertDialog changeAdminPopUp({
  required context,
  required String title,
  required String content,
}) {
  return AlertDialog(
    title: Text(title + ' 변경'.toString()),
    content: TextField(
      controller: TextEditingController(text: content),
    ),
    actions: [
      ElevatedButton(
        onPressed: () {
          // change the content
          Navigator.of(context).pop();
        },
        child: const Text('저장'),
      ),
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('닫기'),
      ),
    ],
  );
}
