import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/features/login/loginPage.dart';
import 'package:todo_app/models/User.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //instansiasi database
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // membuat controller untuk filed nama, email, umur, dan password
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  /// Fungsi ini digunakan untuk mendaftarkan akun baru. Pada dasarnya, fungsi ini melakukan beberapa validasi
  /// untuk memastikan bahwa data yang dimasukkan oleh pengguna sesuai dengan persyaratan, seperti tidak boleh kosong
  /// dan format email yang benar. Jika validasi berhasil, fungsi akan mencoba membuat akun menggunakan email dan
  /// password yang dimasukkan pengguna melalui Firebase Authentication.
  void _registerAccount() async {
    // Validasi nama tidak boleh kosong
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama tidak boleh kosong')),
      );
      return;
    }

    // Validasi email tidak boleh kosong
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email tidak boleh kosong')),
      );
      return;
    }

    // Validasi umur tidak boleh kosong
    if (_ageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Umur tidak boleh kosong')),
      );
      return;
    }

    // Validasi password tidak boleh kosong
    if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password tidak boleh kosong')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Password dan Confirm password tidak sama')),
      );
      return;
    }

    try {
      // Membuat akun menggunakan Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Menyimpan informasi pengguna ke koleksi 'users' di Firestore
      await _db.collection('users').doc(userCredential.user!.uid).set(UserModel(
            age: int.parse(_ageController.text),
            email: _emailController.text,
            name: _nameController.text,
          ).toJson());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Daftar berhasil, silahkan login")),
      );
      // Mengarahkan pengguna ke halaman login setelah pendaftaran berhasil
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => LoginPage(),
      ));
    } on FirebaseAuthException catch (e) {
      // Menangani error yang mungkin terjadi saat membuat akun
      String errorMessage;

      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Sudah ada akun dengan alamat email yang diberikan.';
          break;
        case 'invalid-email':
          errorMessage = 'Format email salah.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Akun email/password tidak diaktifkan.';
          break;
        case 'weak-password':
          errorMessage = 'Password tidak cukup kuat.';
          break;
        default:
          errorMessage = 'gagal melakukan pendaftaran, Terjadi kesalahan.';
      }

      // Menampilkan pesan kesalahan kepada pengguna melalui Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("terjadi kesalahan")),
      );
    }
  }

  @override

  /// Widget ini digunakan untuk membuat halaman pendaftaran (register). Halaman ini berisi formulir
  /// untuk pengguna memasukkan informasi seperti nama, email, umur, dan password. Ketika pengguna
  /// menekan tombol "Daftar", fungsi _registerAccount() akan dipanggil untuk melakukan proses pendaftaran.
  Widget build(BuildContext context) {
    // Mendapatkan informasi ukuran layar dan faktor-faktor lingkungan menggunakan MediaQuery
    final mq = MediaQuery.of(context);

    // Membuat widget untuk menampilkan logo aplikasi
    final logo = Image.asset(
      "assets/static/img/logo.png",
      height: mq.size.height / 4,
    );

    // Membuat tombol pendaftaran dengan efek materi
    final registerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25.0),
      color: Color(0xFF65328E),
      child: MaterialButton(
        minWidth: mq.size.width / 1.2,
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        onPressed: () {
          // Ketika tombol "Daftar" ditekan, panggil fungsi _registerAccount()
          _registerAccount();
        },
        child: Text(
          "Daftar",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    // Scaffold sebagai kerangka dasar halaman dengan AppBar dan konten dalam ListView
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(36),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            // Menampilkan logo
            logo,
            // Judul untuk membimbing pengguna membuat akun
            Text(
              "Buat sebuah akun",
              style: TextStyle(
                color: Color(0xFF65328E),
                fontSize: 18,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                height: 0.09,
              ),
              textAlign: TextAlign.center,
            ),
            // Input field untuk nama
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            // Input field untuk email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            // Input field untuk umur
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
            ),
            // Input field untuk password
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true, // Menyembunyikan teks password
            ),
            // Input field untuk confirm password
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true, // Menyembunyikan teks password
            ),
            SizedBox(
              height: 50,
            ),
            // Tombol "Daftar" untuk memulai proses pendaftaran
            registerButton
          ],
        ),
      ),
    );
  }
}
