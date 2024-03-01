class IntroData {
  int id;
  String level;
  String category;
  int chapter;
  int sequence;
  String titleKor;
  String titleEng;
  String titleVie;
  String titleChn;
  String titleRus;
  String contentKor;
  String contentEng;
  String contentVie;
  String contentChn;
  String contentRus;
  int userId;
  String status;

  IntroData({
    required this.id,
    required this.level,
    required this.category,
    required this.chapter,
    required this.sequence,
    required this.titleKor,
    required this.titleEng,
    required this.titleVie,
    required this.titleChn,
    required this.titleRus,
    required this.contentKor,
    required this.contentEng,
    required this.contentVie,
    required this.contentChn,
    required this.contentRus,
    required this.userId,
    required this.status,
  });

  factory IntroData.fromJson(Map<String, dynamic> jsondata) {
    return IntroData(
        id: jsondata['id'],
        level: jsondata['level'],
        category: jsondata['category'],
        chapter: jsondata['chapter'],
        sequence: jsondata['sequence'],
        titleKor: jsondata['titleKor'],
        titleEng: jsondata['titleEng'],
        titleVie: jsondata['titleVie'],
        titleChn: jsondata['titleChn'],
        titleRus: jsondata['titleRus'],
        contentKor: jsondata['contentKor'],
        contentEng: jsondata['contentEng'],
        contentVie: jsondata['contentVie'],
        contentChn: jsondata['contentChn'],
        contentRus: jsondata['contentRus'],
        userId: jsondata['userId'],
        status: jsondata['status']);
  }
}

class AddIntroData {
  String level;
  int category;
  int chapter;
  int cycle;
  String state;
  String titleKor;
  String contentKor;
  String titleEng;
  String contentEng;
  String titleVie;
  String contentVie;
  String titleChn;
  String contentChn;
  String titleRus;
  String contentRus;

  AddIntroData({
    required this.level,
    required this.category,
    required this.chapter,
    required this.cycle,
    required this.state,
    required this.titleKor,
    required this.contentKor,
    required this.titleEng,
    required this.contentEng,
    required this.titleVie,
    required this.contentVie,
    required this.titleChn,
    required this.contentChn,
    required this.titleRus,
    required this.contentRus,
  });

  Map<String, dynamic> toJson() {
    return {
      "level": level,
      "category": category,
      "chapter": chapter,
      "cycle": cycle,
      "state": state,
      "titleKor": titleKor,
      "contentKor": contentKor,
      "titleEng": titleEng,
      "contentEng": contentEng,
      "titleVie": titleVie,
      "contentVie": contentVie,
      "titleChn": titleChn,
      "contentChn": contentChn,
      "titleRus": titleRus,
      "contentRus": contentRus,
    };
  }
}
