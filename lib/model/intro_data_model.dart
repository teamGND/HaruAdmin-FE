class IntroDataList {
  List<IntroListComponentData> content;
  PageableData pageable;
  int totalElements;
  int totalPages;
  bool last;
  int size;
  int number;
  SortData sort;
  int numberOfElements;
  bool first;
  bool empty;

  IntroDataList({
    required this.content,
    required this.pageable,
    required this.totalElements,
    required this.totalPages,
    required this.last,
    required this.size,
    required this.number,
    required this.sort,
    required this.numberOfElements,
    required this.first,
    required this.empty,
  });

  factory IntroDataList.fromJson(Map<String, dynamic> json) {
    return IntroDataList(
      content: List<IntroListComponentData>.from(
          json['content'].map((x) => IntroListComponentData.fromJson(x))),
      pageable: PageableData.fromJson(json['pageable']),
      totalElements: json['totalElements'],
      totalPages: json['totalPages'],
      last: json['last'],
      size: json['size'],
      number: json['number'],
      sort: SortData.fromJson(json['sort']),
      numberOfElements: json['numberOfElements'],
      first: json['first'],
      empty: json['empty'],
    );
  }
}

class SortData {
  bool empty;
  bool sorted;
  bool unsorted;

  SortData({
    required this.empty,
    required this.sorted,
    required this.unsorted,
  });

  factory SortData.fromJson(Map<String, dynamic> json) {
    return SortData(
      empty: json['empty'],
      sorted: json['sorted'],
      unsorted: json['unsorted'],
    );
  }
}

class PageableData {
  SortData sort;
  int offset;
  int pageNumber;
  int pageSize;
  bool unpaged;
  bool paged;

  PageableData({
    required this.sort,
    required this.offset,
    required this.pageNumber,
    required this.pageSize,
    required this.unpaged,
    required this.paged,
  });

  factory PageableData.fromJson(Map<String, dynamic> json) {
    return PageableData(
      sort: SortData.fromJson(json['sort']),
      offset: json['offset'],
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      unpaged: json['unpaged'],
      paged: json['paged'],
    );
  }
}

class IntroListComponentData {
  int id;
  String level;
  String category;
  int chapter;
  int adminId;
  String titleKor;
  String contentKor;
  String state;

  IntroListComponentData({
    required this.id,
    required this.level,
    required this.category,
    required this.chapter,
    required this.adminId,
    required this.titleKor,
    required this.contentKor,
    required this.state,
  });

  factory IntroListComponentData.fromJson(Map<String, dynamic> json) {
    return IntroListComponentData(
      id: json['id'],
      level: json['level'],
      category: json['category'],
      chapter: json['chapter'],
      adminId: json['adminId'],
      titleKor: json['titleKor'],
      contentKor: json['contentKor'],
      state: json['state'],
    );
  }
}

class WordData {
  int id;
  int order;
  String title;
  String description;
  String english;
  String chinese;
  String russian;
  String vietnam;
  String imgUrl;
  String voiceUrl;

  WordData({
    required this.id,
    required this.order,
    required this.title,
    required this.description,
    required this.english,
    required this.chinese,
    required this.russian,
    required this.vietnam,
    required this.imgUrl,
    required this.voiceUrl,
  });

  factory WordData.fromJson(Map<String, dynamic> json) {
    return WordData(
      id: json['id'],
      order: json['order'],
      title: json['title'],
      description: json['description'],
      english: json['english'],
      chinese: json['chinese'],
      russian: json['russian'],
      vietnam: json['vietnam'],
      imgUrl: json['imgUrl'],
      voiceUrl: json['voiceUrl'],
    );
  }
}

class AddIntroData {
  String level;
  int category;
  int chapter;
  int cycle;
  String title;
  String wordTag;
  List<WordData> wordDatas;

  AddIntroData({
    required this.level,
    required this.category,
    required this.chapter,
    required this.cycle,
    required this.title,
    required this.wordTag,
    required this.wordDatas,
  });

  Map<String, dynamic> toJson() {
    return {
      "level": level,
      "category": category,
      "chapter": chapter,
      "cycle": cycle,
      "title": title,
      "wordTag": wordTag,
      "wordDatas": wordDatas,
    };
  }

  factory AddIntroData.fromJson(Map<String, dynamic> json) {
    return AddIntroData(
      level: json['level'],
      category: json['category'],
      chapter: json['chapter'],
      cycle: json['cycle'],
      title: json['title'],
      wordTag: json['wordTag'],
      wordDatas: List<WordData>.from(
          json['wordDatas'].map((x) => WordData.fromJson(x))),
    );
  }
}
