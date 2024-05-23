import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  // 페이지 번호
  final int _pageSize = 10;
  final int _currentPage = 0;
  bool _isLoading = false;
  List<IntroListComponentData> _data = [];

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
              const Text(
                '인트로 & 퀴즈/테스트 데이터',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
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

  static const Map<String, String> category_map = {
    'WORD': '단어',
    'EXPRESSION': '문법',
    'TEST': '테스트',
  };

  updateIntroData({
    required String dataCategory,
    required int dataId,
  }) {
    context.go('/test/add/$dataCategory/$dataId');
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
        DataCell(Text(
          data.level.toString(),
        )),
        DataCell(
          Text(
            category_map[data.category.toString()]!,
            style: TextStyle(
              color: data.category == 'WORD'
                  ? Colors.blue
                  : data.category == 'EXPRESSION'
                      ? Colors.green
                      : Colors.red,
            ),
          ),
        ),
        DataCell(
          Text(data.chapter.toString()),
        ),
        const DataCell(Text('1')),
        DataCell(
          SizedBox(
            width: 240,
            child: Text(data.titleKor.toString()),
          ),
          onTap: () {
            updateIntroData(
                dataCategory: data.category.toString(), dataId: data.id);
          },
        ),
        DataCell(Text(data.state.toString())),
        DataCell(
          const Center(child: Text('추가')),
          onTap: () {
            print("tapped");
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
