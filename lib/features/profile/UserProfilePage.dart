import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/User.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>(); // Kunci formulir untuk validasi
  final _nameController =
      TextEditingController(); // Controller untuk input nama
  final _ageController = TextEditingController(); // Controller untuk input umur
  final _emailController =
      TextEditingController(); // Controller untuk input alamat email

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(36),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .withConverter(
                // Menggunakan converter untuk mengonversi data Firestore ke objek UserModel
                fromFirestore: (snapshot, options) =>
                    UserModel.fromJson(snapshot.data()!),
                toFirestore: (user, options) => user.toJson(),
              )
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Menampilkan indikator loading saat data masih dimuat
              return Center(child: CircularProgressIndicator());
            } else {
              // Memasukkan data pengguna ke dalam kontroler untuk ditampilkan di formulir
              _nameController.text = snapshot.data!['name'];
              _ageController.text = snapshot.data!['age'].toString();
              _emailController.text = snapshot.data!['email'];

              // Formulir untuk menampilkan dan mengubah informasi pengguna
              return Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    // Input field untuk nama pengguna
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    // Input field untuk umur pengguna
                    TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Age"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your age';
                        }
                        return null;
                      },
                    ),
                    // Input field untuk alamat email (diaktifkan hanya untuk tampilan, tidak dapat diubah)
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: "Email"),
                      enabled: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    // Tombol untuk menyimpan perubahan informasi pengguna
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Memanggil fungsi _updateUserName untuk menyimpan perubahan
                          _updateUserName(
                            snapshot.data!.id,
                            UserModel(
                              age: int.parse(_ageController.text),
                              email: _emailController.text,
                              name: _nameController.text,
                            ),
                          );
                        }
                      },
                      child: Text('Save'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  /// Fungsi ini digunakan untuk memperbarui nama pengguna di Firestore.
  /// Menerima ID dokumen pengguna dan objek UserModel yang berisi informasi yang diperbarui.
  /// Setelah pembaruan berhasil, menampilkan Snackbar untuk memberi tahu pengguna bahwa data telah disimpan.
  void _updateUserName(String userDocId, UserModel user) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userDocId)
        .update(user.toJson());
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Data berhasil disimpan"),
      duration: Duration(seconds: 1),
    ));
  }
}
