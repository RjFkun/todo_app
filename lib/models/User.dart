// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int age;
  String email;
  String name;

  UserModel({
    required this.age,
    required this.email,
    required this.name,
  });

  UserModel copyWith({
    int? age,
    String? email,
    String? name,
  }) =>
      UserModel(
        age: age ?? this.age,
        email: email ?? this.email,
        name: name ?? this.name,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        age: json["age"],
        email: json["email"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "age": age,
        "email": email,
        "name": name,
      };
}

class Name {
  String firstname;
  String lastname;

  Name({
    required this.firstname,
    required this.lastname,
  });

  Name copyWith({
    String? firstname,
    String? lastname,
  }) =>
      Name(
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
      );

  factory Name.fromJson(Map<String, dynamic> json) => Name(
        firstname: json["firstname"],
        lastname: json["lastname"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
      };
}
