import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:haru_admin/api/network/log_interceptor.dart';
import 'package:haru_admin/model/auth_model.dart';
import 'package:haru_admin/widgets/colors.dart';

class TotalData extends StatefulWidget {
  const TotalData({super.key});

  @override
  State<TotalData> createState() => _TotalDataState();
}

class _TotalDataState extends State<TotalData> {
  final content = ['레벨', '유형', '회차', '사이클', '데이터셋', '상태', '수정'];
  int totalPage = 1;
  int totalElements = 0;
  List<dynamic> testData = [];

  final Dio dio = Dio(BaseOptions(
    baseUrl: "https://www.haruhangeul.com/admin",
    contentType: 'application/json',
  ))
    ..interceptors.add(CustomLogInterceptor());

  getdataList() async {
    try {
      final response = await dio.get(
        '/test-list',
        options: Options(headers: {
          'Authorization':
              'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJmcm9udCIsImlhdCI6MTcwNzEyMTgwOCwiZXhwIjoxNzE1NzYxODA4fQ.Lj5kDiyhu1oGMqu1hqdA506Xdh2Y30xgX2wtYPjhQ9o',
        }),
      );
      setState(() {
        testData =
            response.data['content'].map((e) => AdminList.fromJson(e)).toList();
        totalPage = response.data['totalPages'];
        totalElements = response.data['totalElements'];

        print(testData);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getdataList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          const Text('관리자 계정 관리',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          // DataTable(
          //   columns: _buildColumns(),
          //   rows: _buildRows(),
          // ),
          // page number list button navigation
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 1; i <= totalPage; i++)
                    TextButton(
                      onPressed: () {
                        getdataList();
                      },
                      child: Text(
                        '$i',
                        style: const TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // List<DataColumn> _buildColumns() {
  //   return content.map((String columnName) {
  //     return DataColumn(
  //       label: Text(
  //         columnName,
  //         style: const TextStyle(fontWeight: FontWeight.bold),
  //       ),
  //     );
  //   }).toList();
  // }

  // List<DataRow> _buildRows() {
  //   return adminData.map((adminData) {
  //     return DataRow(
  //       cells: [
  //         DataCell(Text(adminData.id.toString())),
  //         DataCell(Text(adminData.adminId ?? "none")),
  //         DataCell(Text(adminData.name ?? "none")),
  //         DataCell(Text(adminData.phoneNumber ?? "none")),
  //         DataCell(Text(adminData.ranks ?? "none")),
  //         DataCell(
  //           InkWell(
  //             onTap: () {
  //               showDialog(
  //                   context: context,
  //                   builder: (BuildContext context) {
  //                     return buildAlertDialog(context);
  //                   });
  //               // Add your custom logic here
  //             },
  //             child: Text(
  //               adminData.status == 'WAIT' ? "대기" : "승인",
  //               style: TextStyle(
  //                 color: adminData.status == 'WAIT' ? Colors.red : Colors.blue,
  //               ), // Set the text color to blue
  //             ),
  //           ),
  //         ),
  //       ],
  //     );
  //   }).toList();
  // }
}

AlertDialog buildAlertDialog(context) {
  return AlertDialog(
    title: const Text('계정 상태 변경'),
    content: const Text('계정 정보'),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('취소'),
      ),
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('승인'),
      ),
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('삭제'),
      ),
    ],
  );
}
