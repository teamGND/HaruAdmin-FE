import 'package:flutter/material.dart';
import 'package:haru_admin/api/auth_services.dart';
import 'package:haru_admin/api/network/dio_client.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final content = ['사번', '아이디', '이름', '연락처', '관리자 권한', '상태'];
  int totalPage = 1;
  int totalElements = 0;
  List<dynamic> adminData = [];

  final dio = DioClient().provideDio();
  final authRepository = AuthRepository();

  @override
  void initState() {
    super.initState();
    authRepository.getAdminList(1).then((value) {
      setState(() {
        adminData = value['adminData'];
        totalPage = value['totalPage'];
        totalElements = value['totalElements'];
      });
    });
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
          DataTable(
            columns: _buildColumns(),
            rows: _buildRows(),
          ),
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
                        authRepository.getAdminList(i).then((value) {
                          setState(() {
                            adminData = value['adminData'];
                            totalPage = value['totalPage'];
                            totalElements = value['totalElements'];
                          });
                        });
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

  List<DataColumn> _buildColumns() {
    return content.map((String columnName) {
      return DataColumn(
        label: Text(
          columnName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }).toList();
  }

  List<DataRow> _buildRows() {
    return adminData.map((adminData) {
      return DataRow(
        cells: [
          DataCell(Text(adminData.id.toString())),
          DataCell(Text(adminData.adminId ?? "none")),
          DataCell(Text(adminData.name ?? "none")),
          DataCell(Text(adminData.phoneNumber ?? "none")),
          DataCell(Text(adminData.ranks ?? "none")),
          DataCell(
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return buildAlertDialog(context);
                    });
                // Add your custom logic here
              },
              child: Text(
                adminData.status == 'WAIT' ? "대기" : "승인",
                style: TextStyle(
                  color: adminData.status == 'WAIT' ? Colors.red : Colors.blue,
                ), // Set the text color to blue
              ),
            ),
          ),
        ],
      );
    }).toList();
  }
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
