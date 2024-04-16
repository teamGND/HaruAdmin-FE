import 'package:flutter/material.dart';

class TestDataEntityProvider extends ChangeNotifier {
  List<TestDataEntity> testDataList = [
    TestDataEntity(
      chapterNumber: 1,
      problemType: 101,
      choice1: '토끼',
      choice2: '사자',
      choice3: '호랑이',
      answerNumber: 0,
    ),
    TestDataEntity(
      chapterNumber: 1,
      problemType: 102,
      choice1: '강아지',
      choice2: '고양이',
      choice3: '호랑이',
      answerNumber: 2,
    ),
    TestDataEntity(
      chapterNumber: 1,
      problemType: 103,
      answerString: '고양이',
    ),
  ];
}

class TestDataEntity {
  final int chapterNumber;
  final int problemType;
  final String? picture;
  final String? pictureDescription;
  final String? audio;
  final String? directionKor;
  final String? questionString;
  final String? exampleOriginal;
  final String? exampleChanged;
  final String? answerString;
  final int? answerNumber;
  final String? choice1;
  final String? choice2;
  final String? choice3;
  final String? choice4;
  final String? problemDescription;

  TestDataEntity({
    required this.chapterNumber,
    required this.problemType,
    this.picture,
    this.pictureDescription,
    this.audio,
    this.directionKor,
    this.questionString,
    this.exampleOriginal,
    this.exampleChanged,
    this.answerString,
    this.answerNumber,
    this.choice1,
    this.choice2,
    this.choice3,
    this.choice4,
    this.problemDescription,
  });

  factory TestDataEntity.fromJson(Map<String, Object?> json) => TestDataEntity(
        chapterNumber: json['chapterNumber'] as int,
        problemType: json['problemType'] as int,
        picture: json['picture'] as String,
        pictureDescription: json['pictureDescription'] as String,
        audio: json['audio'] as String,
        directionKor: json['directionKor'] as String,
        questionString: json['questionString'] as String,
        exampleOriginal: json['exampleOriginal'] as String,
        exampleChanged: json['exampleChanged'] as String,
        answerString: json['answerString'] as String,
        answerNumber: json['answerNumber'] as int,
        choice1: json['choice1'] as String,
        choice2: json['choice2'] as String,
        choice3: json['choice3'] as String,
        choice4: json['choice4'] as String,
        problemDescription: json['problemDescription'] as String,
      );
}
