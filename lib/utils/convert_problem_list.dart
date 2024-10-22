import '../model/test_data_model.dart';

int? stringNumberToInteger(String? number, bool hasChoice4,
    {bool isOX = false}) {
  switch (number) {
    case '0':
      return 0;
    case '1':
      return 1;

    case '2':
      if (isOX) return null;
      return 2;
    case '3':
      if (isOX) return null;
      if (hasChoice4) return 3;
      return null;
    case 'O':
      return 1;
    case 'X':
      return 0;
    default:
      return null;
  }
}

ProblemDataModel? convertListToProblemContents({
  required List<String?> contents,
  required ProblemDataModel frameModel,
}) {
  switch (frameModel.problemType) {
    case 101:
    case 102:
      {
        return frameModel.copyWith(
          problemType: frameModel.problemType,
          choice1: contents[0],
          choice2: contents[1],
          choice3: contents[2],
          answerNumber: stringNumberToInteger(contents[3], false),
        );
      }
    case 103:
    case 104:
      {
        return frameModel.copyWith(
          problemType: frameModel.problemType,
          answerString: contents[0],
        );
      }
    case 201:
      {
        return frameModel.copyWith(
          problemType: frameModel.problemType,
          picture: contents[0],
          pictureDescription: contents[1],
          questionString: contents[2],
          answerString: contents[3],
        );
      }
    case 202:
      {
        return frameModel.copyWith(
          problemType: frameModel.problemType,
          questionString: contents[0],
          answerString: contents[1],
        );
      }
    case 203:
    case 204:
      {
        return frameModel.copyWith(
          problemType: frameModel.problemType,
          questionString: contents[0],
          choice1: contents[1],
          choice2: contents[2],
          choice3: contents[3],
          answerNumber: stringNumberToInteger(contents[4], contents[3] != ''),
        );
      }
    case 205:
      {
        return frameModel.copyWith(
          problemType: frameModel.problemType,
          exampleOriginal: contents[0],
          exampleChanged: contents[1],
          questionString: contents[2],
          answerString: contents[3],
        );
      }
    case 206:
      {
        return frameModel.copyWith(
          problemType: frameModel.problemType,
          questionString: contents[0],
          answerString: contents[1],
        );
      }
    case 207:
      {
        return frameModel.copyWith(
          problemType: frameModel.problemType,
          answerString: contents[0],
          audio: contents[1],
        );
      }
    case 208:
      {
        return frameModel.copyWith(
          problemType: frameModel.problemType,
          questionString: contents[0],
          answerString: contents[1],
          answerNumber: stringNumberToInteger(contents[2], false, isOX: true),
        );
      }
    default:
      {
        return null;
      }
  }
}

List<String?> convertProblemContentsToList(ProblemDataModel state) {
  switch (state.problemType) {
    case 101:
    case 102:
      {
        return [
          state.choice1,
          state.choice2,
          state.choice3,
          state.answerNumber == null ? '' : state.answerNumber.toString(),
        ];
      }
    case 103:
    case 104:
      {
        return [state.answerString];
      }
    case 201:
      {
        return [
          state.picture,
          state.pictureDescription,
          state.questionString,
          state.answerString,
        ];
      }
    case 202:
      {
        return [
          state.questionString,
          state.answerString,
        ];
      }
    case 203:
    case 204:
      {
        return [
          state.questionString,
          state.choice1,
          state.choice2,
          state.choice3,
          state.answerNumber == null ? '' : state.answerNumber.toString(),
        ];
      }
    case 205:
      {
        return [
          state.exampleOriginal,
          state.exampleChanged,
          state.questionString,
          state.answerString,
        ];
      }
    case 206:
      {
        return [
          state.questionString,
          state.answerString,
        ];
      }
    case 207:
      {
        return [
          state.answerString,
          state.audio,
        ];
      }
    case 208:
      {
        return [
          state.questionString,
          state.answerString,
          state.answerNumber == 0 ? 'X' : 'O',
        ];
      }
    default:
      {
        return [];
      }
  }
}
