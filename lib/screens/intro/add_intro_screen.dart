import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haru_admin/api/intro_data_services.dart';
import 'package:haru_admin/model/intro_data_model.dart';
import 'package:haru_admin/themes/colors.dart';
import 'package:haru_admin/utils/convert_word_title.dart';
import 'package:haru_admin/utils/enum_type.dart';
import 'package:haru_admin/widgets/button.dart';

import 'package:haru_admin/widgets/colors.dart';
import 'package:haru_admin/widgets/gaps.dart';

import '../../provider/intro_provider.dart';

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
    'ALPHABET': '자음모음',
  };
  List<String> wordList = [];
  late TextEditingController _titleController;
  late TextEditingController _cycleController;
  late TextEditingController _setsController;
  late TextEditingController _chapterController;
  late List<TextEditingController> _controllers;
  late IntroInfo info;

  void changeCategory(CATEGORY? value) {
    setState(() {
      info = info.copyWith(category: value);

      if (value == CATEGORY.TEST) {
        _titleController.text = '테스트 ${info.sets}';
      } else if (value == CATEGORY.MIDTERM) {
        _titleController.text = '중간평가 ${info.cycle}';
      } else {
        _titleController.text = info.title ?? '';
      }
    });
  }

  addWord() {
    if (wordList.length >= 15) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('단어는 최대 15개까지 입력 가능합니다.')),
          showCloseIcon: true,
          closeIconColor: Colors.white,
        ),
      );
      return;
    } else {
      setState(() {
        wordList.add('');
      });
    }
  }

  saveIntroData() async {
    try {
      if (info.category == null ||
          info.level == null ||
          info.cycle == null ||
          info.sets == null ||
          info.chapter == null ||
          info.title == null ||
          info.title == '') {
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
        info.title = _titleController.text;

        // 새로 데이터 POST
        AddIntroDataResponse response = await introRepository.addNewIntroData(
            data: AddIntroData(
          level: info.level.toString().split('.')[1],
          category: info.category.toString().split('.')[1],
          chapter: info.chapter!,
          cycle: info.cycle!,
          sets: info.sets!,
          titleKor: (info.category == CATEGORY.WORD)
              ? convertWordListToString(title: info.title, words: wordList)
              : info.title,
        ));
        ref.watch(introProvider.notifier).update(dataId: response.introDataId);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(child: Text('새로운 챕터를 추가하였습니다.')),
          showCloseIcon: true,
          closeIconColor: Colors.white,
        ));
      } else {
        // 해당 아이디 데이터 PATCH
        info.title = _titleController.text;

        await introRepository.updateIntroData(
            id: info.dataId!,
            data: UpdateIntroData(
              level: info.level.toString().split('.')[1],
              category: info.category.toString().split('.')[1],
              cycle: info.cycle!,
              sets: info.sets!,
              chapter: info.chapter!,
              titleKor: (info.category == CATEGORY.WORD)
                  ? convertWordListToString(title: info.title, words: wordList)
                  : info.title,
              status: 'WAIT',
            ));

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(child: Text('수정을 완료하였습니다.')),
          showCloseIcon: true,
          closeIconColor: Colors.white,
        ));
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  void delete({required int index}) {
    if (wordList.isEmpty) {
      return;
    }

    // delete index
    setState(() {
      wordList.removeAt(index);
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
    _titleController = TextEditingController(text: info.title);
    _titleController.addListener(() {
      info = info.copyWith(title: _titleController.text);
    });
    _cycleController = TextEditingController(text: info.cycle.toString());
    _cycleController.addListener(() {
      info = info.copyWith(cycle: int.parse(_cycleController.text));
    });
    _setsController = TextEditingController(text: info.sets.toString());
    _setsController.addListener(() {
      info = info.copyWith(sets: int.parse(_setsController.text));
    });
    _chapterController = TextEditingController(text: info.chapter.toString());
    _chapterController.addListener(() {
      info = info.copyWith(chapter: int.parse(_chapterController.text));
    });
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 500,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InputComponent(
                        text: "레벨",
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: DropdownButton(
                              value: info.level,
                              isExpanded: true,
                              items: LEVEL.values
                                  .map((LEVEL option) => DropdownMenuItem(
                                        value: option,
                                        child: Text(
                                            option.toString().split('.')[1]),
                                      ))
                                  .toList(),
                              onChanged: (LEVEL? level) {
                                setState(() {
                                  info = info.copyWith(level: level);
                                });
                              },
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              focusColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              borderRadius: BorderRadius.circular(10),
                              underline: Container(
                                height: 0,
                                color: Colors.transparent,
                              ),
                              icon: const Icon(Icons.keyboard_arrow_down)),
                        ),
                      ),
                      InputComponent(
                        text: "유형",
                        hasBorder: false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Wrap(
                            children: CATEGORY.values
                                .map((CATEGORY option) => Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Radio<CATEGORY>(
                                            value: option,
                                            groupValue: info.category,
                                            onChanged: (CATEGORY? value) {
                                              changeCategory(value);
                                            },
                                            overlayColor:
                                                const WidgetStatePropertyAll(
                                              Colors.transparent,
                                            )),
                                        Text(
                                          categoryMap[
                                              option.toString().split('.')[1]]!,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Gaps.h20,
                                      ],
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                      InputComponent(
                        text: "사이클",
                        child:
                            InputTextField(chapterController: _cycleController),
                      ),
                      InputComponent(
                        text: "세트",
                        child:
                            InputTextField(chapterController: _setsController),
                      ),
                      InputComponent(
                        text: "회차",
                        child: InputTextField(
                            chapterController: _chapterController),
                      ),
                      InputComponent(
                        text: "타이틀",
                        child:
                            InputTextField(chapterController: _titleController),
                      ),
                    ],
                  ),
                ),
                Gaps.v20,
                ClickableButton(
                  text: '저장',
                  onPressed: () => saveIntroData(),
                  color: ColorPallete.green,
                  size: ButtonSize.extraLarge,
                ),
              ],
            ),

            Gaps.h20,
            // 7. 단어 리스트 //
            info.category == CATEGORY.WORD
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 500,
                        width: 450,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 10,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Gaps.v10,
                              Text(
                                "단어 리스트 (${wordList.length}개)",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Gaps.v20,
                              SizedBox(
                                width: 390,
                                height: 400,
                                child: wordList.isEmpty
                                    ? const Center(
                                        child: Text(
                                          '추가 버튼을 눌러\n단어를 추가해 주세요.',
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
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
                                                  fontSize: 13,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              title: TextField(
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                decoration: InputDecoration(
                                                  hintText: '단어를 입력해주세요',
                                                  hintStyle: TextStyle(
                                                      height: 1,
                                                      fontSize: 14,
                                                      color: Colors.grey[500]),
                                                  border: InputBorder.none,
                                                ),
                                                onEditingComplete: () {
                                                  addWord();
                                                },
                                                controller: _controllers[index],
                                              ),
                                              trailing: IconButton(
                                                icon: const Icon(
                                                  Icons.cancel_outlined,
                                                  color: ColorPallete.red,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    delete(index: index);
                                                  });
                                                },
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
                      const Padding(
                        padding: EdgeInsets.all(2),
                        child: Text(
                          '- 최대 15개 추가 가능',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Gaps.v4,
                      SizedBox(
                        width: 450,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ClickableButton(
                              text: '단어 추가',
                              onPressed: () => addWord(),
                              color: ColorPallete.blue,
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}

class InputTextField extends StatelessWidget {
  const InputTextField({
    super.key,
    required TextEditingController chapterController,
  }) : _chapterController = chapterController;

  final TextEditingController _chapterController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(border: InputBorder.none),
        controller: _chapterController,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class InputComponent extends StatelessWidget {
  const InputComponent({
    super.key,
    required this.text,
    required this.child,
    this.hasBorder = true,
  });

  final String? text;
  final Widget? child;
  final bool hasBorder;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 480,
      height: 70,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              child: RichText(
                textAlign: TextAlign.end,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: text,
                      style: const TextStyle(
                        fontSize: 14,
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
            Gaps.h20,
            SizedBox(
              width: 320,
              height: 50,
              child: hasBorder
                  ? DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFD9D9D9),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(child: child),
                    )
                  : child,
            ),
          ],
        ),
      ),
    );
  }
}
