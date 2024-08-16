import 'package:flutter/material.dart';
import 'package:haru_admin/api/meta_grammar_services.dart';
import 'package:haru_admin/model/meta_data_model.dart';

import '../../widgets/buttons.dart';

class MetaGrammarScreen extends StatefulWidget {
  const MetaGrammarScreen({super.key});

  @override
  State<MetaGrammarScreen> createState() => _MetaGrammarScreenState();
}

class _MetaGrammarScreenState extends State<MetaGrammarScreen> {
  static const MAX_META_DATA = 20;
  late Future<void> _metaListDataFuture;
  List<MetaGrammarData> _metaGrammarTitles = [];
  int? _selectedMetaDataIdx;
  // 5 sets of TextEditingController for each language
  final List<TextEditingController> descriptionControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  List<String> titles = [
    '한국어',
    '영어',
    '중국어',
    '베트남어',
    '러시아어',
  ];

  fetchMetaListData() async {
    // 메타문법 데이터를 가져오는 비동기 함수
    try {
      await MetaGrammarDataRepository()
          .getMetaGrammerDataList(page: 0, size: MAX_META_DATA)
          .then((value) {
        setState(() {
          _metaGrammarTitles =
              value.MetaGrammarDataList; // 메타데이터 리스트에서 타이틀만 가져오기
        });
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  getSelectedMetaData() async {
    // 선택된 메타데이터를 가져오는 비동기 함수
    try {
      await MetaGrammarDataRepository();
    } catch (e) {
      throw Exception(e);
    }
  }

  updateSelectedMetaData() async {
    // 선택된 메타데이터를 업데이트하는 비동기 함수
  }

  addNewMetaData() {
    // 새로운 메타데이터를 추가하는 gkatn
    setState(() {
      _selectedMetaDataIdx = _metaGrammarTitles.length + 1;
    });
  }

  saveNewMetaData() async {
    // 새로운 메타데이터를 저장하는 비동기 함수
  }

  @override
  void initState() {
    super.initState();
    _metaListDataFuture = fetchMetaListData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              '메타문법 데이터',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder(
              future: _metaListDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 200,
                    child: Table(
                      border: TableBorder.all(
                        color: const Color(0xFFB9B9B9),
                        width: 1,
                      ),
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(4), // 사이클
                        2: FlexColumnWidth(1), // 세트
                        3: FlexColumnWidth(4), // 회차
                      },
                      children: [
                        metaGrammarListTitle(),
                        for (var i = 0; i < 5; i++)
                          TableRow(children: [
                            TableCell(
                              child: SizedBox(
                                height: 30,
                                child: Center(
                                  child: Text((i * 2 + 1).toString()),
                                ),
                              ),
                            ),
                            TableCell(
                              child: SizedBox(
                                height: 30,
                                child: Center(
                                  child: _metaGrammarTitles.length == i * 2
                                      ? TextButton(
                                          onPressed: addNewMetaData,
                                          child: const Text(
                                            '새 메타데이터 추가',
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 14,
                                            ),
                                          ),
                                        )
                                      : _metaGrammarTitles.length > i * 2
                                          ? Text(
                                              _metaGrammarTitles[i * 2].title ??
                                                  '')
                                          : const Text(''),
                                ),
                              ),
                            ),
                            TableCell(
                              child: SizedBox(
                                height: 30,
                                child: Center(
                                  child: Text((i * 2 + 2).toString()),
                                ),
                              ),
                            ),
                            TableCell(
                              child: SizedBox(
                                height: 30,
                                child: Center(
                                  child: _metaGrammarTitles.length == i * 2 + 1
                                      ? TextButton(
                                          onPressed: addNewMetaData,
                                          child: const Text(
                                            '새 메타데이터 추가',
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 14,
                                            ),
                                          ),
                                        )
                                      : _metaGrammarTitles.length > i * 2 + 1
                                          ? GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _selectedMetaDataIdx =
                                                      i * 2 + 1;
                                                });
                                              },
                                              child: Text(
                                                  _metaGrammarTitles[i * 2 + 1]
                                                          .title ??
                                                      ''),
                                            )
                                          : const Text(''),
                                ),
                              ),
                            )
                          ])
                      ],
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            _selectedMetaDataIdx == null
                ? const SizedBox()
                : Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('<메타문법 용어 수정/추가>',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            const Text('번호'),
                            const SizedBox(width: 20),
                            Text('${_selectedMetaDataIdx ?? ''}'),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('제목'),
                            const SizedBox(width: 20),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: SizedBox(
                                width: 300,
                                height: 40,
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Container(
                        //   height: 150,
                        //   width: 150,
                        //   color: Colors.grey[300],
                        //   child: Icon(Icons.image, size: 50, color: Colors.grey[700]),
                        // ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Table(
                              border: TableBorder.all(
                                color: const Color(0xFFB9B9B9),
                                width: 1,
                              ),
                              columnWidths: const {
                                0: FlexColumnWidth(1),
                                1: FlexColumnWidth(8),
                              },
                              children: List.generate(
                                titles.length,
                                (index) => MetagrammarDescriptionTableRow(
                                  title: titles[index],
                                  index: index,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: MyCustomButton(
                              text: '저장하기',
                              onTap: () {},
                              color: const Color(0xFF3F99F7),
                            )),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    ));
  }

  TableRow MetagrammarDescriptionTableRow({
    required String title,
    required int index,
  }) {
    return TableRow(children: [
      Container(
        height: 30,
        decoration: const BoxDecoration(
          color: Color(0xFFF0F0F0),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 30, // Minimum height
            maxHeight: 200, // You can adjust the max height as needed
          ),
          child: const TextField(
            maxLines: null, // Allows the text field to grow vertically
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              // no border
              border: InputBorder.none,
            ),
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ),
    ]);
  }

  TableRow metaGrammarListTitle() {
    return const TableRow(
      decoration: BoxDecoration(
        color: Color(0xFFF0F0F0),
      ),
      children: [
        TableCell(
          child: SizedBox(
            height: 30,
            child: Center(
                child: Text(
              '순서',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )),
          ),
        ),
        TableCell(
          child: SizedBox(
            height: 30,
            child: Center(
                child: Text(
              '제목',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )),
          ),
        ),
        TableCell(
          child: SizedBox(
            height: 30,
            child: Center(
                child: Text(
              '순서',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )),
          ),
        ),
        TableCell(
          child: SizedBox(
            height: 30,
            child: Center(
                child: Text(
              '제목',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )),
          ),
        ),
      ],
    );
  }
}
