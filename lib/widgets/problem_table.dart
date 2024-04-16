import 'package:flutter/material.dart';

class ProblemTable extends StatelessWidget {
  const ProblemTable({
    Key? key,
    required this.problemType,
    required this.writeMode,
  }) : super(key: key);

  final int problemType;
  final bool writeMode;

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

  static const Map<int, List<String>> tableContents = {
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

  @override
  Widget build(BuildContext context) {
    return Container(
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
              children: tableTitle[problemType]!
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
                                fontSize: 12, fontWeight: FontWeight.bold),
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
              children: tableContents[problemType]!
                  .map(
                    (e) => Flexible(
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
                          child: Text(
                            e,
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
