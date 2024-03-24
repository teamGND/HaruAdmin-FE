import 'package:flutter/material.dart';

class WordQuizTable extends StatelessWidget {
  static Map<int, List<String>> titles = {
    // quizType : title
    1: ['정답 단어', '단어 선지1', '단어 선지 2'],
    2: ['정답 단어', '단어 선지1', '단어 선지 2'],
    3: ['정답 단어'],
    4: ['정답 단어'],
  };

  const WordQuizTable({
    super.key,
    required this.quizType, // int
  });

  final int quizType; // 컬럼 개수

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        children: [
          Text(
            // 타입 설명
            '단어 type-$quizType',
            style: const TextStyle(
              fontSize: 6,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            height: 50,
            child: Row(
              children: titles[quizType]!.map((title) {
                return Container(
                  width: (300 / titles[quizType]!.length),
                  decoration: BoxDecoration(
                    color: Colors.grey[350],
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(
            height: 50,
            child: Row(
              children: titles[quizType]!.map((title) {
                return Container(
                  width: (300 / titles[quizType]!.length),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: Center(
                    child: TextField(),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
