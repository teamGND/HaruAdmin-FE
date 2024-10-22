import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haru_admin/api/test_data_services.dart';
import 'package:haru_admin/model/test_data_model.dart';
import 'package:haru_admin/provider/intro_provider.dart';
import 'package:haru_admin/utils/enum_type.dart';
import 'package:haru_admin/widgets/buttons.dart';
import 'package:haru_admin/widgets/problem_table.dart';
import '../../provider/test_provider.dart';
import '../../utils/convert_problem_list.dart';
import '../../widgets/quiz_test_upper_table.dart';

class AddTestScreen extends ConsumerStatefulWidget {
  const AddTestScreen(
    this.category,
    this.introId, {
    super.key,
  });
  final String? category;
  final String? introId;

  @override
  ConsumerState<AddTestScreen> createState() => _AddTestScreenState();
}

class _AddTestScreenState extends ConsumerState<AddTestScreen> {
  static const int MAXIMUM_PROBLEM_CNT = 100;

  final List<bool> _selected =
      List.generate(MAXIMUM_PROBLEM_CNT, (index) => false);
  final List<bool> _selectedPrevious =
      List.generate(MAXIMUM_PROBLEM_CNT, (index) => false);
  final List<ProblemDataModel> _previousProblemList = [];

  late Future<void> testFuture;

  int? dropdownValue;

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
    CATEGORY.TEST: {
      101: '101. 그림보고 어휘 3지선다',
      102: '102. 어휘보고 그림 3지선다',
      103: '103. 그림보고 타이핑',
      104: '104. 받아쓰기',
      201: '201. 그림보고 문장 속 빈칸 넣기',
      202: '202. 순서에 맞게 문장 배치하기',
      203: '203. 문장 속 빈칸 2지OR3지선다 채우기',
      204: '204. 문장 속 빈칸에 들어갈 수 없는 말',
      205: '205. 예시 문장처럼 문제 문장 바꾸기',
      206: '206. 문장 속 틀린 부분 찾기',
      207: '207. 문장 받아쓰기',
      208: '208. 제시 문장이 문법적으로 옳은지 OX 퀴즈',
    },
    CATEGORY.MIDTERM: {
      101: '101. 그림보고 어휘 3지선다',
      102: '102. 어휘보고 그림 3지선다',
      103: '103. 그림보고 타이핑',
      104: '104. 받아쓰기',
      201: '201. 그림보고 문장 속 빈칸 넣기',
      202: '202. 순서에 맞게 문장 배치하기',
      203: '203. 문장 속 빈칸 2지OR3지선다 채우기',
      204: '204. 문장 속 빈칸에 들어갈 수 없는 말',
      205: '205. 예시 문장처럼 문제 문장 바꾸기',
      206: '206. 문장 속 틀린 부분 찾기',
      207: '207. 문장 받아쓰기',
      208: '208. 제시 문장이 문법적으로 옳은지 OX 퀴즈',
    }
  };

  fetch() async {
    ref.watch(introProvider.notifier).update(
          category: categoryFromString(widget.category!),
          dataId: int.parse(widget.introId!),
        );

    await ref.watch(testProvider.notifier).fetchTestData(
          categ: widget.category,
          id: widget.introId,
        );
  }

  @override
  void initState() {
    super.initState();

    testFuture = fetch();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    fetch();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: testFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                AddTestButtons(
                    dropdownTitle: dropdownTitle,
                    isCategoryWord: widget.category == 'WORD'),
                const UpperTable(),
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
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                  '선택한 데이터를 삭제하시겠습니까?',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                content: SizedBox(
                                  width: 400,
                                  height: 100,
                                  child: Text(
                                    ref
                                        .watch(testProvider.notifier)
                                        .getSelectedProblems(
                                            selected: _selected),
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
                                      ref
                                          .watch(testProvider.notifier)
                                          .deleteSelected(
                                            selected: _selected,
                                          );
                                      // selected 초기화
                                      for (int i = 0;
                                          i < _selected.length;
                                          i++) {
                                        _selected[i] = false;
                                      }

                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('확인'),
                                  ),
                                ],
                              );
                            });
                      },
                      child: const Text(
                        '선택 삭제',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const Spacer(),
                    (widget.category == 'TEST' || widget.category == 'MIDTERM')
                        ? TextButton(
                            onPressed: () async {
                              if (widget.category != 'TEST' &&
                                  widget.category != 'MIDTERM') return;

                              await ref
                                  .watch(testProvider.notifier)
                                  .fetchPreviousTestData();

                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(builder:
                                        (BuildContext context,
                                            StateSetter setState) {
                                      return AlertDialog(
                                        title: const Text(
                                          '이전 테스트 문제를 불러옵니다.',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        content: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.6,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: List.generate(
                                                _previousProblemList.length,
                                                (index) => ListTile(
                                                  key: ValueKey(index),
                                                  leading: Checkbox(
                                                    value: _selectedPrevious[
                                                        index],
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        _selectedPrevious[
                                                            index] = value!;
                                                      });
                                                    },
                                                  ),
                                                  title: TestTableElement(
                                                    orderedNumber: index + 1,
                                                    problemType:
                                                        _previousProblemList[
                                                                index]
                                                            .problemType,
                                                    problemWidget: ProblemTable(
                                                      problemIdx: index,
                                                      problemType:
                                                          _previousProblemList[
                                                                  index]
                                                              .problemType,
                                                      problemTexts:
                                                          convertProblemContentsToList(
                                                              _previousProblemList[
                                                                  index]),
                                                      isPrev: true,
                                                    ),
                                                  ),
                                                ),
                                              ),
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
                                              ref
                                                  .watch(testProvider.notifier)
                                                  .saveSelectPreviousTestProblems(
                                                    selectedPrevious:
                                                        _selectedPrevious,
                                                  );
                                              // popup 닫기
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('확인'),
                                          ),
                                        ],
                                      );
                                    });
                                  });
                            },
                            child: const Text(
                              '문제 불러오기',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
                Expanded(
                  child: ref.watch(testProvider).problemList.isEmpty
                      ? const Center(
                          child: Text(
                            '문제가 없습니다.',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : ReorderableListView(
                          header: const TestTableHeader(),
                          onReorder: (int oldIndex, int newIndex) {
                            setState(() {
                              if (oldIndex < newIndex) {
                                newIndex -= 1;
                              }
                            });

                            ref
                                .watch(testProvider.notifier)
                                .reorderProblemOrder(
                                  oldIndex: oldIndex,
                                  newIndex: newIndex,
                                );
                          },
                          children: List.generate(
                            ref.watch(testProvider).problemList.length,
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
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 40,
                                      height: 80,
                                      child: Center(
                                        child: Text(
                                          (index + 1).toString(),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 1, right: 1),
                                      child: SizedBox(
                                        width: 45,
                                        height: 80,
                                        child: Center(
                                          child: Text(
                                            // 문제 타입
                                            ref
                                                .watch(testProvider)
                                                .problemList[index]
                                                .problemType
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 15),
                                        child: SizedBox(
                                          height: 80,
                                          child: DecoratedBox(
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFD9D9D9),
                                            ),
                                            child: ProblemTable(
                                              problemIdx: index,
                                              problemType: ref
                                                  .watch(testProvider)
                                                  .problemList[index]
                                                  .problemType,
                                              problemTexts:
                                                  convertProblemContentsToList(
                                                      ref
                                                          .watch(testProvider)
                                                          .problemList[index]),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey,
                  indent: 10,
                  endIndent: 10,
                ),
                SizedBox(
                  height: 80,
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
                          items: dropdownTitle[
                                  categoryFromString(widget.category!)]!
                              .entries
                              .map((e) => DropdownMenuItem(
                                    value: e.key,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
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
                          onTap: () {
                            if (dropdownValue == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Center(child: Text('생성할 타입을 선택해주세요.')),
                                  showCloseIcon: true,
                                  closeIconColor: Colors.white,
                                ),
                              );

                              return;
                            }

                            ref.watch(testProvider.notifier).addNewProblem(
                                  problemType: dropdownValue!,
                                );
                          },
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
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class AddTestButtons extends ConsumerWidget {
  const AddTestButtons({
    super.key,
    required this.dropdownTitle,
    required this.isCategoryWord,
  });

  final Map<CATEGORY, Map<int, String>> dropdownTitle;
  final bool isCategoryWord;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
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
        isCategoryWord
            ? Flexible(
                flex: 1,
                child: MyCustomButton(
                  text: '자동 생성',
                  onTap: () {
                    List<String> words = ref.read(testProvider).exampleData;

                    List<int> wordsTypes = List.generate(words.length, (index) {
                      // 101 이나 102 둘 중하나
                      return index % 2 == 0 ? 101 : 102;
                    });

                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return AlertDialog(
                                title: const Text(
                                  '단어 문제를 자동 생성합니다. 기존 문제는 삭제, 덮어씌워지고 자동 저장됩니다.',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                // exampleData 단어, 2개의 체크 박스
                                content: SingleChildScrollView(
                                  child: Table(
                                    columnWidths: const {
                                      0: FlexColumnWidth(1),
                                      1: FlexColumnWidth(2),
                                    },
                                    children: [
                                      for (var example in words)
                                        TableRow(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(example),
                                            ),
                                            // radio button
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  for (var type
                                                      in dropdownTitle[
                                                              CATEGORY.WORD]!
                                                          .keys)
                                                    Row(
                                                      children: [
                                                        Radio(
                                                          value: type,
                                                          groupValue:
                                                              wordsTypes[
                                                                  words.indexOf(
                                                                      example)],
                                                          onChanged:
                                                              (int? value) {
                                                            setState(() {
                                                              wordsTypes[words
                                                                      .indexOf(
                                                                          example)] =
                                                                  value!;
                                                            });
                                                          },
                                                        ),
                                                        Text(dropdownTitle[
                                                            CATEGORY
                                                                .WORD]![type]!),
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
                                    color: Colors.blue,
                                    onTap: () async {
                                      ref
                                          .watch(testProvider.notifier)
                                          .createWordProblem(
                                            wordTypes: wordsTypes,
                                          );

                                      // popup 닫기

                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ]);
                          });
                        });
                  },
                  color: Colors.pink,
                ),
              )
            : const SizedBox(),
        const SizedBox(width: 10),
        Flexible(
          flex: 1,
          child: MyCustomButton(
            text: 'Save',
            onTap: () async {
              await ref.watch(testProvider.notifier).save(isFinal: false);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Center(child: Text('저장 완료')),
                  showCloseIcon: true,
                  closeIconColor: Colors.white,
                ),
              );
            },
            color: const Color(0xFF3F99F7),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
            flex: 1,
            child: MyCustomButton(
              text: 'Confirm',
              onTap: () async {
                await ref.watch(testProvider.notifier).save(isFinal: true);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Center(child: Text('유저 앱 반영 완료 🤠')),
                    showCloseIcon: true,
                    closeIconColor: Colors.white,
                  ),
                );
              },
              color: const Color(0xFFFF7D53),
            )),
      ],
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
