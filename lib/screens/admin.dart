import 'package:flutter/material.dart';
import 'package:haru_admin/api/auth_services.dart';
import 'package:haru_admin/api/network/dio_client.dart';
import 'package:haru_admin/themes/colors.dart';
import 'package:haru_admin/widgets/button.dart';
import 'package:haru_admin/widgets/popup_modal.dart';
import 'package:haru_admin/widgets/status_chip.dart';

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
    authRepository.getAdminList(0).then((value) {
      setState(() {
        adminData = value['adminData'];
        totalPage = value['totalPage'];
        totalElements = value['totalElements'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width -
                    80, // Account for margin
              ),
              child: DataTable(
                columns: _buildColumns(),
                rows: _buildRows(),
                // Optional: Adjust column spacing for better appearance
                columnSpacing: 20,
                dataTextStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
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
                          color: Colors.black,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return content.map((String columnName) {
      return DataColumn(
        label: Text(
          columnName,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF585858),
          ),
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
            StatusChip(
              status: DataStatus.fromString(adminData.status),
            ),
            // InkWell(
            //   onTap: () {
            //     showDialog(
            //         context: context,
            //         builder: (BuildContext context) {
            //           return buildAlertDialog(context);
            //         });
            //     // Add your custom logic here
            //   },
            //   child: Text(
            //     adminData.status == 'WAIT' ? "대기" : "승인",
            //     style: TextStyle(
            //       color: adminData.status == 'WAIT' ? Colors.red : Colors.blue,
            //     ), // Set the text color to blue
            //   ),
            // ),
          ),
        ],
      );
    }).toList();
  }
}

PopupModal buildAlertDialog(context) {
  return PopupModal(
    title: '계정 상태 변경',
    content: '계정 정보',
    actions: [
      ClickableButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
          text: '취소'),
      ClickableButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: ColorPallete.red,
          text: '삭제'),
      ClickableButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: ColorPallete.green,
          text: '승인'),
    ],
  );
}
