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
  late TextEditingController _korcontroller;
  late TextEditingController _engcontroller;
  late TextEditingController _chncontroller;
  late TextEditingController _viecontroller;
  late TextEditingController _ruscontroller;
  late DialogueData _dialogueData;
  List<String> _inputText = [
    '한국어 대사',
    'English Dialogue',
    '中文对话',
    'Tiếng Việt',
    'Русский диалог',
  ];

  @override
  void initState() {
    super.initState();

    _dialogueData = ref.read(DialogueDataProvider.notifier).state;

    _inputText = [
      _dialogueData.korean ?? '',
      _dialogueData.english ?? '',
      _dialogueData.chinese ?? '',
      _dialogueData.vietnamese ?? '',
      _dialogueData.russian ?? '',
    ];

    _korcontroller = TextEditingController(text: _inputText[0]);
    _engcontroller = TextEditingController(text: _inputText[1]);
    _chncontroller = TextEditingController(text: _inputText[2]);
    _viecontroller = TextEditingController(text: _inputText[3]);
    _ruscontroller = TextEditingController(text: _inputText[4]);
  }

  @override
  void dispose() {
    _korcontroller.dispose();
    _engcontroller.dispose();
    _chncontroller.dispose();
    _viecontroller.dispose();
    _ruscontroller.dispose();
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
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 5),
                      ),
                      controller: _selectedLanguage == 0
                          ? _korcontroller
                          : _selectedLanguage == 1
                              ? _engcontroller
                              : _selectedLanguage == 2
                                  ? _chncontroller
                                  : _selectedLanguage == 3
                                      ? _viecontroller
                                      : _ruscontroller,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(DialogueDataProvider.notifier).update(
                            DialogueData(
                              korean: _korcontroller.text,
                              english: _engcontroller.text,
                              chinese: _chncontroller.text,
                              vietnamese: _viecontroller.text,
                              russian: _ruscontroller.text,
                            ),
                          );
                    },
                    child: const Text('저장'),
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
