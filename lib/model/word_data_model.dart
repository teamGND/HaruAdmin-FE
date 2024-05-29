import 'package:haru_admin/model/intro_data_model.dart';

class WordDataList {
  final List<WordDataListComponent> content;
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

  WordDataList({
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

  factory WordDataList.fromJson(Map<String, dynamic> json) {
    var contentJson = json['content'] as List;
    List<WordDataListComponent> contentList =
        contentJson.map((i) => WordDataListComponent.fromJson(i)).toList();

    return WordDataList(
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

class WordDataListComponent {
  final int id;
  final int chapter;
  final String content;
  final int cycle;
//  final int sets;
  final String level;
  final String quizStatus;
  final String state;
  final String title;
  final int wordCount;
  final String wordTag;

  WordDataListComponent({
    required this.chapter,
    required this.content,
    required this.cycle,
    // required this.sets,
    required this.id,
    required this.level,
    required this.quizStatus,
    required this.state,
    required this.title,
    required this.wordCount,
    required this.wordTag,
  });

  factory WordDataListComponent.fromJson(Map<String, dynamic> jsondata) {
    return WordDataListComponent(
      chapter: jsondata['chapter'],
      content: jsondata['content'],
      cycle: jsondata['cycle'],
      // sets: jsondata['sets'],
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
      // 'sets': sets,
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

class WordChapterDataList {
  final int id;
  final String level;
  final int cycle;
//  final int sets;
  final int chapter;
  final String title;
  final List<WordChapterData> wordDataList;
  final String wordTag;

  WordChapterDataList({
    required this.id,
    required this.level,
    required this.cycle,
    // required this.sets,
    required this.chapter,
    required this.title,
    required this.wordDataList,
    required this.wordTag,
  });

  factory WordChapterDataList.fromJson(Map<String, dynamic> jsondata) {
    var wordDataListJson = jsondata['wordDataList'] as List;
    List<WordChapterData> wordDataList =
        wordDataListJson.map((i) => WordChapterData.fromJson(i)).toList();

    return WordChapterDataList(
      id: jsondata['id'],
      level: jsondata['level'],
      title: jsondata['title'],
      cycle: jsondata['cycle'],
      // sets: jsondata['sets'],
      chapter: jsondata['chapter'],
      wordDataList: wordDataList,
      wordTag: jsondata['wordTag'],
    );
  }
}

class WordChapterData {
  final int id;
  final int order;
  final String title;
  final String? imgUrl;
  final String? voiceUrl;
  final String? english;
  final String? chinese;
  final String? vietnam;
  final String? russian;
  final String? description;

  WordChapterData({
    required this.id,
    required this.order,
    required this.title,
    this.imgUrl,
    this.voiceUrl,
    this.english,
    this.chinese,
    this.vietnam,
    this.russian,
    this.description,
  });

  factory WordChapterData.fromJson(Map<String, dynamic> json) {
    return WordChapterData(
      id: json['id'],
      order: json['order'],
      title: json['title'],
      imgUrl: json['imgUrl'],
      voiceUrl: json['voiceUrl'],
      english: json['english'],
      chinese: json['chinese'],
      vietnam: json['vietnam'],
      russian: json['russian'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order': order,
      'title': title,
      'imgUrl': imgUrl,
      'voiceUrl': voiceUrl,
      'english': english,
      'chinese': chinese,
      'vietnam': vietnam,
      'russian': russian,
      'description': description,
    };
  }
}
