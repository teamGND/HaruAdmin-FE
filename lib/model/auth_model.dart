class AdminSignUp {
  String adminId;
  String password;
  String name;
  String ranks;
  String phoneNumber;

  AdminSignUp({
    required this.adminId,
    required this.password,
    required this.name,
    required this.ranks,
    required this.phoneNumber,
  });

  factory AdminSignUp.fromJson(Map<String, dynamic> jsondata) {
    return AdminSignUp(
        adminId: jsondata['amdinId'], //adminId key에 있는 value 값을 가져옴
        password: jsondata['password'],
        name: jsondata['name'],
        ranks: jsondata['ranks'],
        phoneNumber: jsondata['phoneNumber']);
  }
}

class AdminLogin {
  String adminId;
  String password;
  String? token;

  AdminLogin({
    required this.adminId,
    required this.password,
  });

  factory AdminLogin.fromJson(Map<String, dynamic> jsondata) {
    return AdminLogin(
        adminId: jsondata['adminId'], password: jsondata['password']);
  }
}

class AdminList {
  int id;
  String? adminId;
  String? password;
  String? name;
  String? ranks;
  String? phoneNumber;
  String? status;
  String? testDataList;

  AdminList({
    required this.id,
    this.adminId,
    this.password,
    this.name,
    this.ranks,
    this.phoneNumber,
    this.status,
    this.testDataList,
  });

  factory AdminList.fromJson(Map<String, dynamic> jsondata) {
    return AdminList(
        id: jsondata['id'],
        adminId: jsondata['adminId'],
        name: jsondata['name'],
        phoneNumber: jsondata['phoneNumber'],
        ranks: jsondata['ranks'],
        status: jsondata['status']);
  }
}

class testData {
  int testDataId;
  int chapter;
  int order;
  String type;
  String question;
  String answer;
  String admin;
  String createdAt;
  String updatedAt;

  testData({
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

  factory testData.fromJson(Map<String, dynamic> jsondata) {
    return testData(
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
