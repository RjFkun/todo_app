import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/features/forgot/RorgotPasswordPage.dart';
import 'package:todo_app/features/register/RegisterPage.dart';
import 'package:todo_app/features/task/TaskPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // membuat controller field
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// funsi untuk melakukan login dengan text yang tersimpan di emailController dan passwordController
  Future<bool> _login() async {
    //cen apakah field email kosong
    if (emailController.text.isEmpty) {
      //menampilan snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('email tidak boleh kosong')),
      );
      return false;
    }

    // cek apakah field password kosong
    if (passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('password tidak boleh kosong')),
      );

      return false;
    }
    try {
      // login menggunakan firebase auth email dan password
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      //jika login berhasil (userCredential tidak null)
      if (userCredential.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil login')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TaskPage()),
        );

        return true;
      }
      // jika login gagal
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal Login')),
        );
        return false;
      }
    } on FirebaseAuthException catch (e) {
      // jika gagal akan cek apa alasan dari kegagalan login
      switch (e.code) {
        // jika format email tidak valis
        case 'invalid-email':
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('format email salah')),
          );
          break;
        // jika akun di nonaktifkan di fireauth
        case 'user-disabled':
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('user ini tidak dizinkan untuk login')),
          );
          break;
        //jika user tidak ditemukan
        case 'user-not-found':
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('tidak ada user dengan email ini')),
          );
          break;
        //jika password salah
        case 'wrong-password':
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('password salah')),
          );
          break;
        //jika email atau password salah
        case 'invalid-credential':
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('email atau password salah')),
          );
          break;
        //jika tidak ada yang benar diatas
        default:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('gagal login, terjadi kesalahan')),
          );
      }
      return false;
    } catch (e) {
      //jika terjadi error lain selain error firebaseauth akan tampil snack bar ini
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('terjadi kesalahan')),
      );

      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    //mendapatkan informasi tentang ukuran layar
    final mq = MediaQuery.of(context);

    //Menampilkan logo aplikasi menggunakan gambar yang diambil dari file static .
    final logo = Image.asset(
      "assets/static/img/logo.png",
      height: mq.size.height / 4,
    );

    // Menyiapkan input field untuk pengguna memasukkan alamat email
    final emailField = TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "something@example.com",
        labelText: "Email Address",
      ),
    );

    // Menyiapkan input field untuk pengguna memasukkan kata sandi.
    final passwordField = TextField(
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "password",
        labelText: "Password",
      ),
    );

    // Membuat tombol login
    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25.0),
      color: Color(0xFF65328E),
      child: MaterialButton(
        minWidth: mq.size.width / 1.2,
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        onPressed: () {
          _login();
        },
        child: Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    // Menyiapkan teks "lupa password?" yang dapat diklik.
    final forgotPassword = GestureDetector(
      child: Text(
        "lupa password?",
        style: TextStyle(
          color: Color(0xFF65328E),
          fontSize: 14,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          height: 0.18,
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ForgotPasswordPage(),
        ));
      },
    );

    // Menyiapkan teks yang berisi tautan untuk mendaftar.
    final registerButton = Text.rich(
      TextSpan(
        children: [
          const WidgetSpan(
              child: Text(
            "Tidak punya akun? ",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              height: 0.18,
            ),
          )),
          WidgetSpan(
              child: GestureDetector(
            child: const Text(
              "Daftar sekarang",
              style: TextStyle(
                color: Color(0xFF65328E),
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: 0.18,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RegisterPage(),
              ));
            },
          )),
        ],
      ),
    );

    /**
     * Mendefinisikan struktur dasar halaman menggunakan Scaffold. 
     * Seluruh tata letak dibungkus dalam Padding dan ListView untuk memastikan tata letak yang baik dan dapat digulir.
     *  Semua elemen UI ditempatkan dalam struktur kolom untuk penataan yang rapi.
     */
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.all(36.0),
      child: ListView(shrinkWrap: true, children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            logo,
            Container(
              height: 61,
              child: const Column(
                children: [
                  Text(
                    "Selamat Datang",
                    style: TextStyle(
                      color: Color(0xFF65328E),
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      height: 0.09,
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(16)),
                  Text(
                    "Login untuk Masuk",
                    style: TextStyle(
                      color: Color(0xFF65328E),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 0.12,
                    ),
                  )
                ],
              ),
            ),
            emailField,
            SizedBox(height: 30),
            passwordField,
            SizedBox(height: 30),
            Row(
              children: [forgotPassword],
            ),
            SizedBox(height: 16),
            loginButton,
            SizedBox(height: 30),
            registerButton
          ],
        )
      ]),
    ));
  }
}
