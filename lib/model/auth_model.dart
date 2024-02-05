class AdminSignUp {
  String adminId;
  String password;
  String name;
  String ranks;
  String phoneNumber;

  AdminSignUp(
    this.adminId,
    this.password,
    this.name,
    this.ranks,
    this.phoneNumber,
  );

  factory AdminSignUp.fromJson(Map<String, dynamic> jsondata) {
    return AdminSignUp(
        jsondata['amdinId'], //adminId key에 있는 value 값을 가져옴
        jsondata['password'],
        jsondata['name'],
        jsondata['ranks'],
        jsondata['phoneNumber']);
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
