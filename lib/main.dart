import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
//import 'homePageStudent.dart';
//import 'homePageCoordinator.dart';
import 'homePageAdmin.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFfbfae9)),
      home: HomePage()));
}
