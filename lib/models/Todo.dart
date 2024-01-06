// To parse this JSON data, do
//
//     final todo = todoFromJson(jsonString);

import 'dart:convert';

Todo todoFromJson(String str) => Todo.fromJson(json.decode(str));

String todoToJson(Todo data) => json.encode(data.toJson());

class Todo {
  String title;
  bool conpleted;

  Todo({
    required this.title,
    required this.conpleted,
  });

  Todo copyWith({
    String? title,
    bool? conpleted,
  }) =>
      Todo(
        title: title ?? this.title,
        conpleted: conpleted ?? this.conpleted,
      );

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        title: json["title"],
        conpleted: json["conpleted"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "conpleted": conpleted,
      };
}
