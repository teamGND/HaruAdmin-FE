class TestDataEntity {
  String level;
  int cycle;
  // int sets;
  int chapter;
  String? title;
  List<String>? exampleList;
  List<ProblemDataModel>? problemList;

  TestDataEntity({
    required this.level,
    required this.cycle,
    // required this.sets,
    required this.chapter,
    required this.title,
    required this.exampleList,
    required this.problemList,
  });

  factory TestDataEntity.fromJson(Map<String, dynamic> json) {
    return TestDataEntity(
      level: json['level'],
      cycle: json['cycle'],
      // sets: json['sets'],
      chapter: json['chapter'],
      title: json['title'],
      exampleList: json['exampleList'] != null
          ? List<String>.from(json['exampleList'])
          : [],
      problemList: json['problemList'] != null
          ? List<ProblemDataModel>.from(
              json['problemList'].map((e) => ProblemDataModel.fromJson(e)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'cycle': cycle,
      // 'sets': sets,
      'chapter': chapter,
      'title': title,
      'exampleList': exampleList,
      'problemList': problemList!.map((e) => e.toJson()).toList(),
    };
  }

  TestDataEntity copyWith({
    String? level,
    int? cycle,
    // int? sets,
    int? chapter,
    String? title,
    List<String>? exampleList,
    List<ProblemDataModel>? problemList,
  }) {
    return TestDataEntity(
      level: level ?? this.level,
      cycle: cycle ?? this.cycle,
      // sets: sets ?? this.sets,
      chapter: chapter ?? this.chapter,
      title: title ?? this.title,
      exampleList: exampleList ?? this.exampleList,
      problemList: problemList ?? this.problemList,
    );
  }
}

class ProblemDataModel {
  int? id;
  String? level;
  int? cycle;
  // int sets;
  String? category;
  int? chapter;
  int sequence;
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

  ProblemDataModel({
    this.id,
    this.level,
    this.cycle,
    // required this.sets,
    this.category,
    this.chapter,
    required this.sequence,
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

  factory ProblemDataModel.fromJson(Map<String, dynamic> json) {
    return ProblemDataModel(
      id: json['id'],
      level: json['level'],
      cycle: json['cycle'],
      // sets: json['sets'],
      category: json['category'],
      chapter: json['chapter'],
      sequence: json['sequence'],
      problemType: json['problemType'],
      choice1: json['choice1'],
      choice2: json['choice2'],
      choice3: json['choice3'],
      choice4: json['choice4'],
      answerNumber: json['answerNumber'],
      picture: json['picture'],
      pictureDescription: json['pictureDescription'],
      questionString: json['questionString'],
      answerString: json['answerString'],
      exampleOriginal: json['exampleOriginal'],
      exampleChanged: json['exampleChanged'],
      directionKor: json['directionKor'],
      audio: json['audio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level,
      'cycle': cycle,
      // 'sets': sets,
      'category': category,
      'chapter': chapter,
      'sequence': sequence,
      'problemType': problemType,
      'choice1': choice1,
      'choice2': choice2,
      'choice3': choice3,
      'choice4': choice4,
      'answerNumber': answerNumber,
      'picture': picture,
      'pictureDescription': pictureDescription,
      'questionString': questionString,
      'answerString': answerString,
      'exampleOriginal': exampleOriginal,
      'exampleChanged': exampleChanged,
      'directionKor': directionKor,
      'audio': audio,
    };
  }
}
