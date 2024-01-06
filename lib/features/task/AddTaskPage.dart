import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/Task.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>(); // Kunci formulir untuk validasi
  final _titleController =
      TextEditingController(); // Controller untuk input judul tugas
  final _descriptionController =
      TextEditingController(); // Controller untuk input deskripsi tugas

  /// Fungsi ini digunakan untuk menambahkan tugas baru ke Firestore saat formulir valid.
  /// Fungsi ini memeriksa validitas formulir menggunakan kunci formulir (_formKey) dan jika formulir
  /// valid, membuat objek Task dari input pengguna, menambahkannya ke koleksi 'task' di Firestore,
  /// dan menutup halaman penambahan tugas.
  addTask() async {
    // Memeriksa validitas formulir menggunakan kunci formulir
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      // Mendapatkan referensi koleksi 'task' di Firestore
      CollectionReference tasks = firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('task');

      // Membuat objek Task dari input pengguna
      Task task = Task(
        title: _titleController.text,
        description: _descriptionController.text,
        status: false,
      );

      // Menambahkan tugas ke Firestore dan menutup halaman penambahan tugas
      await tasks.add(task.toJson());
      Navigator.pop(context);
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
          onPressed: addTask,
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
        title: Text('Add Task'),
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
                SizedBox(
                  height: 30,
                ),
                submitButton
              ],
            ),
          )),
    );
  }
}
