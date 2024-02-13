import 'package:flutter/material.dart';

const List<String> levelType = ['자음모음', '1급', '2급', '3급', '4급'];

List<VocabularyData> testData = [
  VocabularyData(
      index: 0,
      level: 1,
      count: 1,
      tag: '명사',
      title: '동물',
      fix: 'confirmed',
      quiz: '5문제완',
      content: '강아지, 고양이, 사자, 거북이, 양, 토끼, 말',
      cycle: 2,
      step: 3),
  VocabularyData(
      index: 1,
      level: 2,
      tag: '명사',
      title: '동물',
      count: 1,
      fix: 'confirmed',
      quiz: '5문제완',
      content: '강아지, 고양이, 사자, 거북이, 양, 토끼, 말',
      cycle: 2,
      step: 3),
  VocabularyData(
      index: 2,
      level: 3,
      tag: '명사',
      title: '동물',
      count: 1,
      fix: 'confirmed',
      quiz: '5문제완',
      content: '강아지, 고양이, 사자, 거북이, 양, 토끼, 말',
      cycle: 2,
      step: 3),
];

class VocaData extends StatefulWidget {
  const VocaData({super.key});

  @override
  State<VocaData> createState() => _VocaDataState();
}

class _VocaDataState extends State<VocaData> {
  String dropdownvalue = levelType.first;
  late List<VocabularyData> datas;
  final content = [
    'No',
    '레벨',
    '사이클',
    '회차',
    '태그',
    '타이틀',
    '학습내용',
    '개수',
    '수정',
    '퀴즈'
  ];

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
            '단어 학습 데이터',
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
                    padding: MaterialStatePropertyAll(EdgeInsets.all(5)),
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
        Text(data.tag.toString()),
      ),
      DataCell(
        Text(data.title),
      ),
      DataCell(
        Text(data.content.toString()),
      ),
      DataCell(
        Text(data.count.toString()),
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
  String tag;
  String title;
  String content;
  int count;
  String fix;
  String quiz;
  VocabularyData(
      {required this.index,
      required this.level,
      required this.cycle,
      required this.step,
      required this.tag,
      required this.title,
      required this.content,
      required this.count,
      required this.fix,
      required this.quiz});
}
