class MetaGrammarDataList {
  List<MetaGrammarData>? content;
  bool empty;
  bool first;
  bool last;
  int number;
  int numberOfElements;
  Pageable pageable;
  int size;
  Sort sort;
  int totalElements;
  int totalPages;

  MetaGrammarDataList({
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

  factory MetaGrammarDataList.fromJson(Map<String, dynamic> json) {
    return MetaGrammarDataList(
      content: List<MetaGrammarData>.from(
          json['content'].map((x) => MetaGrammarData.fromJson(x))),
      empty: json['empty'],
      first: json['first'],
      last: json['last'],
      number: json['number'],
      numberOfElements: json['numberOfElements'],
      pageable: Pageable.fromJson(json['pageable']),
      size: json['size'],
      sort: Sort.fromJson(json['sort']),
      totalElements: json['totalElements'],
      totalPages: json['totalPages'],
    );
  }
}

class MetaGrammarData {
  String? content;
  int? id;
  String? title;

  MetaGrammarData({
    this.content,
    this.id,
    this.title,
  });

  factory MetaGrammarData.fromJson(Map<String, dynamic> json) {
    return MetaGrammarData(
      content: json['content'],
      id: json['id'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'id': id,
      'title': title,
    };
  }
}

class Pageable {
  int offset;
  int pageNumber;
  int pageSize;
  bool paged;
  Sort sort;
  bool unpaged;

  Pageable({
    required this.offset,
    required this.pageNumber,
    required this.pageSize,
    required this.paged,
    required this.sort,
    required this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) {
    return Pageable(
      offset: json['offset'],
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      paged: json['paged'],
      sort: Sort.fromJson(json['sort']),
      unpaged: json['unpaged'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offset': offset,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'paged': paged,
      'sort': sort.toJson(),
      'unpaged': unpaged,
    };
  }
}

class Sort {
  bool empty;
  bool sorted;
  bool unsorted;

  Sort({
    required this.empty,
    required this.sorted,
    required this.unsorted,
  });

  factory Sort.fromJson(Map<String, dynamic> json) {
    return Sort(
      empty: json['empty'],
      sorted: json['sorted'],
      unsorted: json['unsorted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'empty': empty,
      'sorted': sorted,
      'unsorted': unsorted,
    };
  }
}

class MetaGrammarDataModel {
  int? id;
  String? chinese;
  String? content;
  String? english;
  String? image;
  String? russian;
  String? title;
  String? vietnam;

  MetaGrammarDataModel({
    this.id,
    this.chinese,
    this.content,
    this.english,
    this.image,
    this.russian,
    this.title,
    this.vietnam,
  });

  factory MetaGrammarDataModel.fromJson(Map<String, dynamic> json) {
    return MetaGrammarDataModel(
      id: json['id'],
      chinese: json['chinese'],
      content: json['content'],
      english: json['english'],
      image: json['image'],
      russian: json['russian'],
      title: json['title'],
      vietnam: json['vietnam'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chinese': chinese,
      'content': content,
      'english': english,
      'imgUrl': image,
      'russian': russian,
      'title': title,
      'vietnam': vietnam,
    };
  }

  MetaGrammarDataModel copyWith({
    int? id,
    String? chinese,
    String? content,
    String? english,
    String? image,
    String? russian,
    String? title,
    String? vietnam,
  }) {
    return MetaGrammarDataModel(
      id: id ?? this.id,
      chinese: chinese ?? this.chinese,
      content: content ?? this.content,
      english: english ?? this.english,
      image: image ?? this.image,
      russian: russian ?? this.russian,
      title: title ?? this.title,
      vietnam: vietnam ?? this.vietnam,
    );
  }
}

class AddMetaData {
  String? chinese;
  String? content;
  String? english;
  String? imgUrl;
  String? russian;
  String? title;
  String? vietnam;

  AddMetaData({
    this.chinese,
    this.content,
    this.english,
    this.imgUrl,
    this.russian,
    this.title,
    this.vietnam,
  });

  factory AddMetaData.fromJson(Map<String, dynamic> json) {
    return AddMetaData(
      chinese: json['chinese'],
      content: json['content'],
      english: json['english'],
      imgUrl: json['imgUrl'],
      russian: json['russian'],
      title: json['title'],
      vietnam: json['vietnam'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'chinese': chinese,
      'content': content,
      'english': english,
      'imgUrl': imgUrl,
      'russian': russian,
      'title': title,
      'vietnam': vietnam,
    };
  }

  AddMetaData copyWith({
    String? chinese,
    String? content,
    String? english,
    String? imgUrl,
    String? russian,
    String? title,
    String? vietnam,
  }) {
    return AddMetaData(
      chinese: chinese ?? this.chinese,
      content: content ?? this.content,
      english: english ?? this.english,
      imgUrl: imgUrl ?? this.imgUrl,
      russian: russian ?? this.russian,
      title: title ?? this.title,
      vietnam: vietnam ?? this.vietnam,
    );
  }
}
