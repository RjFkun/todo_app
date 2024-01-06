import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  ///Fungsi ini digunakan untuk mengubah kata sandi pengguna. fungsi akan mencoba
  /// untuk mengubah kata sandi pengguna menggunakan metode reauthentication.
  void _changePassword() async {
    String email = _auth.currentUser!.email ?? '';
    String oldPassword = _oldPasswordController.text;
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // Membuat kredensial dengan email dan kata sandi lama
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: oldPassword,
    );

    try {
      // Reauthenticating dengan kredensial
      await _auth.currentUser!.reauthenticateWithCredential(credential);

      // Memeriksa apakah kata sandi baru dan konfirmasi kata sandi cocok
      if (newPassword == confirmPassword) {
        // Memperbarui kata sandi
        await _auth.currentUser!.updatePassword(newPassword);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password changed successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('New password and confirmation password do not match')),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'weak-password') {
        message = 'The provided password is too weak.';
      } else if (e.code == 'requires-recent-login') {
        message =
            'This operation requires the user to have recently logged in.';
      } else {
        message =
            'An error occurred'; // Jika ada kesalahan lain, simpan pesan kesalahan
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('An error occurred')));
    }
  }

  // Widget ini merupakan bagian dari tampilan yang memungkinkan pengguna mengganti kata sandi.
// Widget ini memiliki tiga bidang teks untuk memasukkan kata sandi lama, kata sandi baru, dan konfirmasi kata sandi baru.
// Ketika tombol "Change Password" ditekan, fungsi _changePassword akan dipanggil untuk memulai proses penggantian kata sandi.

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    // Tombol untuk memicu fungsi _changePassword saat ditekan
    final changePasswordButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(15.0),
      color: Color(0xFF65328E),
      child: MaterialButton(
        minWidth: mq.size.width / 1.2,
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        onPressed: _changePassword,
        child: Text(
          "Change Password",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Change Password')),
      body: Padding(
        padding: EdgeInsets.all(36),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              // Input untuk memasukkan kata sandi lama
              TextField(
                controller: _oldPasswordController,
                decoration: InputDecoration(labelText: 'Old Password'),
                obscureText: true,
              ),
              // Input untuk memasukkan kata sandi baru
              TextField(
                controller: _newPasswordController,
                decoration: InputDecoration(labelText: 'New Password'),
                obscureText: true,
              ),
              // Input untuk memasukkan konfirmasi kata sandi baru
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: 'Confirm New Password'),
                obscureText: true,
              ),
              // Menampilkan tombol untuk mengganti kata sandi
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: changePasswordButton,
              )
            ],
          ),
        ),
      ),
    );
  }
}
