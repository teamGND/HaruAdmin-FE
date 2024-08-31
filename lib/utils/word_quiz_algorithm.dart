import 'dart:math';

import '../model/test_data_model.dart';

///
///   단어 퀴즈 타입
/// type1 - 그림보고 어휘 (3)  ['', '', '']
/// type2 - 어휘보고 그림 (3) ['', '', '']
/// type3 - 그림주고 타이핑 (1)
/// type4 - 받아쓰기 (1)

/// 3지 선다

/// type| 101, 102, 103, 104
/// ---------
/// 6   | 3, 2, 1
/// 7   | 3, 2, 2
/// 8   | 3, 3, 2
/// 9   | 3, 3, 3
/// 10  | 4, 3, 3
///
/// 이 알고리즘의 기능은 다음과 같습니다.
/// 1. 단어 리스트를 받습니다. (wordList)
/// 이 때, 특정 단어를 type3나 type4로 지정하고 싶다면 desinatedType3List, desinatedType4List에 해당 단어 인덱스를 넣어주세요.
/// 특정 단어를 지정하지 않는다면 null을 넣어주세요.
///
///

List<ProblemDataModel> makeWordQuiz({
  required List<String> wordList,
}) {
  // Map<총 문항 개수, 타입별 문항 개수>
  Map<int, List<int>> quizTypeCnts = {
    0: [0, 0, 0, 0],
    5: [2, 2, 1, 0],
    6: [3, 2, 1, 0],
    7: [3, 2, 1, 1],
    8: [3, 3, 2],
    9: [3, 3, 3],
    10: [4, 3, 3],
    11: [4, 4, 3],
  };

  int quizLength = wordList.length;
  List<int> quizTypeCnt = quizTypeCnts[quizLength]!;
  // 단어 리스트 번호 랜덤돌리기
  List<int> quizNumber = generateShuffledList(quizLength);

  List<ProblemDataModel> result = [];
  // for (int i = 0; i < quizLength; i++) {
  //   for (int t = 0; t < quizTypeCnt.length; t++) {
  //     /* 타입 1부터 문제 하나씩 만들기 */
  //     if (quizTypeCnt[t] == 0) continue;

  //     int answerN = quizNumber[i];

  //     WordQuiz quiz = WordQuiz(
  //       quizType: t,
  //       answerWord: wordList[answerN],
  //     );

  //     if (t == 0 || t == 1) {
  //       int optionN1 = (quizNumber[i] - 1) % quizLength;
  //       int optionN2 = (quizNumber[i] + 1) % quizLength;

  //       quiz = quiz.copyWith(
  //         optionWord1: wordList[optionN1],
  //         optionWord2: wordList[optionN2],
  //       );
  //     }
  //     result.add(quiz);
  //     quizTypeCnt[t]--;
  //     break;
  //   }
  // }

  return result;
}

List<int> generateShuffledList(int length) {
  List<int> shuffledList = List<int>.generate(
      length, (index) => index); // Generate a list from 0 to length - 1

  Random random = Random();

  // Fisher-Yates shuffle algorithm
  for (int i = shuffledList.length - 1; i > 0; i--) {
    int j = random.nextInt(i + 1);
    int temp = shuffledList[i];
    shuffledList[i] = shuffledList[j];
    shuffledList[j] = temp;
  }

  return shuffledList;
}
