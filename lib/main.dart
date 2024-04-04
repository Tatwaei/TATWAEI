import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:tatwaei/AdminOppDetails.dart';
import 'package:tatwaei/aDelete.dart';
import 'package:tatwaei/aEdit.dart';
import 'package:tatwaei/adminAdd.dart';

import 'package:tatwaei/adminOppo.dart';
import 'package:tatwaei/cDelete.dart';
import 'package:tatwaei/cEditDelete.dart';
import 'package:tatwaei/coorAdd.dart';

import 'package:tatwaei/coordinatorOneStudent.dart';
import 'package:tatwaei/coordinatorOppo.dart';
import 'package:tatwaei/homePageAdmin.dart';
import 'package:tatwaei/homePageCoordinator.dart';
import 'package:tatwaei/homePageStudent.dart';
import 'package:tatwaei/login.dart';
import 'package:tatwaei/studentAccount.dart';
import 'package:tatwaei/aEditDelete.dart';

import 'user_state.dart';
//import 'login.dart';
//import 'homePageStudent.dart';
//import 'homePageCoordinator.dart';
//import 'homePageAdmin.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserState(),
      child: MaterialApp(
        theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFfbfae9)),
        home: LoginPage(),
      ),
    ),
  );
}
