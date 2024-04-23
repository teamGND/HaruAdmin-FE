import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haru_admin/api/intro_data_services.dart';
import 'package:haru_admin/model/intro_data_model.dart';

class IntroTestScreen extends StatefulWidget {
  const IntroTestScreen({super.key});

  @override
  _IntroTestScreenState createState() => _IntroTestScreenState();
}

class _IntroTestScreenState extends State<IntroTestScreen> {
  late IntroDataList introData;
  late List<IntroListComponentData> datas;
  List<DataRow> rows = [];
  Map<int, bool> selectedRows = {};

  @override
  void initState() {
    super.initState();
    fetchData().then((value) {
      setState(() {
        rows = value;
      });
    });
  }

  final tabletitle = [
    '레벨',
    '유형',
    '회차',
    // '사이클',
    '타이틀',
    '상태',
    '수정',
    '퀴즈/테스트',
  ];

  updateIntroData({
    required String dataCategory,
    required int dataId,
  }) {
    context.go('/test/add/$dataCategory/$dataId');
  }

  Future<List<DataRow>> fetchData() async {
    try {
      await IntroDataRepository()
          .getIntroDataList(page: 0, size: 10)
          .then((value) {
        introData = value;
        datas = value.content;
      });
      List<DataRow> rows = [];

      for (var i = 0; i < datas.length; i++) {
        var data = datas[i];
        rows.add(DataRow(
          cells: <DataCell>[
            DataCell(
              Text(data.level.toString()),
            ),
            DataCell(
              Text(data.category.toString()),
            ),
            DataCell(
              Text(data.chapter.toString()),
            ),
            DataCell(
              Text(data.titleKor.toString()),
            ),
            DataCell(
              Text(data.state.toString()),
            ),
            DataCell(const Text('수정'),
                onTap: updateIntroData(
                  dataCategory: data.category,
                  dataId: data.id,
                )),
            DataCell(
              GestureDetector(
                  onTap: () => print("tapped"), child: const Text('추가')),
            ),
          ],
          selected: selectedRows[i] ?? false,
          onSelectChanged: (isSelected) {
            setState(() {
              selectedRows[i] = isSelected!;
            });
          },
        ));
      }
      return rows;
    } catch (e) {
      print("error : $e");
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text(
                  '인트로 & 퀴즈/테스트 데이터',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                FutureBuilder(
                  future: fetchData(),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error'));
                    } else {
                      return DataTable(
                        headingTextStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        headingRowColor: MaterialStatePropertyAll(
                            const Color(0xFFB9B9B9).withOpacity(0.2)),
                        border: TableBorder.all(
                          color: const Color(0xFFB9B9B9),
                          width: 1,
                          style: BorderStyle.solid,
                          borderRadius: BorderRadius.zero,
                        ),
                        horizontalMargin: 20.0,
                        showCheckboxColumn: true,
                        columnSpacing: 40.0,
                        columns: List.generate(
                          tabletitle.length,
                          (index) => DataColumn(
                            label: Text(
                              tabletitle[index],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        rows: snapshot.data as List<DataRow>,
                      );
                    }
                  }),
                ),
              ],
            ),
          )),
    );
  }
}
