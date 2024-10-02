import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haru_admin/api/test_data_services.dart';
import 'package:haru_admin/model/test_data_model.dart';
import 'package:haru_admin/utils/convert_problem_list.dart';
import 'package:haru_admin/utils/enum_type.dart';
import 'package:haru_admin/widgets/buttons.dart';
import 'package:haru_admin/widgets/problem_table.dart';

import '../../provider/intro_provider.dart';
import '../../utils/generate_word_quiz.dart';
import '../../widgets/quiz_test_upper_table.dart';

class AddQuizScreen extends ConsumerStatefulWidget {
  const AddQuizScreen(this.category, this.introId, {super.key});
  final String? category;
  final String? introId;

  @override
  ConsumerState<AddQuizScreen> createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends ConsumerState<AddQuizScreen> {
  static const int MAXIMUM_PROBLEM_CNT = 100;

  final TestDataRepository testDataRepository = TestDataRepository();
  IntroInfo info = IntroInfo(
    dataId: 0,
    category: CATEGORY.WORD,
    level: LEVEL.LEVEL1,
    cycle: 0,
    sets: 0,
    chapter: 0,
    title: '',
  );

  final List<bool> _selected =
      List.generate(MAXIMUM_PROBLEM_CNT, (index) => false);
  bool _isLoading = false;
  List<String> _exampleData = [];
  List<ProblemDataModel> _problemList = [];
  List<List<TextEditingController>> textControllers = [];

  int? dropdownValue;

  /*
  * 문제 타입
  * (1) 단어 퀴즈 - 101 ~ 104
  * (2) 문법 퀴즈 - 201 ~ 208
  * (3) 테스트 - 101 ~ 208
  * (4) 중간평가 - 101 ~ 208
  */
  Map<CATEGORY, Map<int, String>> dropdownTitle = {
    CATEGORY.WORD: {
      101: '101. 그림보고 어휘 3지선다',
      102: '102. 어휘보고 그림 3지선다',
      103: '103. 그림보고 타이핑',
      104: '104. 받아쓰기',
    },
    CATEGORY.GRAMMAR: {
      201: '201. 그림보고 문장 속 빈칸 넣기',
      202: '202. 순서에 맞게 문장 배치하기',
      203: '203. 문장 속 빈칸 2지OR3지선다 채우기',
      204: '204. 문장 속 빈칸에 들어갈 수 없는 말',
      205: '205. 예시 문장처럼 문제 문장 바꾸기',
      206: '206. 문장 속 틀린 부분 찾기',
      207: '207. 문장 받아쓰기',
      208: '208. 제시 문장이 문법적으로 옳은지 OX 퀴즈',
    },
  };

  autogenerate() {
    // '단어 문제를 자동 생성합니다. 기존 문제는 덮어씌워 집니다.' 메시지 출력
    List<int> wordsTypes = List.generate(_exampleData.length, (index) {
      // 101 이나 102 둘 중하나
      return index % 2 == 0 ? 101 : 102;
    });

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
                title: const Text(
                  '단어 문제를 자동 생성합니다. 기존 문제는 삭제, 덮어씌워지고 자동 저장됩니다.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                // exampleData 단어, 2개의 체크 박스
                content: SingleChildScrollView(
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(2),
                    },
                    children: [
                      for (var example in _exampleData)
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(example),
                            ),
                            // radio button
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  for (var type in [101, 102, 103, 104])
                                    Row(
                                      children: [
                                        Radio(
                                          value: type,
                                          groupValue: wordsTypes[
                                              _exampleData.indexOf(example)],
                                          onChanged: (int? value) {
                                            setState(() {
                                              wordsTypes[_exampleData
                                                  .indexOf(example)] = value!;
                                            });
                                          },
                                        ),
                                        Text(dropdownTitle[CATEGORY.WORD]![
                                            type]!),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                actions: [
                  MyCustomButton(
                    text: '취소',
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    color: Colors.blue,
                    colorBorder: true,
                  ),
                  MyCustomButton(
                    text: '확인',
                    onTap: () async {
                      // 자동 생성 알고리즘 실행
                      setState(() {
                        _isLoading = true;
                      });
                      List<ProblemDataModel> problems = generateWordQuiz(
                        words: _exampleData,
                        wordsTypes: wordsTypes,
                        frameModel: ProblemDataModel(
                          sequence: 0, // 덮어씌우기
                          problemType: 101, // 덮어씌우기
                          level: info.level.toString().split('.').last,
                          category: 'WORD',
                          cycle: info.cycle,
                          sets: info.sets,
                          chapter: info.chapter,
                        ),
                      );
                      // textController 초기화하고 다시 fetch

                      for (var controller in textControllers) {
                        for (var c in controller) {
                          c.dispose();
                        }
                      }
                      textControllers.clear();

                      // 기존 데이터 다 지우기
                      for (var problem in _problemList) {
                        if (problem.id != null) {
                          await testDataRepository.deleteTest(id: problem.id!);
                        }
                      }

                      await testDataRepository.postTestData(
                          testDataList: problems);
                      await fetchTestData(int.parse(widget.introId!));

                      // Navigator.of(context).pop();
                    },
                    color: Colors.blue,
                  ),
                ]);
          });
        });
  }

  Future<void> fetchTestData(int id) async {
    try {
      setState(() {
        _isLoading = true;
      });

      // 데이터 넣기
      await testDataRepository.getTestData(id: id).then((value) {
        if (widget.introId == null || widget.category == null) {
          return;
        }
        List<ProblemDataModel>? tempList = value.problemList;
        if (tempList != null && tempList.isNotEmpty) {
          tempList.sort((a, b) => a.sequence.compareTo(b.sequence));
          // 텍스트 컨트롤러 초기화
          for (var problem in tempList) {
            List<TextEditingController> temp = [];
            List<String?> contents = convertProblemContentsToList(problem);

            for (var i = 0; i < contents.length; i++) {
              temp.add(TextEditingController(text: contents[i] ?? ''));
            }
            textControllers.add(temp);
          }
        }

        setState(() {
          _exampleData = value.exampleList;
          _problemList = tempList ?? [];
          info = info.copyWith(
            dataId: id,
            category: categoryFromString(widget.category!),
            level: levelFromString(value.level),
            cycle: value.cycle,
            sets: value.set,
            chapter: value.chapter,
            title: value.title,
          );
        });
      });

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  addNewProblem() {
    if (dropdownValue == null) {
      // TODO: show "Please select a type" message

      return;
    }
    List<TextEditingController> temp = List.generate(
        ProblemTable.tableTitle[dropdownValue]!.length,
        (index) => TextEditingController());

    setState(() {
      _isLoading = true;

      textControllers.add(temp);

      _problemList.add(ProblemDataModel(
        level: info.level.toString().split('.').last,
        category: info.category.toString().split('.').last,
        cycle: info.cycle,
        sets: info.sets,
        chapter: info.chapter,
        sequence: _problemList.length + 1,
        problemType: dropdownValue!,
      ));

      _isLoading = false;
    });
  }

  save() async {
    try {
      setState(() {
        _isLoading = true;
      });

      List<ProblemDataModel> problems = [];
      int idx = 0;

      for (var problem in _problemList) {
        List<String> contents = [];
        for (var controller in textControllers[idx]) {
          String? text = controller.text;
          if (text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Center(child: Text('입력하지 않은 항목이 있습니다.')),
                showCloseIcon: true,
                closeIconColor: Colors.white,
              ),
            );
            setState(() {
              _isLoading = false;
            });
            return;
          }
          contents.add(text);
        }

        ProblemDataModel? data = convertListToProblemContents(
          frameModel: problem.copyWith(
            sequence: idx + 1,
            level: info.level.toString().split('.').last,
            category: info.category.toString().split('.').last,
            cycle: info.cycle,
            sets: info.sets,
            chapter: info.chapter,
          ),
          contents: contents,
        );

        if (data == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(child: Text('입력하지 않은 항목이 있습니다.')),
              showCloseIcon: true,
              closeIconColor: Colors.white,
            ),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        problems.add(data);
        idx++;
      }

      await testDataRepository.postTestData(testDataList: problems);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  void deleteSelected() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              '선택한 데이터를 삭제하시겠습니까?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            content: SizedBox(
              width: 400,
              height: 100,
              child: SingleChildScrollView(
                child: Text(
                  _problemList.fold(
                      "",
                      (previousValue, element) =>
                          previousValue +
                          (_selected[_problemList.indexOf(element)]
                              ? '${element.sequence} 번\n'
                              : '')),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  try {
                    if (_problemList.isEmpty) {
                      return;
                    }
                    List<int> selectedProblemIds = [];
                    for (int idx = 0; idx < _problemList.length; idx++) {
                      if (_selected[idx] && _problemList[idx].id != null) {
                        selectedProblemIds.add(_problemList[idx].id!);
                      }
                    }

                    for (var id in selectedProblemIds) {
                      await testDataRepository.deleteTest(id: id);
                      // delete from _problemList
                    }

                    // textController 초기화하고 다시 fetch
                    setState(() {
                      _isLoading = true;
                    });
                    for (var controller in textControllers) {
                      for (var c in controller) {
                        c.dispose();
                      }
                    }
                    textControllers.clear();
                    fetchTestData(int.parse(widget.introId!));
                  } catch (e) {
                    throw Exception(e);
                  }

                  setState(() {
                    // sequqence 업데이터
                    for (int i = 0; i < _problemList.length; i++) {
                      _problemList[i] =
                          _problemList[i].copyWith(sequence: i + 1);
                    }
                    _selected.fillRange(0, MAXIMUM_PROBLEM_CNT, false);
                  });
                },
                child: const Text('확인'),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    fetchTestData(int.parse(widget.introId!));
  }

  @override
  void dispose() {
    for (var controller in textControllers) {
      for (var c in controller) {
        c.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Flexible(
                flex: 1,
                child: Text(
                  '퀴즈 -> 해당 세트의 단어 활용\n테스트 -> 이전까지 배운 단어 활용',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF5CD1FF),
                  ),
                ),
              ),
              const Flexible(
                flex: 3,
                child: Center(
                  child: Text(
                    '퀴즈/테스트 데이터',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              info.category == CATEGORY.WORD
                  ? Flexible(
                      flex: 1,
                      child: MyCustomButton(
                        text: '자동 생성',
                        onTap: () => autogenerate(),
                        color: Colors.pink,
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(width: 10),
              Flexible(
                flex: 1,
                child: MyCustomButton(
                  text: '저장하기',
                  onTap: () => save(),
                  color: const Color(0xFF3F99F7),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                  flex: 1,
                  child: MyCustomButton(
                    text: 'Confirm',
                    onTap: () => save(),
                    color: const Color(0xFFFF7D53),
                  )),
            ],
          ),
          UpperTable(
            info: info,
            exampleList: _exampleData,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 15),
              Checkbox(
                value: _selected.every((element) => element),
                onChanged: (bool? value) {
                  setState(() {
                    for (int i = 0; i < _selected.length; i++) {
                      _selected[i] = value!;
                    }
                  });
                },
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () {
                  deleteSelected();
                },
                child: const Text(
                  '선택 삭제',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          _isLoading
              ? const CircularProgressIndicator()
              : Expanded(
                  child: ReorderableListView(
                    header: const TestTableHeader(),
                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        // sequence 변경
                        for (var i = 0; i < _problemList.length; i++) {
                          if (i == oldIndex) {
                            _problemList[i] = _problemList[i].copyWith(
                              sequence: newIndex + 1,
                            );
                          } else if (oldIndex < newIndex) {
                            if (i > oldIndex && i <= newIndex) {
                              _problemList[i] = _problemList[i].copyWith(
                                sequence: i,
                              );
                            }
                          } else {
                            if (i < oldIndex && i >= newIndex) {
                              _problemList[i] = _problemList[i].copyWith(
                                sequence: i + 2,
                              );
                            }
                          }
                        }

                        final item = _problemList.removeAt(oldIndex);
                        _problemList.insert(newIndex, item);

                        final item2 = textControllers.removeAt(oldIndex);
                        textControllers.insert(newIndex, item2);
                      });
                    },
                    children: List.generate(
                      _problemList.length,
                      (index) => ListTile(
                        key: ValueKey(index),
                        leading: Checkbox(
                          value: _selected[index],
                          onChanged: (bool? value) {
                            setState(() {
                              _selected[index] = value!;
                            });
                          },
                        ),
                        title: TestTableElement(
                          orderedNumber: index + 1,
                          problemType: _problemList[index].problemType,
                          problemWidget: ProblemTable(
                            problem: _problemList[index],
                            textController: textControllers[index],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          const Divider(
            color: Colors.black,
            height: 2,
            indent: 10,
            endIndent: 10,
          ),
          SizedBox(
            height: 80,
            width: 1000,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: SizedBox(
                    width: 60,
                    child: Text('타입 선택',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 300,
                  child: DropdownButton(
                    value: dropdownValue,
                    items: dropdownTitle[info.category]!
                        .entries
                        .map((e) => DropdownMenuItem(
                              value: e.key,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(
                                  e.value,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  dropdownValue = e.key;
                                });
                              },
                            ))
                        .toList(),
                    onChanged: (int? value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: MyCustomButton(
                    text: '추가',
                    onTap: () => addNewProblem(),
                    color: Colors.blue,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class TestTableHeader extends StatelessWidget {
  const TestTableHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 2, right: 1),
          child: SizedBox(
            width: 50,
            height: 30,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0xFFD9D9D9),
              ),
              child: Center(
                child: Text(
                  '',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 2, right: 1),
          child: SizedBox(
            width: 50,
            height: 30,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0xFFD9D9D9),
              ),
              child: Center(
                child: Text(
                  '순서',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 1, right: 1),
          child: SizedBox(
            width: 50,
            height: 30,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0xFFD9D9D9),
              ),
              child: Center(
                child: Text(
                  '타입',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 1, right: 2),
            child: SizedBox(
              height: 30,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xFFD9D9D9),
                ),
                child: Center(
                  child: Text(
                    '문제',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TestTableElement extends StatelessWidget {
  const TestTableElement({
    super.key,
    required this.orderedNumber,
    required this.problemType,
    required this.problemWidget,
  });

  final int orderedNumber;
  final int problemType;
  final Widget problemWidget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 40,
          height: 80,
          child: Center(
            child: Text(
              orderedNumber.toString(),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 1, right: 1),
          child: SizedBox(
            width: 45,
            height: 80,
            child: Center(
              child: Text(
                problemType.toString(),
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 15),
            child: SizedBox(
              height: 80,
              child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Color(0xFFD9D9D9),
                  ),
                  child: problemWidget),
            ),
          ),
        ),
      ],
    );
  }
}
