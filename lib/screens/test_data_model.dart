class TestData {
  int testDataId;
  int chapter;
  int order;
  String type;
  String question;
  String answer;
  String admin;
  String createdAt;
  String updatedAt;

  TestData({
    required this.testDataId,
    required this.chapter,
    required this.order,
    required this.type,
    required this.question,
    required this.answer,
    required this.admin,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TestData.fromJson(Map<String, dynamic> jsondata) {
    return TestData(
        testDataId: jsondata['testDataId'],
        chapter: jsondata['chapter'],
        order: jsondata['order'],
        type: jsondata['type'],
        question: jsondata['question'],
        answer: jsondata['answer'],
        admin: jsondata['admin'],
        createdAt: jsondata['createdAt'],
        updatedAt: jsondata['updatedAt']);
  }
}
