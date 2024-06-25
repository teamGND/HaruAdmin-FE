import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haru_admin/api/grammer_data_services.dart';
import 'package:haru_admin/model/grammer_data_model.dart';
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
  List<TextEditingController> descriptionControllers = [];

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

  addMetaGrammar() {}
  addNewSentence() {}
  deleteSelectedSentence() {}
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
                            addMetaGrammar();
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
                    SizedBox(
                      height: 500,
                      child: buildDialog(
                        koreanController: titleControllers.isNotEmpty
                            ? titleControllers[0]
                            : TextEditingController(),
                        englishController: englishControllers.isNotEmpty
                            ? englishControllers[0]
                            : TextEditingController(),
                        chineseController: chineseControllers.isNotEmpty
                            ? chineseControllers[0]
                            : TextEditingController(),
                        vietnamController: vietnamControllers.isNotEmpty
                            ? vietnamControllers[0]
                            : TextEditingController(),
                        russianController: russianControllers.isNotEmpty
                            ? russianControllers[0]
                            : TextEditingController(),
                      ),
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
                          buttonName: '추가',
                          color: Colors.blue,
                          onPressed: () {
                            addMetaGrammar();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Row(
                      children: [
                        SizedBox(width: 10),
                        Icon(Icons.download_done_outlined),
                        Text(
                          ' 예시 문장',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
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
              children: [
                filledButton(
                  buttonName: '문장 추가',
                  color: const Color(0xFF3F99F7),
                  onPressed: () {
                    addNewSentence();
                  },
                ),
                const SizedBox(width: 10),
                filledButton(
                  buttonName: '문장 빼기',
                  color: const Color(0xFFFFCC4A),
                  onPressed: () {
                    deleteSelectedSentence();
                  },
                ),
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

class buildDialog extends StatefulWidget {
  const buildDialog({
    super.key,
    required this.koreanController,
    required this.englishController,
    required this.chineseController,
    required this.vietnamController,
    required this.russianController,
  });

  final TextEditingController koreanController;
  final TextEditingController englishController;
  final TextEditingController chineseController;
  final TextEditingController vietnamController;
  final TextEditingController russianController;

  @override
  State<buildDialog> createState() => DialogueState();
}

class DialogueState extends State<buildDialog> {
  late List<TextEditingController> _textEditingControllers;
  final List<String> _languageTitles = ["한국어", "ENG", "CHN", "VIE", "RUS"];
  final List<String> _inputText = ["", "", "", "", ""];
  int _selectedLanguage = 0;

  @override
  void initState() {
    super.initState();
    _textEditingControllers = [
      widget.koreanController,
      widget.englishController,
      widget.chineseController,
      widget.vietnamController,
      widget.russianController,
    ];

    for (int i = 0; i < _textEditingControllers.length; i++) {
      _textEditingControllers[i].addListener(() {
        setState(() {
          _inputText[i] = _textEditingControllers[i].text;
        });
      });
    }
  }

  @override
  void dispose() {
    for (var element in _textEditingControllers) {
      element.dispose();
    }

    super.dispose();
  }

  List<InlineSpan> parseText(String text) {
    List<InlineSpan> spans = [];
    List<String> lines = text.split('\n');

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      if (i > 0) {
        spans.add(const WidgetSpan(child: SizedBox(height: 8)));
      }
      spans.add(WidgetSpan(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            i != 0
                ? Container(
                    width: 25,
                    height: 25,
                    margin: const EdgeInsets.only(right: 8.0),
                    padding: const EdgeInsets.all(5.0),
                    decoration: const BoxDecoration(
                      color: Colors.lightBlue,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$i',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
            Expanded(
              child: RichText(
                textAlign: i == 0
                    ? TextAlign.center
                    : TextAlign.start, // Center align the first line text
                text: TextSpan(
                  children: parseLine(line),
                ),
              ),
            ),
          ],
        ),
      ));
    }
    return spans;
  }

  List<TextSpan> parseLine(String line) {
    List<TextSpan> spans = [];
    RegExp exp = RegExp(r'<(.*?)>|\[(.*?)\]|\*(.*?)\*|([^<>\[\]\*]+)');
    Iterable<RegExpMatch> matches = exp.allMatches(line);

    for (var match in matches) {
      if (match.group(0)!.startsWith('<') && match.group(0)!.endsWith('>')) {
        spans.add(
          TextSpan(
            text: match.group(1),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else if (match.group(0)!.startsWith('[') &&
          match.group(0)!.endsWith(']')) {
        spans.add(
          TextSpan(
            text: match.group(2),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          ),
        );
      } else if (match.group(0)!.startsWith('*') &&
          match.group(0)!.endsWith('*')) {
        spans.add(
          TextSpan(
            text: match.group(3),
            style: const TextStyle(color: Colors.red, fontSize: 11),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: match.group(0),
            style: const TextStyle(fontSize: 10),
          ),
        );
      }
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: Container(
            height: 500,
            width: 300,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: SizedBox(
                    height: 50,
                    width: 300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _languageTitles.length,
                        (index) => RadioListTile(
                          title: Text(_languageTitles[index]),
                          value: index,
                          groupValue: _selectedLanguage,
                          onChanged: (value) {
                            setState(() {
                              _selectedLanguage = value as int;
                            });
                          },
                        ),
                      ).toList(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 470,
                  width: 300,
                  child: TextFormField(
                    maxLines: 15,
                    style: const TextStyle(
                      fontSize: 11,
                    ),
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 5),
                    ),
                    controller: _textEditingControllers[_selectedLanguage],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          flex: 1,
          child: Container(
            height: 500,
            width: 300,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xffffd4f3ff),
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              width: 300,
              height: 500,
              color: const Color(0xFFFFFFFF),
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    Image.asset('assets/images/blue_head.png',
                        width: 40, height: 40),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        children: parseText(_inputText[_selectedLanguage]),
                        style:
                            const TextStyle(color: Colors.black, fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DescriptionTableComponent extends StatelessWidget {
  const DescriptionTableComponent({
    super.key,
    required this.title,
    required this.textController,
  });

  final String title;
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 300,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 0.5,
        ),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: TextField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 5),
              ),
              controller: textController,
            ),
          ),
        ],
      ),
    );
  }
}
