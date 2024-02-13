import 'package:flutter/material.dart';

const List<String> levelType = ['자음모음', '1급', '2급', '3급', '4급'];

List<VocabularyData> testData = [
  VocabularyData(
      index: 0,
      level: 1,
      title: '-입니다/ 입니까',
      example: 1,
      fix: 'confirmed',
      quiz: '5문제완',
      sentence: '한국 사람입니까? / 영국 사람입니다.',
      cycle: 2,
      step: 3),
];

class GrammerData extends StatefulWidget {
  const GrammerData({super.key});

  @override
  State<GrammerData> createState() => _GrammerDataState();
}

class _GrammerDataState extends State<GrammerData> {
  String dropdownvalue = levelType.first;
  late List<VocabularyData> datas;
  final content = ['No', '레벨', '사이클', '회차', '타이틀', '대표문장', '예시', '수정', '퀴즈'];

  @override
  void initState() {
    super.initState();
    datas = testData;
  }

  // void dataColumnSort(int columnIndex, bool ascending) {
  //   print('dataColumnSort() $columnIndex, $ascending');
  // }

  void dataLevelFilter(String level) {
    int index = levelType.indexWhere((element) => element == level);

    setState(() {
      List<VocabularyData> newDatas =
          testData.where((e) => e.level == index).toList();
      datas = newDatas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          const Text(
            '문법 학습 데이터',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '레벨',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              DropdownMenu<String>(
                width: 300,
                initialSelection: levelType[1],
                onSelected: (String? value) {
                  setState(() {
                    dropdownvalue = value!;
                  });
                  value != null ? dataLevelFilter(value) : null;
                },
                dropdownMenuEntries:
                    levelType.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
              )
            ],
          ),
          const SizedBox(height: 20),
          getDataTable(datas: datas),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        onTap: () => showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  title: Text('tapped'),
                                );
                              },
                            ),
                        child: const Text('<이전')),
                    Container(
                      padding: const EdgeInsets.all(5),
                      width: 50,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          )),
                      child: const Text(
                        '1',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    GestureDetector(
                        onTap: () => showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  title: Text('tapped'),
                                );
                              },
                            ),
                        child: const Text('다음>')),
                  ],
                ),
              ),
              FilledButton(
                  onPressed: () {
                    print('tapped');
                  },
                  style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Color(0xFF3F99F7)),
                  ),
                  child: const Text('회차추가'))
            ],
          ),
        ]),
      ),
    ));
  }

  Widget getDataTable({List<VocabularyData> datas = const []}) {
    return DataTable(
        headingTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        headingRowColor:
            MaterialStatePropertyAll(const Color(0xFFB9B9B9).withOpacity(0.2)),
        border: TableBorder.all(
          color: const Color(0xFFB9B9B9),
          width: 1,
          style: BorderStyle.solid,
          borderRadius: BorderRadius.zero,
        ),
        horizontalMargin: 20.0,
        columnSpacing: 40.0,
        columns: getColumns(),
        rows: <DataRow>[for (VocabularyData data in datas) dataCellRow(data)]);
  }

//column 데이터
  List<DataColumn> getColumns() {
    List<DataColumn> dataColumn = [];
    for (var i in content) {
      // if (i == 'No') {
      //   dataColumn.add(DataColumn(
      //       label: Center(child: Text(i)),
      //       numeric: true,
      //       onSort: dataColumnSort));
      // }
      //else {
      dataColumn.add(DataColumn(label: Text(i)));
      //}
    }
    return dataColumn;
  }

  //row 데이터
  DataRow dataCellRow(VocabularyData data) {
    return DataRow(cells: <DataCell>[
      DataCell(
        Text(data.index.toString()),
      ),
      DataCell(
        Text(data.level.toString()),
      ),
      DataCell(
        Text(data.cycle.toString()),
      ),
      DataCell(
        Text(data.step.toString()),
      ),
      DataCell(
        Text(data.title.toString()),
      ),
      DataCell(
        Text(data.sentence.toString()),
      ),
      DataCell(
        Text(data.example.toString()),
      ),
      DataCell(
        GestureDetector(onTap: () => print("$data"), child: Text(data.fix)),
      ),
      DataCell(
        GestureDetector(onTap: () => print("tapped"), child: Text(data.quiz)),
      ),
    ]);
  }
}

class VocabularyData {
  int index;
  int level;
  int cycle;
  int step;
  String title;
  String sentence;
  int example;
  String fix;
  String quiz;
  VocabularyData(
      {required this.index,
      required this.level,
      required this.cycle,
      required this.step,
      required this.title,
      required this.sentence,
      required this.example,
      required this.fix,
      required this.quiz});
}
