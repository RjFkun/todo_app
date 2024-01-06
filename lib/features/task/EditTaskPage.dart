import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/Task.dart';
import 'package:todo_app/services/DatabaseService.dart';

class EditTaskPage extends StatefulWidget {
  final String taskId;
  final bool status;
  String title;
  String description;

  EditTaskPage(
      {required this.taskId,
      required this.status,
      required this.title,
      required this.description});

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.title;
    _descriptionController.text = widget.description;
  }

  _updateTask() async {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference taskRef = firestore
          .collection(DatabaseService().USER_COLLECTION_NAME)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(DatabaseService().TASK_COLLECTION_NAME)
          .doc(widget.taskId);
      Task task = Task(
        title: _titleController.text,
        description: _descriptionController.text,
        status: widget.status,
      );
      await taskRef.update(task.toJson());
      Navigator.pop(context); // Pop the page after successful update
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    final submitButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(15.0),
        color: Color(0xFF65328E),
        child: MaterialButton(
          minWidth: mq.size.width / 1.2,
          padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
          onPressed: _updateTask,
          child: Text(
            "Submit",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(36),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                Padding(padding: EdgeInsets.only(top: 30)),
                submitButton,
              ],
            ),
          )),
    );
  }
}
