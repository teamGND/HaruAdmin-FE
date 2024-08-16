import 'package:haru_admin/model/intro_data_model.dart';

class GrammarDataList {
  final List<GrammarDataListComponent>? content;
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
  int cycle;
  int sets;
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
    required this.cycle,
    required this.sets,
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
      cycle: json['cycle'],
      sets: json['sets'],
      title: json['title'],
      representSentences: json['representSentences'],
      exampleSentenceNumber: json['exampleSentenceNumber'],
      status: json['status'],
      quizStatue: json['quizStatue'],
    );
  }
}

class AddGrammarData {
  String? level;
  int? cycle;
  int? sets;
  int? chapter;
  String? title;
  String? imageUrl;
  String? description;
  String? descriptionEng;
  String? descriptionChn;
  String? descriptionVie;
  String? descriptionRus;
  List<Sentence>? sentenceList;

  AddGrammarData({
    this.level,
    this.cycle,
    this.sets,
    this.chapter,
    this.title,
    this.imageUrl,
    this.description,
    this.descriptionEng,
    this.descriptionChn,
    this.descriptionVie,
    this.descriptionRus,
    this.sentenceList,
  });

  factory AddGrammarData.fromJson(Map<String, dynamic> jsondata) {
    return AddGrammarData(
      level: jsondata['level'],
      cycle: jsondata['cycle'],
      sets: jsondata['sets'],
      chapter: jsondata['chapter'],
      title: jsondata['title'],
      imageUrl: jsondata['imageUrl'],
      description: jsondata['description'],
      descriptionEng: jsondata['descriptionEng'],
      descriptionChn: jsondata['descriptionChn'],
      descriptionVie: jsondata['descriptionVie'],
      descriptionRus: jsondata['descriptionRus'],
      sentenceList: jsondata['sentenceList']
          .map<Sentence>((sentence) => Sentence.fromJson(sentence))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'cycle': cycle,
      'sets': sets,
      'chapter': chapter,
      'title': title,
      'imageUrl': imageUrl,
      'description': description,
      'descriptionEng': descriptionEng,
      'descriptionChn': descriptionChn,
      'descriptionVie': descriptionVie,
      'descriptionRus': descriptionRus,
      'sentence': sentenceList?.map((sentence) => sentence.toJson()).toList(),
    };
  }
}

class Sentence {
  int? id;
  int order;
  String? sentenceType;
  String? characterType;
  String? expression;
  String? expressionEng;
  String? expressionChn;
  String? expressionVie;
  String? expressionRus;
  String? voiceUrl;

  Sentence({
    required this.id,
    required this.order,
    required this.sentenceType,
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
      id: jsondata['id'],
      order: jsondata['order'],
      sentenceType: jsondata['sentenceType'],
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
      'id': id,
      'order': order,
      'sentenceType': sentenceType,
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

class GrammarChapterDataList {
  String level;
  int cycle;
  int sets;
  int chapter;
  String? title;
  String? sentence;
  String? imageUrl;
  String? description;
  String? descriptionEng;
  String? descriptionChn;
  String? descriptionVie;
  String? descriptionRus;
  List<MetaGrammar>? metaGrammars;
  List<ExampleSentence>? representSentences;
  List<ExampleSentence>? exampleSentences;

  GrammarChapterDataList({
    required this.level,
    required this.cycle,
    required this.sets,
    required this.chapter,
    this.title,
    this.sentence,
    this.imageUrl,
    this.description,
    this.descriptionEng,
    this.descriptionChn,
    this.descriptionVie,
    this.descriptionRus,
    this.metaGrammars,
    this.representSentences,
    this.exampleSentences,
  });

  factory GrammarChapterDataList.fromJson(Map<String, dynamic> json) {
    var representSentencesFromJson = json['representSentences'] as List;
    List<ExampleSentence> representSentencesList = representSentencesFromJson
        .map((i) => ExampleSentence.fromJson(i))
        .toList();

    var exampleSentencesFromJson = json['exampleSentences'] as List;
    List<ExampleSentence> exampleSentencesList = exampleSentencesFromJson
        .map((i) => ExampleSentence.fromJson(i))
        .toList();

    var metaGrammarsFromJson = json['metaGrammars'] as List;
    List<MetaGrammar> metaGrammarsList =
        metaGrammarsFromJson.map((i) => MetaGrammar.fromJson(i)).toList();

    return GrammarChapterDataList(
      level: json['level'],
      cycle: json['cycle'],
      sets: json['sets'],
      chapter: json['chapter'],
      title: json['title'],
      sentence: json['sentence'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      descriptionEng: json['descriptionEng'],
      descriptionChn: json['descriptionChn'],
      descriptionVie: json['descriptionVie'],
      descriptionRus: json['descriptionRus'],
      metaGrammars: metaGrammarsList,
      representSentences: representSentencesList,
      exampleSentences: exampleSentencesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'cycle': cycle,
      'sets': sets,
      'chapter': chapter,
      'title': title,
      'sentence': sentence,
      'imageUrl': imageUrl,
      'description': description,
      'descriptionEng': descriptionEng,
      'descriptionChn': descriptionChn,
      'descriptionVie': descriptionVie,
      'descriptionRus': descriptionRus,
      'metaGrammars': metaGrammars?.map((e) => e.toJson()).toList(),
      'representSentences': representSentences?.map((e) => e.toJson()).toList(),
      'exampleSentences': exampleSentences?.map((e) => e.toJson()).toList(),
    };
  }
}

class MetaGrammar {
  int id;
  String title;

  MetaGrammar({
    required this.id,
    required this.title,
  });

  factory MetaGrammar.fromJson(Map<String, dynamic> json) {
    return MetaGrammar(
      id: json['id'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}

class ExampleSentence {
  int? id;
  int? order;
  String? characterType;
  String? expression;
  String? expressionEng;
  String? expressionChn;
  String? expressionVie;
  String? expressionRus;
  String? voiceUrl;

  ExampleSentence({
    this.id,
    this.order,
    this.characterType,
    this.expression,
    this.expressionEng,
    this.expressionChn,
    this.expressionVie,
    this.expressionRus,
    this.voiceUrl,
  });

  factory ExampleSentence.fromJson(Map<String, dynamic> json) {
    return ExampleSentence(
      order: json['order'],
      characterType: json['characterType'],
      expression: json['expression'],
      expressionEng: json['expressionEng'],
      expressionChn: json['expressionChn'],
      expressionVie: json['expressionVie'],
      expressionRus: json['expressionRus'],
      voiceUrl: json['voiceUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
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

  ExampleSentence.copyWith({
    this.order,
    this.characterType,
    this.expression,
    this.expressionEng,
    this.expressionChn,
    this.expressionVie,
    this.expressionRus,
    this.voiceUrl,
  });
}
