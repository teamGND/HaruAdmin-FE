import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haru_admin/api/test_data_services.dart';
import 'package:haru_admin/model/test_data_model.dart';
import 'package:haru_admin/utils/convert_problem_list.dart';
import 'package:haru_admin/utils/enum_type.dart';
import 'package:haru_admin/widgets/buttons.dart';
import 'package:haru_admin/widgets/problem_table.dart';

import '../../provider/intro_provider.dart';
import '../../widgets/quiz_test_upper_table.dart';

class AddQuizScreen extends ConsumerStatefulWidget {
  const AddQuizScreen(this.category, this.introId, {super.key});
  final String? category;
  final String? introId;

  @override
  ConsumerState<AddQuizScreen> createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends ConsumerState<AddQuizScreen> {
  static const int MAXIMUM_PROBLEM_CNT = 50;

  final TestDataRepository testDataRepository = TestDataRepository();
  IntroInfo info = IntroInfo();

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

  Future<void> fetchTestData(int id) async {
    try {
      setState(() {
        _isLoading = true;
      });

      // 데이터 넣기
      await testDataRepository.getTestData(id: id).then((value) {
        setState(() {
          _exampleData = value.exampleList;
          _problemList = value.problemList;
        });
        if (widget.introId == null || widget.category == null) {
          return;
        }
        ref.read(introProvider.notifier).update(
              dataId: int.parse(widget.introId!),
              category: categoryFromString(widget.category!),
              level: levelFromString(value.level),
              cycle: value.cycle,
              sets: value.set,
              chapter: value.chapter,
              title: value.title,
            );
      });

      // 텍스트 컨트롤러 초기화
      for (var problem in _problemList) {
        List<TextEditingController> temp = [];
        List<String?> contents = convertProblemContentsToList(problem);

        for (var i = 0; i < contents.length; i++) {
          temp.add(TextEditingController(text: contents[i] ?? ''));
        }
        textControllers.add(temp);
      }

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
          frameModel: problem,
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
                  setState(() {
                    _problemList = _problemList
                        .where((element) =>
                            !_selected[_problemList.indexOf(element)])
                        .toList();
                    _selected.fillRange(0, _selected.length, false);
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
    info = ref.read(introProvider);
    fetchTestData(info.dataId!);
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
              Flexible(
                flex: 1,
                child: MyCustomButton(
                  text: 'Save',
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
                        final ProblemDataModel item =
                            _problemList.removeAt(oldIndex);
                        _problemList.insert(newIndex, item);
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