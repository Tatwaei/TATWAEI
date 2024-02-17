import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:tatwaei/adminAdd.dart';
import 'package:tatwaei/adminDelete.dart';
import 'package:tatwaei/adminEdit.dart';
import 'package:tatwaei/adminEditDelete.dart';
import 'package:tatwaei/adminOppo.dart';
import 'package:tatwaei/coorAdd.dart';
import 'package:tatwaei/coorDelete.dart';
import 'package:tatwaei/coorEdit.dart';
import 'package:tatwaei/coordEditDelete.dart';
import 'package:tatwaei/coordinatorOneStudent.dart';
import 'package:tatwaei/coordinatorOppo.dart';

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
        home:coorDelete(),
      ),
    ),
  );
}
