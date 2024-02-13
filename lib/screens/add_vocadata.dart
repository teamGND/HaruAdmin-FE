import 'package:flutter/material.dart';
import 'package:haru_admin/widgets/data_search_area.dart';

//디버그 할 때 되는지 확인할려고 11번줄에 이미지 경로 삽입 해놓음. pubspec.yaml asset에
//- lib/assets/images/24451a62-d222-442c-ad71-75008dc85643.jpg 추가해야 함.
const List<String> levelType = <String>['자음모음', '1급', '2급', '3급', '4급'];

List<ModifyVocaModel> testData = [
  ModifyVocaModel(
      index: 1,
      vocabulary: '토끼',
      imagepath: 'lib/assets/images/24451a62-d222-442c-ad71-75008dc85643.jpg',
      filename: 'chapter1_1_1.mp3',
      ENG: '',
      CHN: '',
      VIE: '',
      RUS: '',
      extraExplanation: ''),
];

class ModifyVoca extends StatefulWidget {
  const ModifyVoca({super.key});

  @override
  State<ModifyVoca> createState() => _ModifyVocaState();
}

class _ModifyVocaState extends State<ModifyVoca> {
  String selectedlevel = levelType.first;
  late List<ModifyVocaModel> datas;
  final columnName = [
    '순서',
    '단어',
    '이미지',
    '음성',
    'ENG',
    'CHN',
    'VIE',
    'RUS',
    '추가설명'
  ];

  bool isNounChecked = false;
  bool isVerbChecked = false;
  bool isAdjChecked = false;
  bool isVocaChecked = false;

  @override
  void initState() {
    super.initState();
    datas = testData;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              children: [
                const Text(
                  '단어 회차 데이터 조회/수정',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RequiredInfoName('래벨'),
                      DropdownMenu<String>(
                        width: MediaQuery.of(context).size.width * 0.2,
                        hintText: '레벨을 선택해주세요',
                        onSelected: (String? value) {
                          if (value != null) {
                            setState(() {
                              selectedlevel = value;
                            });
                          }
                        },
                        dropdownMenuEntries: levelType
                            .map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(
                            value: value,
                            label: value,
                          );
                        }).toList(),
                      ),
                      InfoName('사이클'),
                      const textformfield(),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RequiredInfoName('타이틀'),
                        const textformfield(),
                        InfoName('회차'),
                        const textformfield()
                      ],
                    )),
                const SizedBox(height: 5),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InfoName('태그'),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.494,
                          height: 55,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              border:
                                  Border.all(width: 1, color: Colors.black54)),
                          child: Row(
                            children: [
                              Checkbox(
                                  focusColor: (Colors.red),
                                  activeColor: (const Color(0xFF5CD1FF)),
                                  value: isNounChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isNounChecked = value!;
                                    });
                                  }),
                              const Text('명사'),
                              Checkbox(
                                  activeColor: (const Color(0xFF5CD1FF)),
                                  value: isVerbChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isVerbChecked = value!;
                                    });
                                  }),
                              const Text('동사'),
                              Checkbox(
                                  activeColor: (const Color(0xFF5CD1FF)),
                                  value: isAdjChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isAdjChecked = value!;
                                    });
                                  }),
                              const Text('형용사'),
                              Checkbox(
                                  activeColor: (const Color(0xFF5CD1FF)),
                                  value: isVocaChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isVocaChecked = value!;
                                    });
                                  }),
                              const Text('단어기타'),
                            ],
                          ),
                        )
                      ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                SingleChildScrollView(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  scrollDirection: Axis.horizontal,
                  child: getDataTable(datas: datas),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Row(
                        children: [
                          filledButton('단어추가', const Color(0xFF3F99F7)),
                          const SizedBox(width: 2.0),
                          filledButton('단어 빼기', const Color(0xFFFFCC4A)),
                        ],
                      ),
                    ),
                    const Text('단어 5개 ')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    filledButton('번역 불러오기', const Color(0xFF353535)),
                    const SizedBox(width: 2.0),
                    filledButton('저장', const Color(0xFF3F99F7)),
                    const SizedBox(width: 2.0),
                    filledButton('Confirm', const Color(0xFFFF7D53)),
                  ],
                )
              ],
            )),
      ),
    );
  }

  Widget filledButton(String buttonName, Color color) {
    return FilledButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
          backgroundColor: MaterialStatePropertyAll(color)),
      child: Text(
        buttonName,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text('tapped!'),
            );
          },
        );
      },
    );
  }

  Widget getDataTable({List<ModifyVocaModel> datas = const []}) {
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
        rows: <DataRow>[for (ModifyVocaModel data in datas) dataCellRow(data)]);
  }

//column 데이터
  List<DataColumn> getColumns() {
    List<DataColumn> dataColumn = [];
    for (var i in columnName) {
      // if (i == 'No') {
      //   dataColumn.add(DataColumn(
      //       label: Center(child: Text(i)),
      //       numeric: true,
      //       onSort: dataColumnSort));
      // }
      //else {
      dataColumn.add(DataColumn(label: Text(i)));
      //tooltip: titleSplit
      //}
    }
    return dataColumn;
  }

  DataRow dataCellRow(ModifyVocaModel data) {
    return DataRow(cells: <DataCell>[
      DataCell(
        Text(data.index.toString()),
      ),
      DataCell(
        Text(data.vocabulary.toString()),
      ),
      DataCell(Image(
        image: AssetImage(data.imagepath),
      )),
      DataCell(
        Text(data.filename.toString()),
      ),
      DataCell(
        Text(data.ENG.toString()),
      ),
      DataCell(
        Text(data.CHN.toString()),
      ),
      DataCell(
        Text(data.VIE.toString()),
      ),
      DataCell(
        Text(data.RUS.toString()),
      ),
      DataCell(
        Text(data.extraExplanation.toString()),
      ),
    ]);
  }
}

class ModifyVocaModel {
  int index;
  String vocabulary;
  String imagepath;
  String filename;
  String ENG;
  String CHN;
  String VIE;
  String RUS;
  String extraExplanation;
  ModifyVocaModel(
      {required this.index,
      required this.vocabulary,
      required this.imagepath,
      required this.filename,
      required this.ENG,
      required this.CHN,
      required this.VIE,
      required this.RUS,
      required this.extraExplanation});
}
