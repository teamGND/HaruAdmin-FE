class AdminSignUp {
  String? adminId;
  String? password;
  String? name;
  String? ranks;
  String? phoneNumber;

  AdminSignUp({
    this.adminId,
    this.password,
    this.name,
    this.ranks,
    this.phoneNumber,
  });

  factory AdminSignUp.fromJson(Map<String, dynamic> jsondata) {
    return AdminSignUp(
        adminId: jsondata['amdinId'],
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

class MyInfo {
  int seq;
  String? name;
  String? rank;
  String? phoneNumber;

  MyInfo({
    required this.seq,
    this.name,
    this.rank,
    this.phoneNumber,
  });

  factory MyInfo.fromJson(Map<String, dynamic> jsondata) {
    return MyInfo(
        seq: jsondata['seq'],
        name: jsondata['name'],
        rank: jsondata['rank'],
        phoneNumber: jsondata['phoneNumber']);
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
    required this.adminId,
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
