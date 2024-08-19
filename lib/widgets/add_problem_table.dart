import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haru_admin/provider/intro_provider.dart';

import '../utils/enum_type.dart';
import 'buttons.dart';
import 'problem_provider.dart';

class AddProblemTable extends ConsumerStatefulWidget {
  const AddProblemTable({super.key});

  @override
  ConsumerState<AddProblemTable> createState() => _AddProblemTableState();
}

class _AddProblemTableState extends ConsumerState<AddProblemTable> {
  /*
  * 문제 타입
  * (1) 단어 퀴즈 - 101 ~ 104
  * (2) 문법 퀴즈 - 201 ~ 208
  * (3) 테스트 - 101 ~ 208
  * (4) 중간평가 - 101 ~ 208
  */
  static const Map<int, List<String>> tableTitle = {
    101: ['선지 0', '선지 1', '선지 2', '정답 - 0,1,2 중 하나'],
    102: ['선지 0', '선지 1', '선지 2', '정답 - 0,1,2 중 하나 '],
    103: ['단어'],
    104: ['단어'],
    201: ['그림', ' 그림 설명', '문장 - 빈칸에 ()넣기', '정답 - 여러 개면 /로 구분'],
    202: ['문장 - /로 구분', '정답 순서 - ,로 구분 0부터 카운트'],
    203: ['문장 - 빈칸에 ()넣기', '선지1', '선지2', '선지3 - 없으면 비우기', '정답 - 0,1,2 중 하나'],
    204: ['문장 - 빈칸에 ()넣기', '선지1', '선지2', '선지3', '정답 - 틀린 문장. 0,1,2 중 하나'],
    205: ['예시 문장(원래)', '예시 문장(바꾼)', '문제 문장(원래)', '정답 문장 - 여러 개면 /로 구분'],
    206: ['문장 - 띄어쓰기 기준. 틀린 부분 ()로 표시', '올바른 문장 - 여러 개면 /로 구분'],
    207: ['문장', '음성파일 (파일 추가)'],
    208: ['제시 문장', '옳은 문장', '정답 여부(대문자 O,X 중 하나)'],
  };
  Map<CATEGORY, Map<int, String>> dropdownTitle = {
    CATEGORY.WORD: {
      101: '101. 그림보고 어휘 3지선다',
      102: '102. 어휘보고 그림 3지선다',
      103: '103. 그림보고 타이핑',
      104: '104. 받아쓰기',
    },
    CATEGORY.GRAMMAR: {
      201: '201. 그림보고 어휘 3지선다',
      202: '202. 어휘보고 그림 3지선다',
      203: '203. 그림보고 타이핑',
      204: '204. 받아쓰기',
      205: '205. 어휘보고 그림 3지선다',
      206: '206. 그림보고 타이핑',
      207: '207. 그림보고 타이핑',
      208: '208. OX 퀴즈',
    },
  };
  List<TextEditingController> controllers = [];
  int? dropdownValue;

  addNewProblem() {
    if (dropdownValue != null) {
      ref
          .read(problemContentsProvider.notifier)
          .addContents(dropdownValue!, []);
    }
  }

  @override
  Widget build(BuildContext context) {
    CATEGORY? category = ref.read(introProvider).category;

    return Column(
      children: [
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
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(
                height: 50,
                width: 200,
                child: DropdownButton(
                  value: dropdownValue,
                  items: dropdownTitle[category]!
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
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: (dropdownValue != null)
              ? Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                      vertical: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                  ),
                  height: 80,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: tableTitle[dropdownValue]!
                              .map(
                                (e) => Flexible(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border: const Border.symmetric(
                                          vertical: BorderSide(
                                        color: Colors.grey,
                                        width: 0.5,
                                      )),
                                    ),
                                    child: Center(
                                      child: Text(
                                        e,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      SizedBox(
                        height: 48,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: List.generate(
                                tableTitle[dropdownValue]!.length, (index) {
                              return Flexible(
                                child: DecoratedBox(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    border: Border.symmetric(
                                        vertical: BorderSide(
                                      color: Colors.grey,
                                      width: 0.5,
                                    )),
                                  ),
                                  child: Center(
                                    child: TextField(
                                        style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                        ),
                                        controller: TextEditingController(
                                          text: ' ',
                                        )),
                                  ),
                                ),
                              );
                            })),
                      ),
                    ],
                  ),
                )
              : const SizedBox(height: 10),
        ),
      ],
    );
  }
}
