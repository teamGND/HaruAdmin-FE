import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haru_admin/api/grammer_data_services.dart';
import 'package:haru_admin/model/grammer_data_model.dart';
import 'package:haru_admin/screens/grammer/widget/dialogue_widget.dart';
import 'package:haru_admin/screens/grammer/widget/meta_grammar_modal.dart';
import 'package:haru_admin/screens/intro/add_intro.dart';
import 'package:haru_admin/widgets/button.dart';
import 'package:haru_admin/widgets/chapter_catalog_table.dart';

class AddGrammerScreen extends ConsumerStatefulWidget {
  const AddGrammerScreen({super.key});

  @override
  ConsumerState<AddGrammerScreen> createState() => _AddGrammerScreenState();
}

class _AddGrammerScreenState extends ConsumerState<AddGrammerScreen> {
  /* represent sentence 타입이 BLACK 이면 제시문으로 */

  final GrammerDataRepository grammerRepository = GrammerDataRepository();
  List<TextEditingController> titleControllers = [];
  List<TextEditingController> englishControllers = [];
  List<TextEditingController> chineseControllers = [];
  List<TextEditingController> vietnamControllers = [];
  List<TextEditingController> russianControllers = [];
  List<TextEditingController> exampleTitleControllers = [];
  List<TextEditingController> exampleEnglishControllers = [];
  List<TextEditingController> exampleChineseControllers = [];
  List<TextEditingController> exampleVietnamControllers = [];
  List<TextEditingController> exampleRussianControllers = [];
  List<TextEditingController> descriptionControllers =
      []; // 0: 한국어, 1: 영어, 2: 중국어, 3: 베트남어, 4: 러시아어

  IntroInfo info = IntroInfo();
  GrammarChapterDataList _data =
      GrammarChapterDataList(level: 'LEVEL1', cycle: 0, sets: 0, chapter: 0);
  List<ExampleSentence> _representSentences = []; // 가장 첫번째(0번째 인덱스) 문장이 제시문
  List<ExampleSentence> _exampleSentences = [];
  List<MetaGrammar> _metaGrammar = [];

  late Future<void> _grammarDataFuture;

  List<String> tableTitle = [
    '순서',
    '문장',
    '음성',
    '캐릭터',
    'ENG',
    'CHN',
    'VIE',
    'RUS',
  ];

  void _updateRow(
    bool isRep,
    int index,
    ExampleSentence sentence,
  ) {
    if (isRep) {
      setState(() {
        _representSentences[index] = sentence;
      });
    } else {
      setState(() {
        _exampleSentences[index] = sentence;
      });
    }
  }

  addMetaGrammar() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MetaGrammarModal();
      },
    );
  }

  addRepresentiveSentence() {
    if (_representSentences.length > 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('대표 문장은 2개까지만 추가 가능합니다.')),
          showCloseIcon: true,
          closeIconColor: Colors.white,
        ),
      );
      return;
    }
    setState(() {
      _representSentences.add(ExampleSentence(
        expression: '',
        expressionEng: '',
        expressionChn: '',
        expressionVie: '',
        expressionRus: '',
        characterType: 'BLUE',
      ));
      titleControllers.add(TextEditingController());
      englishControllers.add(TextEditingController());
      chineseControllers.add(TextEditingController());
      vietnamControllers.add(TextEditingController());
      russianControllers.add(TextEditingController());
      descriptionControllers.add(TextEditingController());
    });
  }

  addExampleSentence() {
    if (_representSentences.length > 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('대표 문장은 10개까지만 추가 가능합니다.')),
          showCloseIcon: true,
          closeIconColor: Colors.white,
        ),
      );
      return;
    }

    setState(() {
      _exampleSentences.add(ExampleSentence(
        expression: '',
        expressionEng: '',
        expressionChn: '',
        expressionVie: '',
        expressionRus: '',
        characterType: 'BLUE',
      ));
      exampleTitleControllers.add(TextEditingController());
      exampleEnglishControllers.add(TextEditingController());
      exampleChineseControllers.add(TextEditingController());
      exampleVietnamControllers.add(TextEditingController());
      exampleRussianControllers.add(TextEditingController());
    });
  }

  deleteSelectedRepresentiveSentence() {
    if (_representSentences.length == 1) {
      return;
    }

    setState(() {
      _representSentences.removeAt(_representSentences.length - 1);
      titleControllers.removeAt(titleControllers.length - 1);
      englishControllers.removeAt(englishControllers.length - 1);
      chineseControllers.removeAt(chineseControllers.length - 1);
      vietnamControllers.removeAt(vietnamControllers.length - 1);
      russianControllers.removeAt(russianControllers.length - 1);
    });
  }

  deleteSelectedExampleSentence() {
    setState(() {
      _exampleSentences.removeAt(_exampleSentences.length - 1);
      exampleTitleControllers.removeAt(exampleTitleControllers.length - 1);
      exampleEnglishControllers.removeAt(exampleEnglishControllers.length - 1);
      exampleChineseControllers.removeAt(exampleChineseControllers.length - 1);
      exampleVietnamControllers.removeAt(exampleVietnamControllers.length - 1);
      exampleRussianControllers.removeAt(exampleRussianControllers.length - 1);
    });
  }

  confirm() {}
  translate() {}
  save() {}
  Future<void> getImageUrl() async {
    if (_data.title == null || _data.title == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('이미지 업로드 전, 타이틀을 입력해주세요.')),
          showCloseIcon: true,
          closeIconColor: Colors.white,
        ),
      );
      return;
    }

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['png', 'jpg', 'svg', 'jpeg']);

      if (result != null) {
        PlatformFile file = result.files.first;

        await grammerRepository
            .uploadFile(
          fileBytes: file.bytes!,
          fileName: 'grammar_${_data.chapter.toString()}',
          fileType: file.extension!,
        )
            .then((value) {
          setState(() {
            _data.imageUrl = value;
          });
        });
      } else {
        // User canceled the picker
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> fetchGrammarData() async {
    try {
      if (info.dataId != null) {
        await grammerRepository.getGrammarData(id: info.dataId!).then((value) {
          setState(() {
            _data = value;
            _representSentences = value.representSentences;
            _exampleSentences = value.exampleSentences;
            _metaGrammar = value.metaGrammars;

            if (_representSentences.isEmpty) {
              // 제시문
              _representSentences.add(ExampleSentence(
                expression: '',
                expressionEng: '',
                expressionChn: '',
                expressionVie: '',
                expressionRus: '',
                characterType: 'BLACK',
              ));
            }
          });

          ref.read(DialogueDataProvider.notifier).update(DialogueData(
                korean: _representSentences[0].expression,
                english: _representSentences[0].expressionEng,
                chinese: _representSentences[0].expressionChn,
                vietnamese: _representSentences[0].expressionVie,
                russian: _representSentences[0].expressionRus,
              ));
        });

        titleControllers = List.generate(
          _representSentences.length,
          (index) => TextEditingController(
              text: _representSentences[index].expression),
        );
        englishControllers = List.generate(
          _representSentences.length,
          (index) => TextEditingController(
              text: _representSentences[index].expressionEng),
        );
        chineseControllers = List.generate(
          _representSentences.length,
          (index) => TextEditingController(
              text: _representSentences[index].expressionChn),
        );
        vietnamControllers = List.generate(
          _representSentences.length,
          (index) => TextEditingController(
              text: _representSentences[index].expressionVie),
        );
        russianControllers = List.generate(
          _representSentences.length,
          (index) => TextEditingController(
              text: _representSentences[index].expressionRus),
        );

        if (_exampleSentences.isNotEmpty) {
          exampleTitleControllers = List.generate(
            _exampleSentences.length,
            (index) => TextEditingController(
                text: _exampleSentences[index].expression),
          );
          exampleEnglishControllers = List.generate(
            _exampleSentences.length,
            (index) => TextEditingController(
                text: _exampleSentences[index].expressionEng),
          );
          exampleChineseControllers = List.generate(
            _exampleSentences.length,
            (index) => TextEditingController(
                text: _exampleSentences[index].expressionChn),
          );
          exampleVietnamControllers = List.generate(
            _exampleSentences.length,
            (index) => TextEditingController(
                text: _exampleSentences[index].expressionVie),
          );
          exampleRussianControllers = List.generate(
            _exampleSentences.length,
            (index) => TextEditingController(
                text: _exampleSentences[index].expressionRus),
          );
        }
        descriptionControllers = [
          TextEditingController(text: _data.description ?? ''),
          TextEditingController(text: _data.descriptionEng ?? ''),
          TextEditingController(text: _data.descriptionChn ?? ''),
          TextEditingController(text: _data.descriptionVie ?? ''),
          TextEditingController(text: _data.descriptionRus ?? ''),
        ];
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  @override
  void initState() {
    super.initState();
    info = ref.read(introProvider);
    _grammarDataFuture = fetchGrammarData();
  }

  @override
  void dispose() {
    for (var element in titleControllers) {
      element.dispose();
    }
    for (var element in englishControllers) {
      element.dispose();
    }
    for (var element in chineseControllers) {
      element.dispose();
    }
    for (var element in vietnamControllers) {
      element.dispose();
    }
    for (var element in russianControllers) {
      element.dispose();
    }
    for (var element in exampleTitleControllers) {
      element.dispose();
    }
    for (var element in exampleEnglishControllers) {
      element.dispose();
    }
    for (var element in exampleChineseControllers) {
      element.dispose();
    }
    for (var element in exampleVietnamControllers) {
      element.dispose();
    }
    for (var element in exampleRussianControllers) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '단어 데이터 조회/수정',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          ChapterCatalogTable(
            level: info.level.toString().split('.').last,
            cycle: info.cycle,
            sets: info.sets,
            chapter: info.chapter,
            title: info.title,
          ),
          const SizedBox(height: 10),
          FutureBuilder(
            future: _grammarDataFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 10),
                        const Icon(Icons.download_done_outlined),
                        const Text(
                          ' 대표 문장',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Text(
                          '하이라이트 되는 부분은 [ ] 사이에 넣어주세요.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(width: 20),
                        filledButton(
                          buttonName: '추가',
                          color: Colors.blue,
                          onPressed: () {
                            addRepresentiveSentence();
                          },
                        ),
                        const SizedBox(width: 20),
                        filledButton(
                          buttonName: '삭제',
                          color: Colors.yellow,
                          onPressed: () {
                            deleteSelectedRepresentiveSentence();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Table(
                          border: TableBorder.all(
                            color: const Color(0xFFB9B9B9),
                            width: 1,
                          ),
                          columnWidths: const {
                            0: FlexColumnWidth(1), // 순서
                            1: FlexColumnWidth(3), // 문장
                            2: FlexColumnWidth(1), // 음성 file
                            3: FlexColumnWidth(1), // 캐릭터 타입
                            4: FlexColumnWidth(3), // eng
                            5: FlexColumnWidth(3), // chn
                            6: FlexColumnWidth(3), // vie
                            7: FlexColumnWidth(3), // rus
                          },
                          children: _buildTableRows(true),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Row(
                      children: [
                        SizedBox(width: 10),
                        Icon(Icons.download_done_outlined),
                        Text(
                          ' 제시문',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          '제목은 맨 위 < > 사이에, 볼드체 목표 문법[ ] 사이에, 각주는 * * 사이에',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 500,
                      child: DialogueWidget(),
                    ),
                    const SizedBox(height: 15),
                    const Row(
                      children: [
                        SizedBox(width: 10),
                        Icon(Icons.download_done_outlined),
                        Text(
                          ' 문법 설명',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        (_data.imageUrl != null)
                            ? Image.network(
                                _data.imageUrl!,
                                width: 200,
                                height: 200,
                              )
                            : SizedBox(
                                width: 200,
                                height: 200,
                                child: IconButton(
                                    onPressed: () {
                                      getImageUrl();
                                    },
                                    icon: const Icon(
                                      size: 100,
                                      Icons.image,
                                      color: Color(0xFFB9B9B9),
                                    )),
                              ),
                        Table()
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        const Icon(Icons.download_done_outlined),
                        const Text(
                          ' 메타 문법',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 20),
                        filledButton(
                          buttonName: '새로 추가',
                          color: Colors.blue,
                          onPressed: () {
                            addMetaGrammar();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        const Icon(Icons.download_done_outlined),
                        const Text(
                          ' 예시 문장',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 20),
                        filledButton(
                          buttonName: '추가',
                          color: Colors.blue,
                          onPressed: () {
                            addExampleSentence();
                          },
                        ),
                        const SizedBox(width: 20),
                        filledButton(
                          buttonName: '삭제',
                          color: Colors.yellow,
                          onPressed: () {
                            deleteSelectedRepresentiveSentence();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Table(
                          border: TableBorder.all(
                            color: const Color(0xFFB9B9B9),
                            width: 1,
                          ),
                          columnWidths: const {
                            0: FlexColumnWidth(1), // 순서
                            1: FlexColumnWidth(3), // 문장
                            2: FlexColumnWidth(1), // 음성 file
                            3: FlexColumnWidth(1), // 캐릭터 타입
                            4: FlexColumnWidth(3), // eng
                            5: FlexColumnWidth(3), // chn
                            6: FlexColumnWidth(3), // vie
                            7: FlexColumnWidth(3), // rus
                          },
                          children: _buildTableRows(false),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          SizedBox(
            height: 60,
            width: MediaQuery.of(context).size.width * 0.75,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Expanded(child: SizedBox()),
                filledButton(
                  buttonName: 'Confirm',
                  color: const Color(0xFFFF7D53),
                  onPressed: () {
                    confirm();
                  },
                ),
                const SizedBox(width: 10),
                filledButton(
                  buttonName: '번역 불러오기',
                  color: const Color(0xFF484848),
                  onPressed: () {
                    translate();
                  },
                ),
                const SizedBox(width: 10),
                filledButton(
                  buttonName: '저장하기',
                  color: const Color(0xFF3F99F7),
                  onPressed: () {
                    save();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  List<TableRow> _buildTableRows(bool isRep) {
    List<TableRow> rows = [];

    rows.add(
      TableRow(
        children: List.generate(tableTitle.length, (index) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 0.5,
              ),
              color: Colors.grey[200],
            ),
            height: 40,
            child: Center(
              child: Text(
                tableTitle[index],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }),
      ),
    );

    for (int i = 0;
        i < (isRep ? _representSentences.length : _exampleSentences.length);
        i++) {
      if (isRep && i == 0) {
        continue;
      }

      rows.add(TableRow(
        children: [
          // 1. 순서
          SizedBox(
            height: 40,
            child: Center(
              child: Text(
                (i + 1).toString(),
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
          // 2. 문장
          SizedBox(
            height: 40,
            child: Center(
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 5),
                ),
                controller:
                    isRep ? titleControllers[i] : exampleTitleControllers[i],
              ),
            ),
          ),

          // 3. 음성 file
          SizedBox(
            height: 40,
            child: Center(
              child: IconButton(
                onPressed: () {
                  // 오디오 불러오기
                },
                icon: const Icon(Icons.volume_up_rounded),
              ),
            ),
          ),
          // 4. 캐릭터 타입
          SizedBox(
            height: 40,
            child: Center(
              child: DropdownButton<String>(
                padding: const EdgeInsets.all(2),
                value: isRep
                    ? _representSentences[i].characterType
                    : _exampleSentences[i].characterType,
                items: [
                  DropdownMenuItem(
                      value: 'BLUE',
                      child: Image.asset(
                        'assets/images/blue.png',
                        fit: BoxFit.fitHeight,
                      )),
                  DropdownMenuItem(
                    value: 'YELLOW',
                    child: Image.asset(
                      'assets/images/yellow.png',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'PINK',
                    child: Image.asset(
                      'assets/images/pink.png',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'RED',
                    child: Image.asset(
                      'assets/images/red.png',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'BLACK',
                    child: Image.asset(
                      'assets/images/black.png',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (isRep) {
                    setState(() {
                      _representSentences[i].characterType = value!;
                    });
                  } else {
                    setState(() {
                      _exampleSentences[i].characterType = value!;
                    });
                  }
                },
              ),
            ),
          ),
          // 5. ENG
          SizedBox(
            height: 40,
            child: Center(
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 5),
                ),
                controller: isRep
                    ? englishControllers[i]
                    : exampleEnglishControllers[i],
              ),
            ),
          ),
          // 6. CHN
          SizedBox(
            height: 40,
            child: Center(
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 5),
                ),
                controller: isRep
                    ? chineseControllers[i]
                    : exampleChineseControllers[i],
              ),
            ),
          ),
          // 7. VIE
          SizedBox(
            height: 40,
            child: Center(
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 5),
                ),
                controller: isRep
                    ? vietnamControllers[i]
                    : exampleVietnamControllers[i],
              ),
            ),
          ),
          // 8. RUS
          SizedBox(
            height: 40,
            child: Center(
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                controller: isRep
                    ? russianControllers[i]
                    : exampleRussianControllers[i],
              ),
            ),
          ),
        ],
      ));
    }
    return rows;
  }
}
