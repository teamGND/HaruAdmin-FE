import 'package:flutter/material.dart';
import 'package:haru_admin/api/test_data_services.dart';
import 'package:haru_admin/utils/future_layout.dart';
import 'package:haru_admin/utils/tap.dart';
import 'package:haru_admin/widgets/button.dart';

class AddTest extends StatefulWidget {
  const AddTest({super.key});

  @override
  State<AddTest> createState() => _AddTestState();
}

class _AddTestState extends State<AddTest> {
  final TestDataRepository testRepository = TestDataRepository();

  final List<int> columnWidth = [50, 50, 50, 300];
  final tabletitle = [
    '선택 삭제',
    '번호',
    '타입',
    '문제',
  ];

  List<bool> isSelected = List.generate(10, (index) => false);

  Future<dynamic> fetchIntroDataList =
      Future.delayed(const Duration(milliseconds: 500), () {
    return TestDataRepository().getTestDataList();
  });

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        const Row(
          children: [
            Flexible(
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
            Flexible(
              flex: 2,
              child: Center(
                child: Text(
                  '퀴즈/테스트 데이터',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Flexible(
                child: filledButton(buttonName: 'Save', color: Colors.blue)),
            Flexible(
                child: filledButton(
                    buttonName: 'Confirm', color: Color(0xFFFF7D53))),
          ],
        ),
        const SizedBox(height: 20),
        DefaultFutureBuilder(
          future: fetchIntroDataList,
          height: 500,
          titleRow: Row(
            children: List.generate(
              tabletitle.length,
              (index) => buildTableColumn(
                  Text(
                    tabletitle[index],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  columnWidth,
                  index),
            ),
          ),
          childRow: (dynamic introData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: introData.content.length,
              itemBuilder: (context, index) {
                return Row(
                  children: List.generate(
                    tabletitle.length,
                    (index) => buildTableColumn(
                        [
                          Checkbox(
                              value: isSelected[index],
                              onChanged: (value) {
                                setState(() {
                                  isSelected[index] = value!;
                                });
                              }),
                          Text(introData.content[index].id.toString()),
                          Text(introData.content[index].category.toString()),
                          Text(introData.content[index].chapter.toString()),
                          Text(introData.content[index].chapter.toString()),
                          Text(introData.content[index].titleKor),
                          Text(introData.content[index].state),
                          TextButton(
                            onPressed: () {},
                            child: const Text('수정'),
                          ),
                          TextButton(
                            onPressed: () {
                              // context.go(
                              //     '/add-quiz/${introData.content[index].id}');
                            },
                            child: const Text('퀴즈'),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text('테스트'),
                          ),
                        ][index],
                        columnWidth,
                        index),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
