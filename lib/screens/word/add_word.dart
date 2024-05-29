import 'package:flutter/material.dart';
import 'package:haru_admin/api/word_data_services.dart';
import 'package:haru_admin/model/word_data_model.dart';
import 'package:haru_admin/widgets/button.dart';
import 'package:haru_admin/widgets/chapter_catalog_table.dart';

class AddWord extends StatefulWidget {
  const AddWord({super.key});

  @override
  State<AddWord> createState() => _AddWordState();
}

class _AddWordState extends State<AddWord> {
  final WordDataRepository wordRepository = WordDataRepository();

  // 회차 데이터 가져오기
  bool _isLoading = false;
  int _chapter = 0;
  String _level = 'LEVEL1';
  int _cycle = 0;
  String _title = 'null';
  List<Map<String, double>> tabletitle = [
    {'': 50},
    {'순서': 70},
    {'단어': 150},
    {'이미지': 200},
    {'음성': 100},
    {'ENG': 100},
    {'CHN': 100},
    {'VIE': 100},
    {'RUS': 100},
    {'추가 설명': 100},
  ];

  List<WordChapterData> _datas = [];

  void addNewWord() {}
  void deleteSelectedWord() {}
  void translate() {}
  void save() {}
  void confirm() {}

  Future<void> fetchWordData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      List<String> urlParam = Uri.base.toString().split('/');
      int len = urlParam.length;
      int chapterId = int.parse(urlParam[len - 1]);

      await wordRepository.getWordData(id: chapterId).then((value) {
        _datas = value.wordDataList;
        _level = value.level;
        _cycle = value.cycle;
        _chapter = value.chapter;
        _title = value.title;
      });

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWordData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '단어 데이터 조회/수정',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ChapterCatalogTable(
                      level: _level,
                      cycle: _cycle,
                      chapter: _chapter,
                      title: _title,
                    ),
              const SizedBox(height: 20),
              SizedBox(
                  height: 500,
                  child: ReorderableListView(
                    scrollDirection: Axis.horizontal,
                    header: Row(
                      children: List.generate(
                        tabletitle.length,
                        (index) => Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 0.5,
                            ),
                            color: Colors.grey[200],
                          ),
                          width: tabletitle[index].values.first,
                          height: 40,
                          child: Center(
                            child: Text(
                              tabletitle[index].keys.first,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    children: const [],
                    onReorder: (int oldIndex, int newIndex) {
                      // setState(() {
                      //   if (oldIndex < newIndex) {
                      //     newIndex -= 1;
                      //   }
                      //   final testDataEntityProvider =
                      //       context.read<TestDataEntityProvider>();
                      //   final testDataList =
                      //       testDataEntityProvider.testDataList;

                      //   // Remove the item from the list at the old index
                      //   final item = testDataList.removeAt(oldIndex);
                      //   // Insert the item into the list at the new index
                      //   testDataList.insert(newIndex, item);
                      // });
                    },
                  )),
              const SizedBox(height: 20),
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.75,
                child: Row(
                  children: [
                    filledButton(
                      buttonName: '단어 추가',
                      color: const Color(0xFF3F99F7),
                      onPressed: addNewWord,
                    ),
                    const SizedBox(width: 10),
                    filledButton(
                      buttonName: '단어 빼기',
                      color: const Color(0xFFFFCC4A),
                      onPressed: addNewWord,
                    ),
                    const Expanded(child: SizedBox()),
                    filledButton(
                      buttonName: 'Confirm',
                      color: const Color(0xFFFF7D53),
                      onPressed: addNewWord,
                    ),
                    const SizedBox(width: 10),
                    filledButton(
                      buttonName: '번역 불러오기',
                      color: const Color(0xFF484848),
                      onPressed: addNewWord,
                    ),
                    const SizedBox(width: 10),
                    filledButton(
                      buttonName: '저장하기',
                      color: const Color(0xFF3F99F7),
                      onPressed: addNewWord,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TableComponent extends StatelessWidget {
  const TableComponent({
    super.key,
    required this.tabletitle,
    required this.width,
  });

  final String tabletitle;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 0.5,
        ),
        color: Colors.white,
      ),
      width: width,
      height: 40,
      child: Center(
        child: TextField(
          controller: TextEditingController(
            text: tabletitle == 'null' ? '' : tabletitle,
          ),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
