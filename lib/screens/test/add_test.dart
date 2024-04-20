import 'package:flutter/material.dart';
import 'package:haru_admin/api/test_data_services.dart';
import 'package:haru_admin/screens/test/entity/test_entity.dart';
import 'package:haru_admin/widgets/problem_table.dart';
import 'package:provider/provider.dart';
import 'package:haru_admin/widgets/button.dart';

class AddTest extends StatefulWidget {
  const AddTest({super.key});

  @override
  State<AddTest> createState() => _AddTestState();
}

class _AddTestState extends State<AddTest> {
  final TestDataRepository testRepository = TestDataRepository();

  Future<dynamic> fetchTestDataInfo =
      Future.delayed(const Duration(milliseconds: 500), () {
    return TestDataRepository().getTestDataList();
  });

  /*
    문제 타입
    (1) 단어 퀴즈 - 101 ~ 104
    (2) 문법 퀴즈 - 201 ~ 208
    (3) 테스트 - 101 ~ 208
    (4) 중간평가 - 101 ~ 208
  */
  int dropdownValue = 101;
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

  @override
  void initState() {
    super.initState();
    // testRepository
    //     .addToIntroDataList(
    //   sampleData,
    // )
    //     .then((value) {
    //   setState(() {
    //     print(value);
    //   });
    // });
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
                  onPressed: () => testRepository.addTestDataList(
                      context.read<TestDataEntityProvider>().testDataList),
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
          const SizedBox(height: 20),
          const UpperTable(),
          SizedBox(
            height: 350,
            child: ReorderableListView(
              header: const TestTableHeader(),
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final testDataEntityProvider =
                      context.read<TestDataEntityProvider>();
                  final testDataList = testDataEntityProvider.testDataList;

                  // Remove the item from the list at the old index
                  final item = testDataList.removeAt(oldIndex);
                  // Insert the item into the list at the new index
                  testDataList.insert(newIndex, item);
                });
              },
              children: List.generate(
                context.watch<TestDataEntityProvider>().testDataList.length,
                (index) => ListTile(
                  key: ValueKey(index),
                  title: TestTableElement(
                    orderedNumber: index + 1,
                    problemType: context
                        .watch<TestDataEntityProvider>()
                        .testDataList[index]
                        .problemType,
                    problemWidget: ProblemTable(
                      problemType: context
                          .watch<TestDataEntityProvider>()
                          .testDataList[index]
                          .problemType,
                      writeMode: false,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.black,
            height: 3,
            indent: 10,
            endIndent: 10,
          ),
          SizedBox(
            height: 100,
            width: 1000,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 60,
                  child: Text('타입 선택', style: TextStyle(fontSize: 14)),
                ),
                SizedBox(
                  height: 50,
                  width: 300,
                  child: DropdownButton(
                    items: dropdownTitle.entries
                        .map((e) => DropdownMenuItem(
                              value: e.key,
                              child: Text(
                                e.value,
                                style: const TextStyle(fontSize: 14),
                              ),
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
                filledButton(
                  buttonName: '추가',
                  color: Colors.blue,
                  onPressed: () {
                    context
                        .read<TestDataEntityProvider>()
                        .addTestData(TestDataEntity(
                          chapterNumber: 1,
                          problemType: dropdownValue,
                        ));
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: ProblemTable(problemType: dropdownValue, writeMode: true),
          ),
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
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 120,
      width: 700,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 3),
              child: Row(
                children: [
                  SizedBox(
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
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                        child: Text(
                          '1급',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
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
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                        child: Text(
                          '1',
                          style: TextStyle(
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
            Padding(
              padding: EdgeInsets.only(bottom: 3),
              child: Row(
                children: [
                  SizedBox(
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
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                        child: Text(
                          '1',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
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
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                        child: Text(
                          '1',
                          style: TextStyle(
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
              SizedBox(
                width: 50,
                height: 30,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                  ),
                  child: Center(
                    child: Text(
                      '단어',
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
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    child: Text(
                      '1급',
                      style: TextStyle(
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
