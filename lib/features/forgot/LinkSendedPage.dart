import 'package:flutter/material.dart';
import 'package:todo_app/features/login/loginPage.dart';

class LinkSendedPage extends StatelessWidget {
  final String email;

  /// Widget ini digunakan untuk membuat halaman yang memberi informasi bahwa link untuk reset password telah dikirim.
  /// Halaman ini menampilkan pesan kepada pengguna yang berisi alamat email tempat link reset password dikirim.
  /// Pengguna diberikan opsi untuk kembali ke halaman login.
  LinkSendedPage({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mendapatkan informasi ukuran layar dan faktor-faktor lingkungan menggunakan MediaQuery
    final mq = MediaQuery.of(context);

    // Membuat tombol "Kembali ke Login Page" dengan efek materi
    final backToLoginPage = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25.0),
      color: Color(0xFF65328E),
      child: MaterialButton(
        minWidth: mq.size.width / 1.2,
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        onPressed: () {
          // Ketika tombol ditekan, arahkan pengguna kembali ke halaman login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
          );
        },
        child: Text(
          "Kembali ke Login Page",
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
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Pesan informasi bahwa link reset password telah dikirim
            Text(
              'Link untuk reset password telah dikirim ke $email',
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            // Tombol untuk kembali ke halaman login
            backToLoginPage
          ],
        ),
      ),
    );
  }
}
