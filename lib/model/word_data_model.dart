class WordDataList {
  int chapter;
  String content;
  int cycle;
  int id;
  String level;
  String quizStatus;
  String state;
  String title;
  int wordCount;
  String wordTag;

  WordDataList({
    required this.chapter,
    required this.content,
    required this.cycle,
    required this.id,
    required this.level,
    required this.quizStatus,
    required this.state,
    required this.title,
    required this.wordCount,
    required this.wordTag,
  });

  factory WordDataList.fromJson(Map<String, dynamic> jsondata) {
    return WordDataList(
      chapter: jsondata['chapter'],
      content: jsondata['content'],
      cycle: jsondata['cycle'],
      id: jsondata['id'],
      level: jsondata['level'],
      quizStatus: jsondata['quizStatus'],
      state: jsondata['state'],
      title: jsondata['title'],
      wordCount: jsondata['wordCount'],
      wordTag: jsondata['wordTag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapter': chapter,
      'content': content,
      'cycle': cycle,
      'id': id,
      'level': level,
      'quizStatus': quizStatus,
      'state': state,
      'title': title,
      'wordCount': wordCount,
      'wordTag': wordTag,
    };
  }
}

class WordData {
  String level;
  int chapter;
  int cycle;
  String quizStatus;
  String state;
  String title;
  List<Word> word;
  String wordTag;

  WordData({
    required this.level,
    required this.chapter,
    required this.cycle,
    required this.quizStatus,
    required this.state,
    required this.title,
    required this.word,
    required this.wordTag,
  });

  factory WordData.fromJson(Map<String, dynamic> jsondata) {
    return WordData(
      level: jsondata['level'],
      chapter: jsondata['chapter'],
      cycle: jsondata['cycle'],
      quizStatus: jsondata['quizStatus'],
      state: jsondata['state'],
      title: jsondata['title'],
      word: jsondata['word'].map<Word>((word) => Word.fromJson(word)).toList(),
      wordTag: jsondata['wordTag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'chapter': chapter,
      'cycle': cycle,
      'quizStatus': quizStatus,
      'state': state,
      'title': title,
      'word': word.map((word) => word.toJson()).toList(),
      'wordTag': wordTag,
    };
  }
}

class Word {
  String chinese;
  String description;
  String english;
  String imageUrl;
  int order;
  String russian;
  String title;
  String vietnam;
  String voiceUrl;

  Word({
    required this.chinese,
    required this.description,
    required this.english,
    required this.imageUrl,
    required this.order,
    required this.russian,
    required this.title,
    required this.vietnam,
    required this.voiceUrl,
  });

  factory Word.fromJson(Map<String, dynamic> jsondata) {
    return Word(
      chinese: jsondata['chinese'],
      description: jsondata['description'],
      english: jsondata['english'],
      imageUrl: jsondata['imageUrl'],
      order: jsondata['order'],
      russian: jsondata['russian'],
      title: jsondata['title'],
      vietnam: jsondata['vietnam'],
      voiceUrl: jsondata['voiceUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chinese': chinese,
      'description': description,
      'english': english,
      'imageUrl': imageUrl,
      'order': order,
      'russian': russian,
      'title': title,
      'vietnam': vietnam,
      'voiceUrl': voiceUrl,
    };
  }
}
