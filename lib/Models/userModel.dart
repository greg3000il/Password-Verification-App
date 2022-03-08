import 'dart:convert';

UserModel userModelJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int id;
  String username;
  String password;

  UserModel({
    this.id,
    this.password,
    this.username,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      password: json["password"], id: json["id"], username: json["username"]);

  Map<String, dynamic> toJson() =>
      {"password": password, "id": id, "username": username};
  String get Password => password;
  String get Username => username;
}
