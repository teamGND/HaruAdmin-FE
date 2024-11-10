import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haru_admin/api/grammer_data_services.dart';
import 'package:haru_admin/provider/intro_provider.dart';
import 'package:just_audio/just_audio.dart';

import '../../../api/translate_service.dart';
import '../../../model/translate_model.dart';
import '../../../utils/enum_type.dart';
import '../../../utils/grammar_parse_line_function.dart';
import '../../../provider/grammar_provider.dart';

// 제시문
class DialogueWidget extends ConsumerStatefulWidget {
  const DialogueWidget({
    super.key,
    required this.dialogueControllers,
  });
  final List<TextEditingController> dialogueControllers;

  @override
  ConsumerState<DialogueWidget> createState() => DialogueWidgetState();
}

class DialogueWidgetState extends ConsumerState<DialogueWidget> {
  final TranslateRepository translateRepository = TranslateRepository();
  final GrammerDataRepository grammerDataRepository = GrammerDataRepository();

  final List<String> _languageTitles = ["한국어", "ENG", "CHN", "VIE", "RUS"];
  final List<String> characterTypes = ['차카', '송송', '옹', '룰루', '핑'];

  int _selectedLanguage = 0;
  bool _isTranslating = false;

  final List<String> _hintText = [
    '<제목>\n[대괄호]를 입력해서 강조하세요.\n*별표*로 주석을 첨가하세요.\n{}로 화자를 표시하세요.',
    '<Title>\nUse [brackets] to emphasize.\nAdd *asterisks* for comments.\nUse {} to indicate the speaker.',
    '<标题>\n使用[方括号]强调。\n添加*星号*进行评论。\n使用{}表示发言者。',
    '<Tiêu đề>\nSử dụng [dấu ngoặc vuông] để nhấn mạnh.\nThêm *dấu sao* để bình luận.\nSử dụng {} để chỉ định người nói.',
    '<Заголовок>\nИспользуйте [квадратные скобки] для выделения.\nДобавьте *звездочки* для комментариев.\nИспользуйте {} для указания говорящего.',
  ];

  // 제시문 오디오 파일 업로드
  void getAudioUrl() async {
    // level, cycle, sets, chapter 가져오기

    LEVEL? level = ref.read(introProvider).level;
    int? cycle = ref.read(introProvider).cycle;
    int? sets = ref.read(introProvider).sets;
    int? chapter = ref.read(introProvider).chapter;

    String audioName =
        'dialogue_${level.toString().split('.').last}_${cycle}_${sets}_$chapter';

    if (chapter == null || chapter == '') {
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
          ref.watch(grammarDataProvider.notifier).updateDialogueAudioUrl(value);
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
      player.play();
    } catch (e) {
      print(e);
    }
  }

  // 저장
  save() {
    ref.read(grammarDataProvider.notifier).updateDialogue(
          dialogue: widget.dialogueControllers[0].text,
          dialogueEng: widget.dialogueControllers[1].text,
          dialogueChn: widget.dialogueControllers[2].text,
          dialogueVie: widget.dialogueControllers[3].text,
          dialogueRus: widget.dialogueControllers[4].text,
        );
  }

  // 번역
  translate() async {
    setState(() {
      _isTranslating = true;
    });
    try {
      bool isKoreanFilled = widget.dialogueControllers[0].text.isNotEmpty;

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
        korean: widget.dialogueControllers[0].text,
        english: widget.dialogueControllers[1].text,
      );
      print(response);
      widget.dialogueControllers[1].text = response?.english ?? '';
      widget.dialogueControllers[2].text = response?.chinese ?? '';
      widget.dialogueControllers[3].text = response?.vietnam ?? '';
      widget.dialogueControllers[4].text = response?.russian ?? '';
    } catch (e) {
      print("error : $e");
    }
    setState(() {
      _isTranslating = false;
    });
  }

  @override
  void initState() {
    super.initState();

    widget.dialogueControllers[0].text =
        ref.read(grammarDataProvider).dialogue ?? '';
    widget.dialogueControllers[1].text =
        ref.read(grammarDataProvider).dialogueEng ?? '';
    widget.dialogueControllers[2].text =
        ref.read(grammarDataProvider).dialogueChn ?? '';
    widget.dialogueControllers[3].text =
        ref.read(grammarDataProvider).dialogueVie ?? '';
    widget.dialogueControllers[4].text =
        ref.read(grammarDataProvider).dialogueRus ?? '';
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
                          controller:
                              widget.dialogueControllers[_selectedLanguage],
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
                                    widget
                                        .dialogueControllers[_selectedLanguage]
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
                      onTap: () => translate(),
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
                        child: Center(
                          child: _isTranslating
                              ? const CircularProgressIndicator()
                              : const Text(
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
                    GestureDetector(
                      onTap: () async {
                        String? audioUrl =
                            ref.read(grammarDataProvider).grammarAudioUrl;
                        await playAudio(audioUrl: audioUrl);
                      },
                      child: Image.asset('assets/images/blue_head.png',
                          width: 40, height: 40),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 300,
                      child: RichText(
                        text: TextSpan(
                          children: parseDialogueLine(widget
                              .dialogueControllers[_selectedLanguage].text),
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
