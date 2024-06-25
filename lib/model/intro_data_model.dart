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
  final int id;
  final String level;
  final String category;
  final int cycle;
  final int sets;
  final int chapter;
  final int? adminId;
  final String? titleKor;
  final String? contentKor;
  final String? state;

  IntroListComponentData({
    required this.id,
    required this.level,
    required this.category,
    required this.cycle,
    required this.sets,
    required this.chapter,
    this.adminId,
    this.titleKor,
    this.contentKor,
    this.state,
  });

  factory IntroListComponentData.fromJson(Map<String, dynamic> json) {
    return IntroListComponentData(
      id: json['id'],
      level: json['level'],
      category: json['category'],
      cycle: json['cycle'],
      sets: json['sets'],
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

class IntroModel {
  int? id;
  int chapter;
  int cycle;
  int sets;
  String category;
  String level;
  String? title;
  List<WordData>? wordDatas;

  IntroModel({
    this.id,
    required this.chapter,
    required this.cycle,
    required this.sets,
    required this.category,
    required this.level,
    this.title,
    this.wordDatas,
  });

  factory IntroModel.fromJson(Map<String, dynamic> json) {
    return IntroModel(
      cycle: json['cycle'],
      sets: json['sets'],
      category: 'NONE',
      id: json['id'],
      chapter: json['chapter'],
      level: json['level'],
      title: json['title'],
      wordDatas: List<WordData>.from(
          json['wordDataList'].map((x) => WordData.fromJson(x))),
    );
  }

  IntroModel copyWith({
    int? id,
    int? chapter,
    int? cycle,
    int? sets,
    String? category,
    String? level,
    String? title,
    List<WordData>? wordDatas,
  }) {
    return IntroModel(
      id: id ?? this.id,
      chapter: chapter ?? this.chapter,
      cycle: cycle ?? this.cycle,
      sets: sets ?? this.sets,
      category: category ?? this.category,
      level: level ?? this.level,
      title: title ?? this.title,
      wordDatas: wordDatas ?? this.wordDatas,
    );
  }
}

class AddIntroData {
  int? id;
  String level;
  String category;
  int chapter;
  int cycle;
  int sets;
  String? titleKor;

  AddIntroData({
    this.id,
    required this.level,
    required this.category,
    required this.chapter,
    required this.cycle,
    required this.sets,
    this.titleKor,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level,
      'category': category,
      'chapter': chapter,
      'cycle': cycle,
      'sets': sets,
      'titleKor': titleKor,
    };
  }

  factory AddIntroData.fromJson(Map<String, dynamic> json) {
    return AddIntroData(
      id: json['id'],
      level: json['level'],
      category: json['category'],
      chapter: json['chapter'],
      cycle: json['cycle'],
      sets: json['sets'],
      titleKor: json['titleKor'],
    );
  }

  AddIntroData copyWith({
    String? level,
    String? category,
    int? chapter,
    int? cycle,
    int? sets,
    String? title,
  }) {
    return AddIntroData(
      level: level ?? this.level,
      category: category ?? this.category,
      chapter: chapter ?? this.chapter,
      cycle: cycle ?? this.cycle,
      sets: sets ?? this.sets,
      titleKor: title ?? titleKor,
    );
  }
}

class UpdateIntroData {
  String level;
  String category;
  int cycle;
  int sets;
  int chapter;
  String? titleKor;

  UpdateIntroData({
    required this.level,
    required this.category,
    required this.cycle,
    required this.sets,
    required this.chapter,
    this.titleKor,
  });

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'category': category,
      'chapter': chapter,
      'cycle': cycle,
      'sets': sets,
      'titleKor': titleKor,
    };
  }

  factory UpdateIntroData.fromJson(Map<String, dynamic> json) {
    return UpdateIntroData(
      level: json['level'],
      category: json['category'],
      chapter: json['chapter'],
      cycle: json['cycle'],
      sets: json['sets'],
      titleKor: json['titleKor'],
    );
  }

  UpdateIntroData copyWith({
    String? level,
    String? category,
    int? chapter,
    int? cycle,
    int? sets,
    String? title,
  }) {
    return UpdateIntroData(
      level: level ?? this.level,
      category: category ?? this.category,
      chapter: chapter ?? this.chapter,
      cycle: cycle ?? this.cycle,
      sets: sets ?? this.sets,
      titleKor: title ?? titleKor,
    );
  }
}
