import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haru_admin/api/intro_data_services.dart';
import 'package:haru_admin/model/intro_data_model.dart';
import 'package:haru_admin/screens/grammer/widget/dialogue_widget.dart';
import 'package:haru_admin/utils/convert_word_title.dart';
import 'package:haru_admin/utils/enum_type.dart';

import 'package:haru_admin/widgets/colors.dart';

import '../../widgets/buttons.dart';

class IntroInfo {
  int? dataId;
  LEVEL? level;
  CATEGORY? category;
  int? cycle;
  int? sets;
  int? chapter;
  String? title;
  List<String>? wordDatas;

  IntroInfo({
    this.dataId,
    this.level,
    this.category,
    this.cycle,
    this.sets,
    this.chapter,
    this.title,
    this.wordDatas,
  });

  IntroInfo copyWith({
    int? dataId,
    LEVEL? level,
    CATEGORY? category,
    int? cycle,
    int? sets,
    int? chapter,
    String? title,
    List<String>? wordDatas,
  }) {
    return IntroInfo(
      dataId: dataId ?? this.dataId,
      level: level ?? this.level,
      category: category ?? this.category,
      cycle: cycle ?? this.cycle,
      sets: sets ?? this.sets,
      chapter: chapter ?? this.chapter,
      title: title ?? this.title,
      wordDatas: wordDatas ?? this.wordDatas,
    );
  }
}

class IntroInfoNotifier extends Notifier<IntroInfo> {
  @override
  IntroInfo build() => IntroInfo();

  void update({
    int? dataId,
    LEVEL? level,
    CATEGORY? category,
    int? cycle,
    int? sets,
    int? chapter,
    String? title,
    List<String>? wordDatas,
  }) {
    state = state.copyWith(
      dataId: dataId,
      level: level,
      category: category,
      cycle: cycle,
      sets: sets,
      chapter: chapter,
      title: title,
      wordDatas: wordDatas,
    );
  }
}

/// 인트로 데이터 조회/수정 화면
/// 수정 -> 타이틀만 수정가능
///
final introProvider =
    NotifierProvider<IntroInfoNotifier, IntroInfo>(IntroInfoNotifier.new);

class AddIntroScreen extends ConsumerStatefulWidget {
  const AddIntroScreen({super.key});

  @override
  ConsumerState<AddIntroScreen> createState() => _AddIntroScreenState();
}

class _AddIntroScreenState extends ConsumerState<AddIntroScreen> {
  final IntroDataRepository introRepository = IntroDataRepository();

  static const Map<String, String> categoryMap = {
    'WORD': '단어',
    'GRAMMAR': '문법',
    'TEST': '테스트',
    'MIDTERM': '중간평가',
  };
  List<String> wordList = [];
  late List<TextEditingController> _controllers;
  late IntroInfo info;

  addWord() {
    if (wordList.length > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('단어는 최대 10개까지 입력 가능합니다.')),
          showCloseIcon: true,
          closeIconColor: Colors.white,
        ),
      );
      return;
    }
    setState(() {
      wordList.add('');
    });
  }

  saveIntroData() async {
    try {
      if (info.category == null ||
          info.level == null ||
          info.cycle == null ||
          info.chapter == null ||
          info.sets == null ||
          info.title == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(child: Text('모든 항목을 입력해주세요')),
            showCloseIcon: true,
            closeIconColor: Colors.white,
          ),
        );
        return;
      }

      if (wordList.isNotEmpty) {
        bool isWordFilled = wordList.every((element) {
          if (element.isEmpty || element == '') {
            return false;
          }
          return true;
        });

        if (isWordFilled) {
          ref.watch(introProvider.notifier).update(wordDatas: wordList);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(child: Text('단어를 입력해주세요')),
              showCloseIcon: true,
              closeIconColor: Colors.white,
            ),
          );
          return;
        }
      }
      if (info.dataId == null) {
        // 새로 데이터 POST
        await introRepository
            .addToIntroData(
                data: AddIntroData(
          id: info.dataId,
          level: info.level.toString().split('.')[1],
          category: info.category.toString().split('.')[1],
          chapter: info.chapter!,
          cycle: info.cycle!,
          sets: info.sets!,
          titleKor: convertWordListToString(title: info.title, words: wordList),
        ))
            .then((value) {
          ref.watch(introProvider.notifier).update(dataId: value.id);

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Center(child: Text('새로운 챕터를 추가하였습니다.')),
            showCloseIcon: true,
            closeIconColor: Colors.white,
          ));
        });
      } else {
        // 해당 아이디 데이터 PATCH
        await introRepository
            .updateIntroData(
                id: info.dataId!,
                data: UpdateIntroData(
                  level: info.level.toString().split('.')[1],
                  category: info.category.toString().split('.')[1],
                  cycle: info.cycle!,
                  sets: info.sets!,
                  chapter: info.chapter!,
                  titleKor: convertWordListToString(
                      title: info.title, words: wordList),
                ))
            .then((value) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Center(child: Text('수정을 완료하였습니다.')),
            showCloseIcon: true,
            closeIconColor: Colors.white,
          ));
        });
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  void delete() {
    if (wordList.isEmpty) {
      return;
    }
    setState(() {
      wordList.removeLast();
    });
  }

  @override
  void initState() {
    super.initState();
    info = ref.read(introProvider);

    wordList = info.wordDatas ?? [];
    _controllers = wordList.map((word) {
      final controller = TextEditingController(text: word);
      controller.addListener(() {
        wordList[_controllers.indexOf(controller)] = controller.text;
      });
      return controller;
    }).toList();
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Update controllers if wordList changes
    if (wordList.length != _controllers.length) {
      _controllers = wordList.map((word) {
        final controller = TextEditingController(text: word);
        controller.addListener(() {
          wordList[_controllers.indexOf(controller)] = controller.text;
        });
        return controller;
      }).toList();
    }

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Center(
            child: Text(
              "인트로 데이터 조회/수정",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    HeaderText(text: "레벨"),
                    HeaderText(text: "유형"),
                    HeaderText(text: "사이클"),
                    HeaderText(text: "세트"),
                    HeaderText(text: "회차"),
                    HeaderText(text: "타이틀"),
                    SizedBox(height: 60),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    // 1. 레벨 //
                    RowBox(
                      child: DropdownButton(
                        value: info.level,
                        isExpanded: true,
                        items: LEVEL.values
                            .map((LEVEL option) => DropdownMenuItem(
                                  value: option,
                                  child: Text(option.toString().split('.')[1]),
                                ))
                            .toList(),
                        onChanged: (LEVEL? level) {
                          setState(() {
                            info = info.copyWith(level: level);
                          });
                        },
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        borderRadius: BorderRadius.circular(10),
                        underline: Container(
                          height: 0,
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                    // 2. 카테고리 //
                    SizedBox(
                      width: 350,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: CATEGORY.values
                            .map((CATEGORY option) => Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<CATEGORY>(
                                      value: option,
                                      groupValue: info.category,
                                      onChanged: (CATEGORY? value) {
                                        setState(() {
                                          info = info.copyWith(category: value);
                                        });
                                      },
                                    ),
                                    Text(
                                      categoryMap[
                                          option.toString().split('.')[1]]!,
                                    ),
                                  ],
                                ))
                            .toList(),
                      ),
                    ),

                    // 3. 사이클 //
                    RowBox(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        controller: TextEditingController(
                          text: info.cycle != null ? info.cycle.toString() : '',
                        ),
                        onChanged: (value) {
                          setState(() {
                            info = info.copyWith(cycle: int.parse(value));
                          });
                        },
                      ),
                    )),

                    // 4. 세트 //
                    RowBox(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        controller: TextEditingController(
                          text: info.sets != null ? info.sets.toString() : '',
                        ),
                        onChanged: (value) {
                          setState(() {
                            info = info.copyWith(sets: int.parse(value));
                          });
                        },
                      ),
                    )),

                    // 5. 챕터 //
                    RowBox(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        controller: TextEditingController(
                          text: info.chapter != null
                              ? info.chapter.toString()
                              : '',
                        ),
                        onChanged: (value) {
                          setState(() {
                            info = info.copyWith(chapter: int.parse(value));
                          });
                        },
                      ),
                    )),

                    // 6. 타이틀 //
                    RowBox(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextField(
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        controller: TextEditingController(text: info.title),
                        onChanged: (value) {
                          setState(() {
                            info.title = value;
                          });
                        },
                      ),
                    )),
                    const SizedBox(height: 30),

                    // 저장 버튼 //
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: blueColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 130,
                          vertical: 25,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                        ),
                      ),
                      onPressed: () {
                        saveIntroData();
                      },
                      child: const Text('저장'),
                    ),
                  ],
                ),

                const SizedBox(width: 10),
                // 7. 단어 리스트 //
                info.category == CATEGORY.WORD
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("단어 리스트",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              MyCustomButton(
                                text: '추가',
                                onTap: () => addWord(),
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 10),
                              MyCustomButton(
                                text: '삭제',
                                onTap: () => delete(),
                                color: Colors.red,
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xFFD9D9D9)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SizedBox(
                                width: 350,
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: Center(
                                  child: wordList.isEmpty
                                      ? const Text(
                                          '<추가> 버튼을 눌러\n단어를 추가해 주세요.',
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                          textAlign: TextAlign.center,
                                        )
                                      : SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: List.generate(
                                              wordList.length,
                                              (index) => ListTile(
                                                key: ValueKey(index),
                                                leading: Text(
                                                  (index + 1).toString(),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                title: TextField(
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                  decoration: InputDecoration(
                                                    hintText: '단어를 입력해주세요',
                                                    hintStyle: TextStyle(
                                                        height: 1,
                                                        fontSize: 12,
                                                        color:
                                                            Colors.grey[500]),
                                                    border: InputBorder.none,
                                                  ),
                                                  onEditingComplete: () {
                                                    addWord();
                                                  },
                                                  controller:
                                                      _controllers[index],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                )),
                          ),
                        ],
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RowBox extends StatelessWidget {
  const RowBox({
    super.key,
    required this.child,
  });

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD9D9D9)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SizedBox(
          width: 350,
          height: 50,
          child: Center(child: child),
        ),
      ),
    );
  }
}

class HeaderText extends StatelessWidget {
  const HeaderText({
    super.key,
    required this.text,
  });

  final String? text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 52,
      child: Center(
        child: RichText(
          textAlign: TextAlign.end,
          text: TextSpan(
            children: [
              TextSpan(
                text: text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Color(0xFFF05A2A),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
