import 'package:flutter/material.dart';

class Mypage extends StatefulWidget {
  const Mypage({Key? key}) : super(key: key);

  @override
  State<Mypage> createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  var info = [
    {'key': '아이디', 'val': "test", 'chage': false},
    {'key': '비밀번호', 'val': "testpw", 'chage': true},
    {'key': '이름', 'val': "testname", 'chage': true},
    {'key': '연락처', 'val': "010-xx", 'chage': true},
    {'key': '관리자등급', 'val': "test", 'chage': false},
  ];

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
                for (var i in info)
                  Container(
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
                            child: Text(i['key'] as String),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Text(i['val'] as String),
                          ),
                          const SizedBox(width: 30),
                          if (i['chage'] as bool)
                            TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return changeAdminPopUp(
                                      context: context,
                                      title: i['key'] as String,
                                      content: i['val'] as String,
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
                      )),
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
