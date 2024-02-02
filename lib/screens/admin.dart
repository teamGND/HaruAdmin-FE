import 'package:flutter/material.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final content = ['사번', '아이디', '이름', '연락처', '관리자 권한', '상태'];
  final List<List<String>> rowData = [
    // example
    ['001', 'user1', 'John Doe', '123-456-7890', 'Admin', '대기'],
    ['002', 'user2', 'Jane Smith', '987-654-3210', 'User', '승인'],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
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
        )
      ],
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
    return rowData.map((List<String> rowData) {
      return DataRow(
        cells: rowData.map((String cellData) {
          if (rowData.indexOf(cellData) == 5) {
            return DataCell(
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
                  cellData,
                  style: TextStyle(
                    color: cellData == '승인'
                        ? Colors.blue
                        : (cellData == '대기' ? Colors.red : Colors.black),
                  ), // Set the text color to blue
                ),
              ),
            );
          } else {
            return DataCell(Text(cellData));
          }
        }).toList(),
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