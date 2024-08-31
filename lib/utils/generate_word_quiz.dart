import 'package:haru_admin/model/test_data_model.dart';

import 'convert_problem_list.dart';

List<ProblemDataModel> generateWordQuiz({
  required List<String> words,
  required List<int> wordsTypes,
  required ProblemDataModel frameModel,
}) {
  // 단어 개수만큼 문제 생성하기
  int quizLength = words.length;

  List<ProblemDataModel> result = [];
  for (int i = 0; i < quizLength; i++) {
    ProblemDataModel quiz = frameModel.copyWith(
      sequence: i + 1,
      problemType: wordsTypes[i],
    );

    if (wordsTypes[i] == 103 || wordsTypes[i] == 104) {
      ProblemDataModel? data =
          convertListToProblemContents(contents: [words[i]], frameModel: quiz);
      if (data == null) {
        continue;
      }
      result.add(data);
    } else if (wordsTypes[i] == 101 || wordsTypes[i] == 102) {
      String answer = words[i];
      List<String> options = [
        words[i],
        words[(i + 1) % quizLength],
        words[(i - 1) % quizLength],
      ];
      options.shuffle();
      int answerNumber = options.indexOf(answer);
      ProblemDataModel? data = convertListToProblemContents(
          contents: [...options, answerNumber.toString()], frameModel: quiz);
      if (data == null) {
        continue;
      }
      result.add(data);
    }
  }

  return result;
}
