import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haru_admin/api/grammer_data_services.dart';
import 'package:haru_admin/provider/intro_provider.dart';

import '../../../api/translate_service.dart';
import '../../../model/grammer_data_model.dart';
import '../../../model/translate_model.dart';
import '../../../utils/parse_dialogue_line.dart';
import '../grammar_provider.dart';

// 제시문
class DialogueWidget extends ConsumerStatefulWidget {
  const DialogueWidget({
    super.key,
  });

  @override
  ConsumerState<DialogueWidget> createState() => DialogueWidgetState();
}

class DialogueWidgetState extends ConsumerState<DialogueWidget> {
  final TranslateRepository translateRepository = TranslateRepository();
  final GrammerDataRepository grammerDataRepository = GrammerDataRepository();

  final List<String> _languageTitles = ["한국어", "ENG", "CHN", "VIE", "RUS"];
  final List<String> characterTypes = [
    'BLACK',
    'RED',
    'BLUE',
    'YELLOW',
    'PINK'
  ];

  int _selectedLanguage = 0;

  final List<TextEditingController> _dialogueController = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  final List<String> _inputText = ['', '', '', '', ''];
  final List<String> _hintText = [
    '<제목>\n[대괄호]를 입력해서 강조하세요.\n*별표*로 주석을 첨가하세요.\n{}로 화자를 표시하세요.',
    '<Title>\nUse [brackets] to emphasize.\nAdd *asterisks* for comments.\nUse {} to indicate the speaker.',
    '<标题>\n使用[方括号]强调。\n添加*星号*进行评论。\n使用{}表示发言者。',
    '<Tiêu đề>\nSử dụng [dấu ngoặc vuông] để nhấn mạnh.\nThêm *dấu sao* để bình luận.\nSử dụng {} để chỉ định người nói.',
    '<Заголовок>\nИспользуйте [квадратные скобки] для выделения.\nДобавьте *звездочки* для комментариев.\nИспользуйте {} для указания говорящего.',
  ];

  // 제시문 오디오 파일 업로드
  void getAudioUrl() async {
    int? chatper = ref.watch(introProvider.notifier).chapter;
    String audioName = 'dialogue_chapter$chatper';

    if (chatper == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('챕터를 선택해주세요.')),
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

        await grammerDataRepository
            .uploadFile(
          fileBytes: file.bytes!,
          fileName: audioName,
          fileType: file.extension!,
        )
            .then((value) {
          ref.read(grammarDataProvider.notifier).updateDialogueAudioUrl(value!);
        });
      } else {
        // User canceled the picker
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  // 저장
  save() async {
    ref.read(grammarDataProvider.notifier).updateDialogue(
          dialogue: _dialogueController[0].text,
          dialogueEng: _dialogueController[1].text,
          dialogueChn: _dialogueController[2].text,
          dialogueVie: _dialogueController[3].text,
          dialogueRus: _dialogueController[4].text,
        );
    try {
      int? grammarId = ref.watch(introProvider.notifier).dataId;

      if (grammarId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(child: Text('문법을 선택해주세요.')),
            showCloseIcon: true,
            closeIconColor: Colors.white,
          ),
        );
        return;
      }
      await grammerDataRepository.updateGrammarData(
        id: grammarId,
        data: AddGrammarData(
          description: _dialogueController[0].text,
          descriptionEng: _dialogueController[1].text,
          descriptionChn: _dialogueController[2].text,
          descriptionVie: _dialogueController[3].text,
          descriptionRus: _dialogueController[4].text,
        ),
      );
    } catch (e) {
      print("error : $e");
    }
  }

  // 번역
  translate() async {
    try {
      bool isKoreanFilled = _dialogueController[0].text.isNotEmpty;

      if (isKoreanFilled == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(child: Text('한국어 제시문을 입력해주세요.')),
            showCloseIcon: true,
            closeIconColor: Colors.white,
          ),
        );
        return;
      }

      TranslatedResponse? response = await translateRepository.translate(
        korean: _dialogueController[0].text,
        english: _dialogueController[1].text,
      );
      print(response);
      _dialogueController[1].text = response?.english ?? '';
      _dialogueController[2].text = response?.chinese ?? '';
      _dialogueController[3].text = response?.vietnam ?? '';
      _dialogueController[4].text = response?.russian ?? '';
    } catch (e) {
      print("error : $e");
    }
  }

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < _dialogueController.length; i++) {
      _dialogueController[i].addListener(() {
        setState(() {
          _inputText[i] = _dialogueController[i].text;
        });
      });
    }

    _dialogueController[0].text = ref.read(grammarDataProvider).dialogue ?? '';
    _dialogueController[1].text =
        ref.read(grammarDataProvider).dialogueEng ?? '';
    _dialogueController[2].text =
        ref.read(grammarDataProvider).dialogueChn ?? '';
    _dialogueController[3].text =
        ref.read(grammarDataProvider).dialogueVie ?? '';
    _dialogueController[4].text =
        ref.read(grammarDataProvider).dialogueRus ?? '';
  }

  @override
  void dispose() {
    for (var controller in _dialogueController) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 500,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < _languageTitles.length; i++)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _selectedLanguage = i;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: i == _selectedLanguage
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                              child: Text(
                                _languageTitles[i],
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 16.0,
                    ),
                    child: Column(children: [
                      SizedBox(
                        height: 300,
                        child: TextFormField(
                          maxLines: 15,
                          style: const TextStyle(
                            fontSize: 11,
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 5),
                            hintText: _hintText[_selectedLanguage],
                          ),
                          controller: _dialogueController[_selectedLanguage],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('화자: '),
                              ...List.generate(
                                characterTypes.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    _dialogueController[_selectedLanguage]
                                        .text += '{${characterTypes[index]}}';
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Image.asset(
                                        'assets/images/character_${characterTypes[index]}.png',
                                        width: 30,
                                        height: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: save,
                      child: Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          border: Border.all(
                            color: Colors.blue,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            '완료',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: translate,
                      child: Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xFF484848),
                          border: Border.all(
                            color: const Color(0xFF484848),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            '번역',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: getAudioUrl,
                      child: Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xFFCDCDCD),
                          border: Border.all(
                            color: const Color(0xFFCDCDCD),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            '음성 파일',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
              color: const Color(0xffd4f3ff),
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
                    const SizedBox(height: 20),
                    Image.asset('assets/images/blue_head.png',
                        width: 40, height: 40),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 300,
                      height: 400,
                      child: RichText(
                        text: TextSpan(
                          children:
                              parseDialogueLine(_inputText[_selectedLanguage]),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 10),
                        ),
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
