import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haru_admin/api/test_data_services.dart';
import 'package:haru_admin/model/test_data_model.dart';
import 'package:haru_admin/screens/intro/add_intro.dart';
import 'package:haru_admin/utils/enum_type.dart';
import 'package:haru_admin/widgets/problem_provider.dart';
import 'package:haru_admin/widgets/button.dart';
import 'package:haru_admin/widgets/problem_table.dart';

class AddTestScreen extends ConsumerStatefulWidget {
  const AddTestScreen({super.key});

  @override
  ConsumerState<AddTestScreen> createState() => _AddTestScreenState();
}

class _AddTestScreenState extends ConsumerState<AddTestScreen> {
  final TestDataRepository testDataRepository = TestDataRepository();
  static const int MAXIMUM_PROBLEM_CNT = 100;

  IntroInfo infoData = const IntroInfo(
    dataId: 0,
    level: LEVEL.LEVEL1,
    cycle: 0,
    sets: 0,
    chapter: 0,
    title: '',
  );
  bool _isLoading = false;
  List<String> _exampleData = [];
  List<ProblemDataModel> _problemList = [];
  final List<bool> _selected =
      List.generate(MAXIMUM_PROBLEM_CNT, (index) => false);

  /*
  * 문제 타입
  * (1) 단어 퀴즈 - 101 ~ 104
  * (2) 문법 퀴즈 - 201 ~ 208
  * (3) 테스트 - 101 ~ 208
  * (4) 중간평가 - 101 ~ 208
  */
  Map<int, String> dropdownTitle = {
    101: '101. 그림보고 어휘 3지선다',
    102: '102. 어휘보고 그림 3지선다',
    103: '103. 그림보고 타이핑',
    104: '104. 받아쓰기',
    201: '201. 그림보고 어휘 3지선다',
    202: '202. 어휘보고 그림 3지선다',
    203: '203. 그림보고 타이핑',
    204: '204. 받아쓰기',
    205: '205. 어휘보고 그림 3지선다',
    206: '206. 그림보고 타이핑',
    207: '207. 그림보고 타이핑',
    208: '208. OX 퀴즈',
  };
  int dropdownValue = 101;

  Future<void> fetchTestData(int id) async {
    try {
      setState(() {
        _isLoading = true;
      });

      await testDataRepository.getTestData(id: id).then((value) {
        setState(() {
          _exampleData = value.exampleList;
          _problemList = value.problemList;
        });
      });

      ref.read(problemContentsProvider.notifier).setContentsList(_problemList
          .map((e) => ProblemContents(
                problemType: e.problemType,
                choice1: e.choice1,
                choice2: e.choice2,
                choice3: e.choice3,
                choice4: e.choice4,
                answerNumber: e.answerNumber,
                answerString: e.answerString,
                picture: e.picture,
                pictureDescription: e.pictureDescription,
                questionString: e.questionString,
                exampleOriginal: e.exampleOriginal,
                exampleChanged: e.exampleChanged,
                directionKor: e.directionKor,
                audio: e.audio,
              ))
          .toList());

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  addNewProblem() {
    setState(() {
      _problemList.add(ProblemDataModel(
        problemType: dropdownValue,
        sequence: _problemList.length + 1,
      ));
    });
  }

  save() async {
    try {
      await testDataRepository.addTestDataList(_problemList);
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
                              ? '${element.id}\n'
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
                    for (int i = 0; i < _selected.length; i++) {
                      if (_selected[i]) {
                        _problemList.removeAt(i);
                      }
                    }
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
    infoData = ref.read(introProvider);
    fetchTestData(infoData.dataId!);
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
                child: filledButton(
                  buttonName: 'Save',
                  color: Colors.blue,
                  onPressed: () {
                    save();
                  },
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                  flex: 1,
                  child: filledButton(
                    buttonName: 'Confirm',
                    color: const Color(0xFFFF7D53),
                    onPressed: () {},
                  )),
            ],
          ),
          UpperTable(
            info: infoData,
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
                            problemType: _problemList[index].problemType,
                            index: index,
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
                  width: 200,
                  child: DropdownButton(
                    value: dropdownValue,
                    items: dropdownTitle.entries
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
                  child: filledButton(
                    buttonName: '추가',
                    color: Colors.blue,
                    onPressed: () {
                      addNewProblem();
                    },
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: ProblemTable(problemType: dropdownValue),
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

class UpperTable extends StatelessWidget {
  const UpperTable({
    super.key,
    required this.info,
  });
  final IntroInfo info;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 600,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Row(
                children: [
                  const SizedBox(
                    width: 50,
                    height: 30,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0xFFD9D9D9),
                      ),
                      child: Center(
                        child: Text(
                          '레벨',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                        child: Text(
                          info.level.toString().split('.').last,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                    height: 30,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0xFFD9D9D9),
                      ),
                      child: Center(
                        child: Text(
                          '사이클',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                        child: Text(
                          info.cycle.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                    height: 30,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0xFFD9D9D9),
                      ),
                      child: Center(
                        child: Text(
                          '세트',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                        child: Text(
                          info.sets.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(children: [
              const SizedBox(
                width: 50,
                height: 30,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                  ),
                  child: Center(
                    child: Text(
                      '회차',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 50,
                height: 30,
                child: Center(
                  child: Text(
                    info.chapter.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 50,
                height: 30,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                  ),
                  child: Center(
                    child: Text(
                      '타이틀',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    child: Text(
                      info.title ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ])
          ],
        ),
      ),
    );
  }
}
