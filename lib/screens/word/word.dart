import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haru_admin/model/word_data_model.dart';
import 'package:haru_admin/api/word_data_services.dart';
import 'package:haru_admin/utils/enum_type.dart';
import 'package:haru_admin/widgets/button.dart';

class Word extends StatefulWidget {
  const Word({super.key});

  @override
  State<Word> createState() => _WordState();
}

class _WordState extends State<Word> {
  final int _pageSize = 8;
  final int _currentPage = 0;
  bool _isLoading = true;
  List<WordDataListComponent> _data = [];
  LEVEL dropdownValue = LEVEL.ALPHABET;

  final tabletitle = [
    'No.',
    '레벨',
    '사이클',
    '회차',
    '타이틀',
    '학습 내용',
    '단어 개수',
    '퀴즈',
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await WordDataRepository()
          .getWordDataList(page: _currentPage, size: _pageSize)
          .then((value) {
        _data = value.content;
      });

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
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
            child: Column(children: [
              Text(
                '단어 학습 데이터',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '레벨',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  DropdownMenu<String>(
                    inputDecorationTheme: InputDecorationTheme(
                      fillColor: Colors.white,
                      focusColor: Colors.blue,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                    ),
                    width: 300,
                    initialSelection: LEVEL.ALPHABET.toString(),
                    onSelected: (value) {
                      setState(() {
                        dropdownValue = value as LEVEL;
                      });
                    },
                    dropdownMenuEntries: LEVEL.values.map((value) {
                      return DropdownMenuEntry<String>(
                        value: value.toString(),
                        label: value.toString().split('.')[1],
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: SizedBox(
                        width: double.infinity,
                        child: PaginatedDataTable(
                          showCheckboxColumn: false,
                          showFirstLastButtons: true,
                          headingRowColor:
                              Theme.of(context).dataTableTheme.headingRowColor,
                          rowsPerPage: _pageSize,
                          source: _DataSource(
                            datas: _data,
                            context: context,
                          ),
                          columns: List.generate(
                            tabletitle.length,
                            growable: false,
                            (index) => DataColumn(
                              label: Center(
                                child: Text(
                                  tabletitle[index],
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          columnSpacing: 20,
                        ),
                      ),
                    ),
            ]),
          )),
    );
  }
}

class _DataSource extends DataTableSource {
  final List<WordDataListComponent> datas;
  final BuildContext context;

  _DataSource({
    required this.datas,
    required this.context,
  });

  updateQuizData({
    required int dataId,
  }) {
    context.go('/test/add/WORD/$dataId');
  }

  @override
  DataRow? getRow(int index) {
    if (index >= datas.length) {
      return null;
    }

    final data = datas[index];

    return DataRow(
      color: MaterialStateColor.resolveWith((states) => Colors.white),
      mouseCursor: MaterialStateMouseCursor.clickable,
      cells: <DataCell>[
        DataCell(Text(data.id.toString())),
        DataCell(Text(data.level.toString())),
        DataCell(Text(data.cycle.toString())),
        // DataCell(Text(data.sets.toString())),
        DataCell(Text(data.chapter.toString())),
        DataCell(
          SizedBox(
            width: 300,
            child: Text(data.title.toString()),
          ),
          onTap: () {
            context.go('/word/add/${data.id}');
          },
        ),
        DataCell(Text(data.content.toString())),
        DataCell(Text(data.wordCount.toString())),
        DataCell(
          const Center(child: Text('추가')),
          onTap: () {
            updateQuizData(dataId: data.id);
          },
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => datas.length;

  @override
  int get selectedRowCount => 0;
}
