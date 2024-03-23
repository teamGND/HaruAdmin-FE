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
      content: List<IntroListComponentData>.from(json['content'].map((x) => IntroListComponentData.fromJson(x))),
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
