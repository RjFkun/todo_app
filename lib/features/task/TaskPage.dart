import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/features/change_password/ChangePasswordPage.dart';
import 'package:todo_app/features/login/loginPage.dart';
import 'package:todo_app/features/profile/UserProfilePage.dart';
import 'package:todo_app/features/task/AddTaskPage.dart';
import 'package:todo_app/features/task/EditTaskPage.dart';
import 'package:todo_app/models/Task.dart';
import 'package:todo_app/services/DatabaseService.dart';

class TaskPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TaskPage> {
  Stream<QuerySnapshot<Task>>? _tasksStreamFuture; //inisialisasi taskstream
  int _selectedIndex = 0; //inisialisasi navbar index (dari yang kiri)

  ///fungsi yang akan di eksekusi pertama jika widget dirender
  @override
  void initState() {
    super.initState();
    _tasksStreamFuture = getAllTasks();
  }

  /// fungsi untuk mengambil stream untuk task selesai
  Stream<QuerySnapshot<Task>> getTasksWithStatusTrue() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection(DatabaseService().TASK_COLLECTION_NAME)
          .where('status', isEqualTo: true)
          .withConverter<Task>(
            fromFirestore: (snapshots, _) => Task.fromJson(snapshots.data()!),
            toFirestore: (task, _) => task.toJson(),
          )
          .snapshots();
    }
    throw Exception('User ID not found');
  }

  /// fungsi untuk mengambil stram dengan task belum selesai
  Stream<QuerySnapshot<Task>> getTasksWithStatusFalse() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection(DatabaseService().TASK_COLLECTION_NAME)
          .where('status', isEqualTo: false)
          .withConverter<Task>(
            fromFirestore: (snapshots, _) => Task.fromJson(snapshots.data()!),
            toFirestore: (task, _) => task.toJson(),
          )
          .snapshots();
    }
    throw Exception('User ID not found');
  }

  /// fungsi untuk mengambil stream dengan semua task selesai dan belum selesai
  Stream<QuerySnapshot<Task>> getAllTasks() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection(DatabaseService().TASK_COLLECTION_NAME)
          .withConverter<Task>(
            fromFirestore: (snapshots, _) => Task.fromJson(snapshots.data()!),
            toFirestore: (task, _) => task.toJson(),
          )
          .snapshots();
    }
    throw Exception('User ID not found');
  }

  /// fungsi ketika bottm navbar di klik
  void _onItemTapped(int index) async {
    switch (index) {
      case 0:
        _tasksStreamFuture = getAllTasks();
        break;
      case 1:
        _tasksStreamFuture = getTasksWithStatusFalse();
        break;
      case 2:
        _tasksStreamFuture = getTasksWithStatusTrue();
        break;
      default:
        _tasksStreamFuture = getAllTasks();
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  // Widget ini digunakan untuk membuat halaman utama aplikasi, menampilkan daftar tugas (task list),
// menu pop-up untuk pengaturan pengguna, dan bottom navigation bar untuk memfilter tugas berdasarkan status.
  @override
  Widget build(BuildContext context) {
    // Scaffold sebagai kerangka dasar halaman dengan AppBar, konten dalam Column, dan bottom navigation bar
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF65328E),
        actions: [
          // Menu pop-up untuk pengaturan pengguna
          PopupMenuButton<String>(
            color: Colors.white,
            child: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onSelected: (String result) {
              // Menghandle pilihan yang dipilih dari menu pop-up
              print('You selected: $result');
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              // Menu item untuk menuju halaman profil pengguna
              PopupMenuItem<String>(
                value: 'profile',
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Profile"),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UserProfilePage(),
                  ));
                },
              ),
              // Menu item untuk menuju halaman ubah password
              PopupMenuItem<String>(
                value: 'change password',
                child: ListTile(
                  leading: Icon(Icons.lock),
                  title: Text("Ubah Password"),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChangePasswordPage(),
                  ));
                },
              ),
              // Menu item untuk logout
              PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                ),
                onTap: () async {
                  // Logout pengguna dan arahkan ke halaman login
                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  });
                },
              )
            ],
          ),
        ],
        title: Text(
          'Task List',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(children: [
          // StreamBuilder untuk mendengarkan perubahan pada koleksi tugas
          StreamBuilder(
            stream: _tasksStreamFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }
              // ListView untuk menampilkan daftar tugas
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Task task = snapshot.data!.docs[index].data()!;
                  return ListTile(
                    // Checkbox untuk menandai status tugas
                    leading: Checkbox(
                      value: task.status,
                      onChanged: (bool? value) async {
                        String userId = FirebaseAuth.instance.currentUser!.uid;
                        // Mengupdate status tugas di Firestore
                        FirebaseFirestore.instance
                            .collection(DatabaseService().USER_COLLECTION_NAME)
                            .doc(userId)
                            .collection(DatabaseService().TASK_COLLECTION_NAME)
                            .doc(snapshot.data!.docs[index].id)
                            .update({'status': value});
                      },
                    ),
                    // Tombol edit dan delete untuk setiap tugas
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Menuju halaman edit tugas
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditTaskPage(
                                  taskId: snapshot.data!.docs[index].id,
                                  status: task.status,
                                  title: task.title,
                                  description: task.description,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            // Menampilkan dialog konfirmasi sebelum menghapus tugas
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm Delete'),
                                  content: Text(
                                      'Are you sure you want to delete this task?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Delete'),
                                      onPressed: () async {
                                        // Menghapus tugas dari Firestore
                                        await FirebaseFirestore.instance
                                            .collection(DatabaseService()
                                                .USER_COLLECTION_NAME)
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .collection(DatabaseService()
                                                .TASK_COLLECTION_NAME)
                                            .doc(snapshot.data!.docs[index].id)
                                            .delete();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    // Judul dan deskripsi tugas
                    title: Text(task.title),
                    subtitle: Text(task.description),
                  );
                },
              );
            },
          )
        ]),
      ),
      // Floating action button untuk menambah tugas baru
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskPage()),
          );
        },
        label: Icon(Icons.add),
      ),
      // Bottom navigation bar untuk memfilter tugas berdasarkan status
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'All',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hourglass_top),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done),
            label: 'Done',
          ),
        ],
      ),
    );
  }
}
