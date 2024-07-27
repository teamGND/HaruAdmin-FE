import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DialogueData {
  final String? korean;
  final String? english;
  final String? chinese;
  final String? vietnamese;
  final String? russian;

  DialogueData({
    this.korean,
    this.english,
    this.chinese,
    this.vietnamese,
    this.russian,
  });

  DialogueData copyWith({
    String? korean,
    String? english,
    String? chinese,
    String? vietnamese,
    String? russian,
  }) {
    return DialogueData(
      korean: korean ?? this.korean,
      english: english ?? this.english,
      chinese: chinese ?? this.chinese,
      vietnamese: vietnamese ?? this.vietnamese,
      russian: russian ?? this.russian,
    );
  }
}

class DialogueDataNotifier extends Notifier<DialogueData> {
  @override
  DialogueData build() => DialogueData();

  void update(DialogueData data) {
    state = data;
  }
}

final DialogueDataProvider =
    NotifierProvider<DialogueDataNotifier, DialogueData>(
        DialogueDataNotifier.new);

class DialogueWidget extends ConsumerStatefulWidget {
  const DialogueWidget({
    super.key,
  });

  @override
  ConsumerState<DialogueWidget> createState() => DialogueWidgetState();
}

class DialogueWidgetState extends ConsumerState<DialogueWidget> {
  final List<String> _languageTitles = ["한국어", "ENG", "CHN", "VIE", "RUS"];
  int _selectedLanguage = 0;
  late DialogueData _dialogueData;

  final List<TextEditingController> _dialogueController = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  final List<String> _inputText = ['', '', '', '', ''];
  final List<String> _hintText = [
    '<제목>\n[대괄호]를 입력해서 강조하세요.\n*별표*로 주석을 첨가하세요.',
    '<Title>\nUse [brackets] to emphasize.\nAdd *asterisks* for comments.',
    '<标题>\n使用[方括号]强调。\n添加*星号*进行评论。',
    '<Tiêu đề>\nSử dụng [dấu ngoặc vuông] để nhấn mạnh.\nThêm *dấu sao* để bình luận.',
    '<Заголовок>\nИспользуйте [квадратные скобки] для выделения.\nДобавьте *звездочки* для комментариев.',
  ];

  save() {
    ref.read(DialogueDataProvider.notifier).update(
          DialogueData(
            korean: _dialogueController[0].text,
            english: _dialogueController[1].text,
            chinese: _dialogueController[2].text,
            vietnamese: _dialogueController[3].text,
            russian: _dialogueController[4].text,
          ),
        );
  }

  @override
  void initState() {
    super.initState();
    _dialogueData = ref.read(DialogueDataProvider.notifier).state;
    for (int i = 0; i < _dialogueController.length; i++) {
      _dialogueController[i].addListener(() {
        setState(() {
          _inputText[i] = _dialogueController[i].text;
        });
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _dialogueController) {
      controller.dispose();
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
                SizedBox(
                  height: 50,
                  width: 300,
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
                ),
                SizedBox(
                  height: 50,
                  width: 300,
                  child: GestureDetector(
                    onTap: save,
                    child: Container(
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
                          '저장',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
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
                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    Image.asset('assets/images/blue_head.png',
                        width: 40, height: 40),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 300,
                      height: 400,
                      child: RichText(
                        text: TextSpan(
                          children: parseText(_inputText[_selectedLanguage]),
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
