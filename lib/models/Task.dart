// To parse this JSON data, do
//
//     final task = taskFromJson(jsonString);

import 'dart:convert';

Task taskFromJson(String str) => Task.fromJson(json.decode(str));

String taskToJson(Task data) => json.encode(data.toJson());

class Task {
  String title;
  String description;
  // DateTime dueDate;
  bool status;

  Task({
    required this.title,
    required this.description,
    // required this.dueDate,
    required this.status,
  });

  Task copyWith({
    String? title,
    String? description,
    // DateTime? dueDate,
    bool? status,
  }) =>
      Task(
        title: title ?? this.title,
        description: description ?? this.description,
        // dueDate: dueDate ?? this.dueDate,
        status: status ?? this.status,
      );

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        title: json["title"],
        description: json["description"],
        // dueDate: DateTime.parse(json["created_at"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        // "dueDate": dueDate.toIso8601String(),
        "status": status,
      };
}
