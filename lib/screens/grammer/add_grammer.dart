import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haru_admin/api/grammer_data_services.dart';
import 'package:haru_admin/model/grammer_data_model.dart';
import 'package:haru_admin/provider/grammar_provider.dart';
import 'package:haru_admin/screens/grammer/widget/dialogue_widget.dart';
import 'package:haru_admin/screens/grammer/widget/meta_grammar_modal.dart';
import 'package:haru_admin/widgets/chapter_catalog_table.dart';
import 'package:just_audio/just_audio.dart';

import '../../api/translate_service.dart';
import '../../model/translate_model.dart';
import '../../provider/intro_provider.dart';
import '../../utils/enum_type.dart';
import '../../widgets/buttons.dart';
import 'widget/grammar_description_widget.dart';

class AddGrammerScreen extends ConsumerStatefulWidget {
  const AddGrammerScreen(this.grammarId, {super.key});

  final String? grammarId;

  @override
  ConsumerState<AddGrammerScreen> createState() => _AddGrammerScreenState();
}

class _AddGrammerScreenState extends ConsumerState<AddGrammerScreen> {
  final GrammerDataRepository grammerRepository = GrammerDataRepository();
  final TranslateRepository translateRepository = TranslateRepository();

  // 타이틀 입력
  TextEditingController titleController = TextEditingController();

  // 대표 문장
  List<TextEditingController> koreanControllers = [];
  List<TextEditingController> englishControllers = [];
  List<TextEditingController> chineseControllers = [];
  List<TextEditingController> vietnamControllers = [];
  List<TextEditingController> russianControllers = [];

  List<TextEditingController> exampleTitleControllers = [];
  List<TextEditingController> exampleEnglishControllers = [];
  List<TextEditingController> exampleChineseControllers = [];
  List<TextEditingController> exampleVietnamControllers = [];
  List<TextEditingController> exampleRussianControllers = [];

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
    'ENG',
    'CHN',
    'VIE',
    'RUS',
  ];

  void getAudioUrl({
    required bool isRep,
    required int index,
  }) async {
    String? title = isRep
        ? koreanControllers[index].text
        : exampleTitleControllers[index].text;

    if (title == '' || title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('음성 업로드 전, 단어를 입력해주세요.')),
          showCloseIcon: true,
          closeIconColor: Colors.white,
        ),
      );
      return;
    }

    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['mp3']);

      if (result != null) {
        PlatformFile file = result.files.first;

        await grammerRepository
            .uploadFile(
          fileBytes: file.bytes!,
          fileName: title,
          fileType: file.extension!,
        )
            .then((value) {
          setState(() {
            if (isRep) {
              _representSentences[index].voiceUrl = value;
            } else {
              _exampleSentences[index].voiceUrl = value;
            }
          });
        });
      } else {
        // User canceled the picker
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  playAudio({required String? audioUrl}) async {
    if (audioUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('오디오 파일이 없습니다.')),
          showCloseIcon: true,
          closeIconColor: Colors.white,
        ),
      );
      return;
    }
    try {
      final player = AudioPlayer();
      await player.setUrl(audioUrl);
      await player.setVolume(0.5);
      await player.pause();
      await player.stop();
      player.play();
    } catch (e) {
      print(e);
    }
  }

  addMetaGrammar() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MetaGrammarModal(
          grammarId: int.parse(widget.grammarId!),
          updateFunction: (List<MetaGrammar> metaGrammars) {
            setState(() {
              _metaGrammar = metaGrammars;
            });
          },
        );
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
        order: _representSentences.length,
        expression: '',
        expressionEng: '',
        expressionChn: '',
        expressionVie: '',
        expressionRus: '',
        characterType: 'BLUE',
      ));
      koreanControllers.add(TextEditingController());
      englishControllers.add(TextEditingController());
      chineseControllers.add(TextEditingController());
      vietnamControllers.add(TextEditingController());
      russianControllers.add(TextEditingController());
    });
  }

  addExampleSentence() {
    if (_representSentences.length > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('예시 문장은 10개까지만 추가 가능합니다.')),
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
      // index 0은 제시문으로 삭제 안되게 막기
      return;
    }

    setState(() {
      _representSentences.removeAt(_representSentences.length - 1);
      koreanControllers.removeAt(koreanControllers.length - 1);
      englishControllers.removeAt(englishControllers.length - 1);
      chineseControllers.removeAt(chineseControllers.length - 1);
      vietnamControllers.removeAt(vietnamControllers.length - 1);
      russianControllers.removeAt(russianControllers.length - 1);
    });
  }

  deleteSelectedExampleSentence() {
    if (_exampleSentences.isEmpty) {
      return;
    }
    setState(() {
      _exampleSentences.removeAt(_exampleSentences.length - 1);
      exampleTitleControllers.removeAt(exampleTitleControllers.length - 1);
      exampleEnglishControllers.removeAt(exampleEnglishControllers.length - 1);
      exampleChineseControllers.removeAt(exampleChineseControllers.length - 1);
      exampleVietnamControllers.removeAt(exampleVietnamControllers.length - 1);
      exampleRussianControllers.removeAt(exampleRussianControllers.length - 1);
    });
  }

  translate({required isRep, isDialogue = false}) async {
    // 번역할 데이터 datas에 넣기
    List<Sentence> datas = isRep ? saveRepSentences() : saveExSentences();
    if (isDialogue) {
      datas = [
        Sentence(
          id: _representSentences[0].id,
          order: 0,
          sentenceType: "REPRESENT",
          expression: koreanControllers[0].text,
          expressionEng: englishControllers[0].text,
          expressionChn: chineseControllers[0].text,
          expressionVie: vietnamControllers[0].text,
          expressionRus: russianControllers[0].text,
          voiceUrl: _representSentences[0].voiceUrl,
          characterType: 'BLACK',
        )
      ];
    }

    // 한국어와 영어가 모두 입력되었는지 확인
    bool isKoreanFilled = datas.every((element) {
      print(element.expression);
      if (element.expression == '' || element.expressionEng == '') {
        return false;
      }
      return true;
    });

    if (isKoreanFilled == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('한국어와 영어를 모두 입력하고 저장한 후 번역해주세요')),
          showCloseIcon: true,
          closeIconColor: Colors.white,
        ),
      );
      return;
    }

    try {
      for (int i = 0; i < datas.length; i++) {
        Sentence data = datas[i];
        TranslatedResponse? response = await translateRepository.translate(
          korean: data.expression!,
          english: data.expressionEng,
        );
        if (response != null) {
          if (isRep) {
            setState(() {
              if (data.expressionEng != null) {
                englishControllers[i + 1].text = response.english ?? '';
              }
              chineseControllers[i + 1].text = response.chinese ?? '';
              vietnamControllers[i + 1].text = response.vietnam ?? '';
              russianControllers[i + 1].text = response.russian ?? '';
            });
          } else {
            setState(() {
              if (data.expressionEng != null) {
                exampleEnglishControllers[i].text = response.english ?? '';
              }
              exampleChineseControllers[i].text = response.chinese ?? '';
              exampleVietnamControllers[i].text = response.vietnam ?? '';
              exampleRussianControllers[i].text = response.russian ?? '';
            });
          }
        } else {}
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  List<Sentence> saveRepSentences() {
    // 0번째 인덱스는 제시문
    List<Sentence> sentences = [];
    for (int i = 1; i < _representSentences.length; i++) {
      sentences.add(Sentence(
        id: _representSentences[i].id,
        order: i,
        sentenceType: "REPRESENT",
        expression: koreanControllers[i].text,
        expressionEng: englishControllers[i].text,
        expressionChn: chineseControllers[i].text,
        expressionVie: vietnamControllers[i].text,
        expressionRus: russianControllers[i].text,
        voiceUrl: _representSentences[i].voiceUrl,
        characterType: 'BLACK',
      ));
    }
    return sentences;
  }

  List<Sentence> saveExSentences() {
    List<Sentence> sentences = [];

    for (int i = 0; i < _exampleSentences.length; i++) {
      sentences.add(Sentence(
        id: _exampleSentences[i].id,
        order: i + 1,
        sentenceType: "EXAMPLE",
        expression: exampleTitleControllers[i].text,
        expressionEng: exampleEnglishControllers[i].text,
        expressionChn: exampleChineseControllers[i].text,
        expressionVie: exampleVietnamControllers[i].text,
        expressionRus: exampleRussianControllers[i].text,
        voiceUrl: _exampleSentences[i].voiceUrl,
        characterType: 'YELLOW',
      ));
    }
    return sentences;
  }

  confirm() async {
    // CONFRIM 확정하겠냐는 dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('데이터를 유저 앱에 반영합니다.'),
          content: const Text(
              '체크리스트\n1. 단어의 맞춤법을 확인했나요?\n2. 영어, 중국어, 베트남어, 러시아어 - 번역을 검토했나요?\n3. 이미지가 정확한지 확인했나요?\n4. 음성이 정확한지 확인했나요?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);

                await finalSave(true);
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  finalSave(bool isConfirm) async {
    try {
      List<Sentence> sentences = [
        Sentence(
          id: _representSentences[0].id,
          order: 0,
          sentenceType: "REPRESENT",
          expression: koreanControllers[0].text,
          expressionEng: englishControllers[0].text,
          expressionChn: chineseControllers[0].text,
          expressionVie: vietnamControllers[0].text,
          expressionRus: russianControllers[0].text,
          voiceUrl: _representSentences[0].voiceUrl,
          characterType: 'BLACK',
        )
      ];
      sentences.addAll(saveRepSentences());
      sentences.addAll(saveExSentences());

      final data = AddGrammarData(
          level: info.level.toString().split('.')[1],
          cycle: info.cycle,
          sets: info.sets,
          chapter: info.chapter,
          title: titleController.text,
          description: ref.read(grammarDataProvider).description,
          descriptionEng: ref.read(grammarDataProvider).descriptionEng,
          descriptionChn: ref.read(grammarDataProvider).descriptionChn,
          descriptionVie: ref.read(grammarDataProvider).descriptionVie,
          descriptionRus: ref.read(grammarDataProvider).descriptionRus,
          sentenceList: sentences,
          metaGrammars: _metaGrammar.map((e) => e.id).toList(),
          status: isConfirm ? 'APPROVE' : 'WAIT');

      await grammerRepository
          .updateGrammarData(
        id: int.parse(widget.grammarId!),
        data: data,
      )
          .then((value) async {
        await fetchGrammarData().then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Center(child: Text(isConfirm ? '유저 앱 반영 완료 🤠' : '저장 완료')),
              showCloseIcon: true,
              closeIconColor: Colors.white,
            ),
          );
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchGrammarData() async {
    try {
      if (widget.grammarId != null) {
        await grammerRepository
            .getGrammarData(id: int.parse(widget.grammarId!))
            .then((value) {
          setState(() {
            info = IntroInfo(
              category: CATEGORY.GRAMMAR,
              level: levelFromString(value.level),
              cycle: value.cycle,
              sets: value.sets,
              chapter: value.chapter,
              title: value.title,
            );
            _data = value;
            _representSentences = value.representSentences;
            _exampleSentences = value.exampleSentences;
            _metaGrammar = value.metaGrammars;

            if (value.representSentences.length == 0) {
              // 제시문이 없을 경우. 대표 문장 0번째 인덱스에 추가
              _representSentences.add(ExampleSentence(
                order: 0,
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

        // 제시문
        await ref.read(grammarDataProvider.notifier).updateDialogue(
            dialogueId: _representSentences[0].id,
            dialogue: _representSentences[0].expression,
            dialogueEng: _representSentences[0].expressionEng,
            dialogueChn: _representSentences[0].expressionChn,
            dialogueVie: _representSentences[0].expressionVie,
            dialogueRus: _representSentences[0].expressionRus);
        /* 컨트롤러에 추가 */
        // 타이틀
        titleController = TextEditingController(text: info.title);

        // 대표 문장
        koreanControllers = List.generate(
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

        // 예시 문장
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
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _grammarDataFuture = fetchGrammarData();
  }

  @override
  void dispose() {
    for (var element in koreanControllers) {
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
            '문법 데이터 조회/수정',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          ChapterCatalogTable(
            level: info.level.toString().split('.').last,
            cycle: info.cycle,
            sets: info.sets,
            chapter: info.chapter,
            titleController: titleController,
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
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            color: Colors.grey[200],
                            child: const Center(
                              child: Text(
                                '[1] 제시문 화면',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
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
                          '\t#1 제목은 맨 위 < > 사이에\n\t#2 볼드체 목표 문법 [ ] 사이에',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blueGrey,
                          ),
                        ),
                        SizedBox(width: 30),
                        Text(
                          '#3 각주는 * * 사이에\n#4 화자는 { } 사이에',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blueGrey,
                          ),
                        ),
                        SizedBox(width: 30),
                        Text(
                          '** | 를 절대 쓰지 마세요 **',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 500,
                      child: DialogueWidget(
                        chapter: info.chapter.toString(),
                        dialogueControllers: [
                          koreanControllers.isNotEmpty
                              ? koreanControllers[0]
                              : TextEditingController(),
                          englishControllers.isNotEmpty
                              ? englishControllers[0]
                              : TextEditingController(),
                          chineseControllers.isNotEmpty
                              ? chineseControllers[0]
                              : TextEditingController(),
                          vietnamControllers.isNotEmpty
                              ? vietnamControllers[0]
                              : TextEditingController(),
                          russianControllers.isNotEmpty
                              ? russianControllers[0]
                              : TextEditingController(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            color: Colors.grey[200],
                            child: const Center(
                              child: Text(
                                '[2] 문법 설명 화면',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
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
                        MyCustomButton(
                          text: '추가',
                          onTap: () => addRepresentiveSentence(),
                          color: Colors.orange,
                          colorBorder: true,
                        ),
                        const SizedBox(width: 20),
                        MyCustomButton(
                          text: '삭제',
                          onTap: () => deleteSelectedRepresentiveSentence(),
                          color: Colors.orange,
                        ),
                        const Spacer(),
                        MyCustomButton(
                          text: '번역',
                          onTap: () {
                            translate(isRep: true);
                          },
                          color: const Color(0XFF484848),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: Table(
                          border: TableBorder.all(
                            color: const Color(0xFFB9B9B9),
                            width: 1,
                          ),
                          columnWidths: const {
                            0: FlexColumnWidth(1), // 순서
                            1: FlexColumnWidth(6), // 문장
                            2: FlexColumnWidth(2), // 음성 file
                            3: FlexColumnWidth(6), // eng
                            4: FlexColumnWidth(6), // chn
                            5: FlexColumnWidth(6), // vie
                            6: FlexColumnWidth(6), // rus
                          },
                          children: _buildTableRows(true),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        SizedBox(width: 20),
                        Text(
                          '\t #1 제목은 맨 위 < > 사이에\n\t #2 볼드체 목표 문법 [ ] 사이에\n\t #3 예시 문장은 { } 사이에',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blueGrey,
                          ),
                        ),
                        SizedBox(width: 30),
                        Text(
                          '#4 번호 매기기는 @@사이에 숫자넣기\n#5 메타문법은 ^^ ^^ 사이에',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blueGrey,
                          ),
                        ),
                        SizedBox(width: 30),
                        Text(
                          '** | 를 절대 쓰지 마세요 **',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 500,
                      child: DescriptionWidget(),
                    ),
                    const SizedBox(height: 15),
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
                        MyCustomButton(
                          text: '가져오기',
                          onTap: () => addMetaGrammar(),
                          color: Colors.orange,
                          colorBorder: true,
                        ),
                      ],
                    ),
                    _metaGrammar.isNotEmpty && _metaGrammar != []
                        ?
                        // 메타 문법이 있을 경우
                        SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              itemCount: _metaGrammar.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 10),
                                      Flexible(
                                        flex: 1,
                                        child: Text(
                                          '${_metaGrammar[index].id.toString()}. ',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(
                                        flex: 4,
                                        child: Text(
                                          _metaGrammar[index].title,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        : const Text(
                            '해당 회차에서 참조하는 메타 문법이 없습니다.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            color: Colors.grey[200],
                            child: const Center(
                              child: Text(
                                '[3] 예시 문장 학습 화면',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
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
                        MyCustomButton(
                          text: '추가',
                          onTap: () => addExampleSentence(),
                          color: Colors.orange,
                          colorBorder: true,
                        ),
                        const SizedBox(width: 20),
                        MyCustomButton(
                          text: '삭제',
                          onTap: () => deleteSelectedRepresentiveSentence(),
                          color: Colors.orange,
                        ),
                        const Spacer(),
                        MyCustomButton(
                          text: '번역',
                          onTap: () {
                            translate(isRep: false);
                          },
                          color: const Color(0XFF484848),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        height: 450,
                        width: MediaQuery.of(context).size.width,
                        child: _buildTableRows(false).isEmpty
                            ? const Center(
                                child: Text('예시 문장이 없습니다.',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey)),
                              )
                            : Table(
                                border: TableBorder.all(
                                  color: const Color(0xFFB9B9B9),
                                  width: 1,
                                ),
                                columnWidths: const {
                                  0: FlexColumnWidth(1), // 순서
                                  1: FlexColumnWidth(6), // 문장
                                  2: FlexColumnWidth(2), // 음성 file
                                  3: FlexColumnWidth(6), // eng
                                  4: FlexColumnWidth(6), // chn
                                  5: FlexColumnWidth(6), // vie
                                  6: FlexColumnWidth(6), // rus
                                },
                                children: _buildTableRows(false),
                              ),
                      ),
                    )
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 50),
          SizedBox(
            height: 60,
            width: MediaQuery.of(context).size.width * 0.75,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Expanded(child: SizedBox()),
                MyCustomButton(
                  text: 'CONFRIM',
                  onTap: () => confirm(),
                  color: const Color(0xFFFF7D53),
                ),
                const SizedBox(width: 10),
                MyCustomButton(
                  text: '저장하기',
                  onTap: () => finalSave(false),
                  color: const Color(0xFF3F99F7),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20)
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
                isRep ? (i).toString() : (i + 1).toString(),
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
                    isRep ? koreanControllers[i] : exampleTitleControllers[i],
              ),
            ),
          ),

          // 3. 음성 file
          SizedBox(
            height: 40,
            child: Center(
                child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    // 오디오 재생
                    playAudio(
                        audioUrl: isRep
                            ? _representSentences[i].voiceUrl
                            : _exampleSentences[i].voiceUrl);
                  },
                  icon: const Icon(
                    Icons.volume_up_rounded,
                    size: 16,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // 오디오 불러오기
                    getAudioUrl(isRep: isRep, index: i);
                  },
                  icon: const Icon(
                    Icons.file_upload,
                    size: 16,
                  ),
                ),
              ],
            )),
          ),

          // 4. ENG
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
          // 5. CHN
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
          // 6. VIE
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
          // . RUS
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
