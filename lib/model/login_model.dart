import 'dart:core';

class LoginModel {
  final String id, password;

  LoginModel(this.id, this.password);

  LoginModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        password = json['password'];

  Map<String, dynamic> toJson() => {'id': id, 'password': password};
}
