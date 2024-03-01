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
