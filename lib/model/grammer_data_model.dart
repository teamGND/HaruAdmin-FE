import 'package:haru_admin/model/intro_data_model.dart';

class GrammarDataList {
  final List<GrammarDataListComponent> content;
  final bool empty;
  final bool first;
  final bool last;
  final int number;
  final int numberOfElements;
  final PageableData pageable;
  final int size;
  final SortData sort;
  final int totalElements;
  final int totalPages;

  GrammarDataList({
    required this.content,
    required this.empty,
    required this.first,
    required this.last,
    required this.number,
    required this.numberOfElements,
    required this.pageable,
    required this.size,
    required this.sort,
    required this.totalElements,
    required this.totalPages,
  });

  factory GrammarDataList.fromJson(Map<String, dynamic> json) {
    var contentJson = json['content'] as List;
    List<GrammarDataListComponent> contentList =
        contentJson.map((i) => GrammarDataListComponent.fromJson(i)).toList();

    return GrammarDataList(
      content: contentList,
      empty: json['empty'],
      first: json['first'],
      last: json['last'],
      number: json['number'],
      numberOfElements: json['numberOfElements'],
      pageable: PageableData.fromJson(json['pageable']),
      size: json['size'],
      sort: SortData.fromJson(json['sort']),
      totalElements: json['totalElements'],
      totalPages: json['totalPages'],
    );
  }
}

class GrammarDataListComponent {
  int id;
  int chapter;
  String level;
  String? title;
  String? representSentences;
  int exampleSentenceNumber;
  String? status;
  String? quizStatue;

  GrammarDataListComponent({
    required this.id,
    required this.chapter,
    required this.level,
    required this.title,
    required this.representSentences,
    required this.exampleSentenceNumber,
    required this.status,
    required this.quizStatue,
  });

  factory GrammarDataListComponent.fromJson(Map<String, dynamic> json) {
    return GrammarDataListComponent(
      id: json['id'],
      chapter: json['chapter'],
      level: json['level'],
      title: json['title'],
      representSentences: json['representSentences'],
      exampleSentenceNumber: json['exampleSentenceNumber'],
      status: json['status'],
      quizStatue: json['quizStatue'],
    );
  }
}

class AddGrammerData {
  String level;
  int cycle;
  int chapter;
  String title;
  String imageUrl;
  String description;
  String descriptionEng;
  String descriptionChn;
  String descriptionVie;
  String descriptionRus;
  List<Sentence> sentence;

  AddGrammerData({
    required this.level,
    required this.cycle,
    required this.chapter,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.descriptionEng,
    required this.descriptionChn,
    required this.descriptionVie,
    required this.descriptionRus,
    required this.sentence,
  });

  factory AddGrammerData.fromJson(Map<String, dynamic> jsondata) {
    return AddGrammerData(
      level: jsondata['level'],
      cycle: jsondata['cycle'],
      chapter: jsondata['chapter'],
      title: jsondata['title'],
      imageUrl: jsondata['imageUrl'],
      description: jsondata['description'],
      descriptionEng: jsondata['descriptionEng'],
      descriptionChn: jsondata['descriptionChn'],
      descriptionVie: jsondata['descriptionVie'],
      descriptionRus: jsondata['descriptionRus'],
      sentence: jsondata['sentence']
          .map<Sentence>((sentence) => Sentence.fromJson(sentence))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'cycle': cycle,
      'chapter': chapter,
      'title': title,
      'imageUrl': imageUrl,
      'description': description,
      'descriptionEng': descriptionEng,
      'descriptionChn': descriptionChn,
      'descriptionVie': descriptionVie,
      'descriptionRus': descriptionRus,
      'sentence': sentence.map((sentence) => sentence.toJson()).toList(),
    };
  }
}

class Sentence {
  String sentenceType;
  int order;
  String characterType;
  String expression;
  String expressionEng;
  String expressionChn;
  String expressionVie;
  String expressionRus;
  String voiceUrl;

  Sentence({
    required this.sentenceType,
    required this.order,
    required this.characterType,
    required this.expression,
    required this.expressionEng,
    required this.expressionChn,
    required this.expressionVie,
    required this.expressionRus,
    required this.voiceUrl,
  });

  factory Sentence.fromJson(Map<String, dynamic> jsondata) {
    return Sentence(
      sentenceType: jsondata['sentenceType'],
      order: jsondata['order'],
      characterType: jsondata['characterType'],
      expression: jsondata['expression'],
      expressionEng: jsondata['expressionEng'],
      expressionChn: jsondata['expressionChn'],
      expressionVie: jsondata['expressionVie'],
      expressionRus: jsondata['expressionRus'],
      voiceUrl: jsondata['voiceUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sentenceType': sentenceType,
      'order': order,
      'characterType': characterType,
      'expression': expression,
      'expressionEng': expressionEng,
      'expressionChn': expressionChn,
      'expressionVie': expressionVie,
      'expressionRus': expressionRus,
      'voiceUrl': voiceUrl,
    };
  }
}
