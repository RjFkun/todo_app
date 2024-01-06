import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/features/forgot/LinkSendedPage.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final FirebaseAuth _auth =
      FirebaseAuth.instance; // Instance dari FirebaseAuth
  final TextEditingController _emailController =
      TextEditingController(); // Controller untuk input email

  /// Fungsi ini digunakan untuk mengirimkan email reset password. Pengguna memasukkan alamat email
  /// mereka, kemudian fungsi ini akan mencoba mengirimkan email reset password ke alamat tersebut.
  /// Jika email berhasil dikirim, pengguna akan diberi tahu melalui snackbar dan diarahkan ke halaman
  /// yang memberi informasi bahwa link reset password telah dikirim. Jika terdapat kesalahan selama
  /// proses, pesan kesalahan akan ditampilkan melalui snackbar.
  ///
  void _sendPasswordResetEmail() async {
    try {
      // Mengirimkan email reset password menggunakan FirebaseAuth
      await _auth.sendPasswordResetEmail(email: _emailController.text);

      // Menampilkan snackbar dengan pesan bahwa link reset password telah dikirim
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Link reset password dikirim')),
      );

      // Mengarahkan pengguna ke halaman yang memberi informasi bahwa link reset password telah dikirim
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LinkSendedPage(email: _emailController.text),
      ));
    } on FirebaseAuthException catch (e) {
      String message;
      // Menangani kesalahan yang mungkin terjadi selama proses reset password
      if (e.code == 'user-not-found') {
        message = 'Tidak ada pengguna yang sesuai dengan email yang diberikan.';
      } else if (e.code == 'invalid-email') {
        message = 'Email yang diberikan tidak valid.';
      } else {
        message =
            'Terjadi kesalahan'; // Jika ada kesalahan lain, simpan pesan kesalahan
      }
      // Menampilkan snackbar dengan pesan kesalahan
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      // Menampilkan snackbar jika terjadi kesalahan umum
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Terjadi kesalahan')));
    }
  }

  // Widget ini digunakan untuk membuat halaman "Lupa Password" (Forgot Password). Pengguna diminta
// memasukkan alamat email mereka, dan ketika mereka menekan tombol "Kirim", fungsi _sendPasswordResetEmail()
// akan dipanggil untuk mengirimkan email reset password.

  @override
  Widget build(BuildContext context) {
    // Mendapatkan informasi ukuran layar dan faktor-faktor lingkungan menggunakan MediaQuery
    final mq = MediaQuery.of(context);

    // Membuat tombol "Kirim" dengan efek materi
    final sendButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25.0),
      color: Color(0xFF65328E),
      child: MaterialButton(
        minWidth: mq.size.width / 1.2,
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        onPressed: () {
          // Ketika tombol "Kirim" ditekan, panggil fungsi _sendPasswordResetEmail()
          _sendPasswordResetEmail();
        },
        child: Text(
          "Kirim",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    // Scaffold sebagai kerangka dasar halaman dengan AppBar dan konten dalam Column
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(36.0),
        child: Column(
          children: <Widget>[
            // Judul untuk memberitahu pengguna bahwa mereka dapat mereset password
            const Text(
              'Lupa password anda?',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // Deskripsi yang memberitahu pengguna untuk memasukkan email
            const Text(
              'Masukan email anda, kami akan mengirimkan link untuk mengubah password anda.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF4B4B4B),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
            // Input field untuk memasukkan alamat email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(
              height: 30,
            ),
            // Tombol "Kirim" untuk memulai proses reset password
            sendButton
          ],
        ),
      ),
    );
  }
}
