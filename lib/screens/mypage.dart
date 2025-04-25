import 'package:flutter/material.dart';
import 'package:haru_admin/api/auth_services.dart';
import 'package:haru_admin/model/auth_model.dart';
import 'package:haru_admin/widgets/gaps.dart';

class Mypage extends StatefulWidget {
  const Mypage({Key? key}) : super(key: key);

  @override
  State<Mypage> createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  AuthRepository authRepository = AuthRepository();
  String rankController = 'MASTER';

  Future<MyInfo> fetchIntroDataList() async {
    try {
      return await AuthRepository().getMyInfo();
    } catch (e) {
      print(e);
      throw Exception('Failed to load data');
    }
  }

  Widget buildInfoList(Widget icon, String text) {
    return SizedBox(
        height: 35,
        width: 200,
        child: Row(
          children: [
            icon,
            Gaps.h32,
            Text(text),
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
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    'assets/images/profile.png',
                    width: 100,
                    height: 100,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data!.name.toString(),
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Gaps.v20,
                      buildInfoList(
                          const Text('No.'), snapshot.data!.seq.toString()),
                      buildInfoList(
                          Image.asset(
                            'assets/icons/rank.png',
                            width: 17,
                          ),
                          snapshot.data!.rank.toString()),
                      buildInfoList(
                          Image.asset(
                            'assets/icons/phone.png',
                            width: 17,
                          ),
                          snapshot.data!.phoneNumber.toString()),
                    ],
                  ),
                  Gaps.h5,
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
