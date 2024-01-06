import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/features/login/loginPage.dart';
import 'package:todo_app/features/task/TaskPage.dart';
import 'firebase_options.dart';

void main() async {
  // inisialisasi firebase untuk bisa terhubung dengan firebase
  WidgetsFlutterBinding.ensureInitialized();
  //Bug nya belum ada solusi bahkan msaih di perbincangkan di forum https://github.com/firebase/flutterfire/issues/10468
  //akan muncul exception jika didebug dengan web (chrome). jika di run tanpa debug akan aman
  //lebih baik run atau debug menggunakan perangkat android, ios, atau mac os.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // enable firestore offline data
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);

  // cek apakah ada info login yang tersimpan jika iya akan langsung ke Task page
  Widget _defaultHome = LoginPage();
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    _defaultHome = TaskPage();
  }

  runApp(MaterialApp(
    home: _defaultHome,
    title: "Todo App",
  ));
}
