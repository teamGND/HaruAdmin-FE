import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haru_admin/api/intro_data_services.dart';
import 'package:haru_admin/model/intro_data_model.dart';
import 'package:haru_admin/screens/intro/add_intro.dart';
import 'package:haru_admin/utils/enum_type.dart';

class IntroTestScreen extends StatefulWidget {
  const IntroTestScreen({super.key});

  @override
  _IntroTestScreenState createState() => _IntroTestScreenState();
}

class _IntroTestScreenState extends State<IntroTestScreen> {
  late IntroDataList introData;
  late List<IntroListComponentData> datas;
  // 페이지 번호
  final int _pageSize = 8;
  final int _currentPage = 0;
  bool _isLoading = false;
  List<IntroListComponentData> _data = [];
  LEVEL dropdownValue = LEVEL.ALPHABET;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  final tabletitle = [
    '레벨',
    '유형',
    '회차',
    '사이클',
    '세트',
    '타이틀',
    '상태',
    '퀴즈/테스트',
  ];

  Future<void> fetchData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await IntroDataRepository()
          .getIntroDataList(page: _currentPage, size: _pageSize)
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
                '인트로 & 퀴즈/테스트 데이터',
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
                          showCheckboxColumn: true,
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
                    )
            ]),
          )),
    );
  }
}

class _DataSource extends DataTableSource {
  final List<IntroListComponentData> datas;
  final Map<int, bool> _selectedRows = {};
  final BuildContext context;

  _DataSource({
    required this.datas,
    required this.context,
  });

  static const Map<String, String> categoryMap = {
    'WORD': '단어',
    'GRAMMAR': '문법',
    'TEST': '테스트',
    'MIDTERM': '중간평가',
  };

  updateQuizData({
    required String dataCategory,
    required int dataId,
  }) {
    context.go('/test/add/$dataCategory/$dataId');
  }

  // 인트로 수정 or 추가
  updateIntroData({
    required int dataId,
    required Level level,
    required Category category,
    required int cycle,
    required int sets,
    required int chapter,
    String? title,
  }) {
    context.go('/intro/add/$category/$dataId');
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
        DataCell(Text(data.level.toString())),
        DataCell(
          Text(
            categoryMap[data.category.toString()]!,
            style: TextStyle(
              color: data.category == 'WORD'
                  ? Colors.blue
                  : data.category == 'GRAMMAR'
                      ? Colors.green
                      : Colors.red,
            ),
          ),
        ),
        DataCell(Text(data.chapter.toString())),
        DataCell(Text(data.cycle.toString())),
        DataCell(Text(data.sets.toString())),
        DataCell(
          SizedBox(
            width: 300,
            child: Text(data.titleKor.toString()),
          ),
          onTap: () {
            updateIntroData(
              category: Category.values.firstWhere(
                  (e) => e.toString() == 'CATEGORY.${data.category}'),
              dataId: data.id,
              level: Level.values
                  .firstWhere((e) => e.toString() == 'LEVEL.${data.level}'),
              cycle: data.cycle,
              sets: data.sets,
              chapter: data.chapter,
              title: data.titleKor.toString(),
            );
          },
        ),
        DataCell(Text(data.state.toString())),
        DataCell(
          const Center(child: Text('추가')),
          onTap: () {
            updateQuizData(
              dataCategory: data.category,
              dataId: data.id,
            );
          },
        ),
      ],
      selected: _selectedRows[index] ?? false,
      onSelectChanged: (isSelected) {
        _selectedRows[index] = isSelected!;
        notifyListeners();
      },
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => datas.length;

  @override
  int get selectedRowCount => 0;
}
