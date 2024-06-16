import 'package:flutter_riverpod/flutter_riverpod.dart';

final problemContentsProvider =
    NotifierProvider<ProblemContentsNotifier, List<ProblemContents>>(
  () => ProblemContentsNotifier(),
);

class ProblemContents {
  int problemType;
  String? choice1;
  String? choice2;
  String? choice3;
  String? choice4;
  int? answerNumber;
  String? picture;
  String? pictureDescription;
  String? questionString;
  String? answerString;
  String? exampleOriginal;
  String? exampleChanged;
  String? directionKor;
  String? audio;

  ProblemContents({
    required this.problemType,
    this.choice1,
    this.choice2,
    this.choice3,
    this.choice4,
    this.answerNumber,
    this.picture,
    this.pictureDescription,
    this.questionString,
    this.answerString,
    this.exampleOriginal,
    this.exampleChanged,
    this.directionKor,
    this.audio,
  });
}

class ProblemContentsNotifier extends Notifier<List<ProblemContents>> {
  @override
  List<ProblemContents> build() {
    return [];
  }

  void setContentsList(List<ProblemContents> contents) {
    state = contents;
  }

  ProblemContents? setContents({
    required int problemType,
    required List<dynamic> contents,
  }) {
    switch (problemType) {
      case 101:
      case 102:
        {
          return ProblemContents(
            problemType: 101,
            choice1: contents[0],
            choice2: contents[1],
            choice3: contents[2],
            answerNumber: contents[3],
          );
        }
      case 103:
      case 104:
        {
          return ProblemContents(
            problemType: 103,
            answerString: contents[0],
          );
        }
      case 201:
        {
          return ProblemContents(
            problemType: 201,
            picture: contents[0],
            pictureDescription: contents[1],
            questionString: contents[2],
            answerString: contents[3],
          );
        }
      case 202:
        {
          return ProblemContents(
            problemType: 202,
            questionString: contents[0],
            answerString: contents[1],
          );
        }
      case 203:
      case 204:
        {
          return ProblemContents(
            problemType: 203,
            questionString: contents[0],
            choice1: contents[1],
            choice2: contents[2],
            choice3: contents[3],
            answerNumber: contents[4],
          );
        }
      case 205:
        {
          return ProblemContents(
            problemType: 205,
            exampleOriginal: contents[0],
            exampleChanged: contents[1],
            questionString: contents[2],
            answerString: contents[3],
          );
        }
      case 206:
        {
          return ProblemContents(
            problemType: 206,
            questionString: contents[0],
            answerString: contents[1],
          );
        }
      case 207:
        {
          return ProblemContents(
            problemType: 207,
            audio: contents[0],
            answerString: contents[1],
          );
        }
      case 208:
        {
          return ProblemContents(
            problemType: 208,
            questionString: contents[0],
            exampleChanged: contents[1],
            answerNumber: contents[2],
          );
        }
      default:
        {
          return null;
        }
    }
  }

  void removeContents(int index) {
    state.removeAt(index);
  }

  void fixContent(int index, List<dynamic> contents) {
    ProblemContents? data = setContents(
      problemType: state[index].problemType,
      contents: contents,
    );
    if (data != null) {
      state[index] = data;
    }
  }

  void addContents(int problemType, List<dynamic> contents) {
    ProblemContents? data = setContents(
      problemType: problemType,
      contents: contents,
    );
    if (data != null) {
      state.add(data);
    }
  }

  List<List<dynamic>> getContentsList() {
    List<List<dynamic>> result = [];
    for (int i = 0; i < state.length; i++) {
      result.add(getContents(i));
    }
    return result;
  }

  List<dynamic> getContents(int index) {
    switch (state[index].problemType) {
      case 101:
      case 102:
        {
          return [
            state[index].choice1,
            state[index].choice2,
            state[index].choice3,
            state[index].answerNumber,
          ];
        }
      case 103:
      case 104:
        {
          return [state[index].answerString];
        }
      case 201:
        {
          return [
            state[index].picture,
            state[index].pictureDescription,
            state[index].questionString,
            state[index].answerString,
          ];
        }
      case 202:
        {
          return [
            state[index].questionString,
            state[index].answerString,
          ];
        }
      case 203:
      case 204:
        {
          return [
            state[index].questionString,
            state[index].choice1,
            state[index].choice2,
            state[index].choice3,
            state[index].answerNumber,
          ];
        }
      case 205:
        {
          return [
            state[index].exampleOriginal,
            state[index].exampleChanged,
            state[index].questionString,
            state[index].answerString,
          ];
        }
      case 206:
        {
          return [
            state[index].questionString,
            state[index].answerString,
          ];
        }
      case 207:
        {
          return [
            state[index].audio,
            state[index].questionString,
          ];
        }
      case 208:
        {
          return [
            state[index].questionString,
            state[index].exampleChanged,
            state[index].answerNumber
          ];
        }
      default:
        {
          return [];
        }
    }
  }
}
