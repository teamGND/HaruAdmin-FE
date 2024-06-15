import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:haru_admin/model/word_data_model.dart';
import 'package:haru_admin/api/word_data_services.dart';
import 'package:haru_admin/screens/intro/add_intro.dart';
import 'package:haru_admin/utils/add_chapter_model.dart';
import 'package:haru_admin/utils/enum_type.dart';

class Word extends ConsumerStatefulWidget {
  const Word({super.key});

  @override
  ConsumerState<Word> createState() => _WordState();
}

class _WordState extends ConsumerState<Word> {
  final int _pageSize = 8;
  int _currentPage = 0;
  bool _isLoading = true;
  late WordDataList wordData;
  LEVEL dropdownValue = LEVEL.LEVEL1;

  final tabletitle = [
    'No.',
    '사이클',
    '세트',
    '회차',
    '타이틀',
    '학습 내용',
    '단어수',
    '퀴즈',
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void addChapter(int? index) {
    if (index == null) {
      ref.watch(introProvider.notifier).update(
            chapter: wordData.content.last.chapter + 1,
            cycle: wordData.content.last.chapter,
            sets: wordData.content.last.chapter,
            category: CATEGORY.WORD,
            level: dropdownValue,
          );
    } else {
      ref.watch(introProvider.notifier).update(
            dataId: wordData.content[index].id,
            chapter: wordData.content[index].chapter,
            cycle: wordData.content[index].cycle,
            sets: wordData.content[index].sets,
            category: CATEGORY.WORD,
            level: dropdownValue,
            title: wordData.content[index].title,
            wordDatas: wordData.content[index].content?.split(','),
          );
    }

    context.go('/word/add');
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await WordDataRepository()
          .getWordDataList(page: _currentPage, size: _pageSize)
          .then((value) {
        wordData = value;
      });

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  void goToPage(int page) {
    if (page < 0 || page >= wordData.totalPages) {
      return;
    } else {
      setState(() {
        _currentPage = page;
      });
    }
    fetchData();
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
                    enableSearch: false,
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
                  : wordData.content.isEmpty
                      ? const Center(child: Text('데이터가 없습니다.'))
                      : Table(
                          border: TableBorder.all(
                            color: Color(0xFFB9B9B9),
                            width: 1,
                          ),
                          columnWidths: const {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(1),
                            4: FlexColumnWidth(3), // 타이틀
                            5: FlexColumnWidth(7), // 단어 리스트
                            6: FlexColumnWidth(1),
                            7: FlexColumnWidth(2),
                          },
                          children: [
                            TableRow(
                              decoration: const BoxDecoration(
                                color: Color(0xFFF0F0F0),
                              ),
                              children: List.generate(
                                tabletitle.length,
                                (index) => SizedBox(
                                    height: 40,
                                    child:
                                        Center(child: Text(tabletitle[index]))),
                              ),
                            ),
                            ...List.generate(wordData.content.length, (index) {
                              WordDataListComponent data =
                                  wordData.content[index];
                              return TableRow(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                children: [
                                  SizedBox(
                                    // No.
                                    height: 35,
                                    child: Center(
                                      child: Text(
                                        (index + 1).toString(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    // 사이클
                                    height: 35,
                                    child: Center(
                                      child: Text(data.cycle.toString()),
                                    ),
                                  ),
                                  SizedBox(
                                    // 세트
                                    height: 35,
                                    child: Center(
                                      child: Text(data.sets.toString()),
                                    ),
                                  ),
                                  SizedBox(
                                    // 회차
                                    height: 35,
                                    child: Center(
                                      child: Text(data.chapter.toString()),
                                    ),
                                  ),
                                  SizedBox(
                                    // 단어 리스트
                                    height: 35,
                                    child: Center(
                                      child: Text(data.title!),
                                    ),
                                  ),
                                  SizedBox(
                                    // 타이틀
                                    height: 35,
                                    child: TextButton(
                                      onPressed: () {
                                        addChapter(index);
                                      },
                                      child: Center(
                                        child: data.content != ''
                                            ? Text(data.content!)
                                            : const Text(
                                                '데이터 입력하기',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    // 단어 개수
                                    height: 35,
                                    child: Center(
                                      child: Text(data.wordCount.toString()),
                                    ),
                                  ),
                                  Center(
                                    // 퀴즈
                                    child: TextButton(
                                        onPressed: () {
                                          context.go('/test/add',
                                              extra: AddChatperClass(
                                                isExisting: true,
                                                id: data.id,
                                                category: CATEGORY.WORD,
                                                level: dropdownValue,
                                                cycle: data.cycle,
                                                sets: data.sets,
                                                chapter: data.chapter,
                                              ));
                                        },
                                        child: const Text(
                                          '퀴즈',
                                          style: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        )),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _currentPage != 0
                            ? GestureDetector(
                                onTap: () {
                                  goToPage(_currentPage - 1);
                                },
                                child: const SizedBox(
                                    width: 50, child: Text('< 이전')))
                            : const SizedBox(width: 50),
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
                          child: Text(
                            (_currentPage + 1).toString(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        _currentPage != wordData.totalPages
                            ? GestureDetector(
                                onTap: () {
                                  goToPage(_currentPage + 1);
                                },
                                child: SizedBox(
                                    width: 50, child: const Text('다음 >')),
                              )
                            : SizedBox(width: 50),
                        GestureDetector(
                          onTap: () {
                            goToPage(wordData.totalPages - 1);
                          },
                          child: const Text('맨뒤로 >>'),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      addChapter(null);
                    },
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                    child: const Text('회차추가'),
                  )
                ],
              ),
            ]),
          )),
    );
  }
}
