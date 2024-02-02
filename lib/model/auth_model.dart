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
