import 'package:flutter/material.dart';
import 'package:haru_admin/api/auth_services.dart';
import 'package:haru_admin/model/auth_model.dart';

class Mypage extends StatefulWidget {
  const Mypage({Key? key}) : super(key: key);

  @override
  State<Mypage> createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  AuthRepository authRepository = AuthRepository();
  String rankController = 'MASTER';

  // @override
  // void initState() {
  //   super.initState();
  //   authRepository.getMyInfo().then((value) {
  //     setState(() {
  //       _myInfo = value;
  //     });
  //   });
  // }

  Future<MyInfo> fetchIntroDataList() async {
    try {
      return await AuthRepository().getMyInfo();
    } catch (e) {
      print(e);
      throw Exception('Failed to load data');
    }
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
            // if (content == '등급')
            //   SizedBox(
            //     width: MediaQuery.of(context).size.width * 0.4,
            //     child: DropdownButton<String>(
            //       value: rankController,
            //       icon: const Icon(Icons.arrow_drop_down),
            //       iconSize: 24,
            //       elevation: 16,
            //       isExpanded: true,
            //       style: const TextStyle(color: Colors.black),
            //       underline: Container(
            //         height: 2,
            //         color: Colors.blue,
            //       ),
            //       onChanged: (String? newValue) {
            //         setState(() {
            //           rankController = newValue!;
            //         });
            //       },
            //       items: <String>['MASTER', 'CONTENTS', 'TRANSLATION']
            //           .map<DropdownMenuItem<String>>((String value) {
            //         return DropdownMenuItem<String>(
            //           value: value,
            //           child: Text(value),
            //         );
            //       }).toList(),
            //     ),
            //   )
            // else if (content == '연락처')
            //   SizedBox(
            //     width: MediaQuery.of(context).size.width * 0.4,
            //     child: TextField(
            //       controller: TextEditingController(
            //         text: content,
            //       ),
            //     ),
            //   )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchIntroDataList(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData == false) {
          return const FractionallySizedBox(
            widthFactor: 0.1,
            heightFactor: 0.1,
            child: CircularProgressIndicator(
              color: Colors.blue,
              strokeWidth: 4,
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else {
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
                  buildInfoList('사번', snapshot.data!.seq.toString(), false),
                  buildInfoList('아이디', snapshot.data!.name.toString(), false),
                  buildInfoList('등급', snapshot.data!.rank.toString(), true),
                  buildInfoList(
                      '연락처', snapshot.data!.phoneNumber.toString(), true),
                ],
              ),
            ),
          );
        }
      },
    );
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
