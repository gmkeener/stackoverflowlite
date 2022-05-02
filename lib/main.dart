import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:genopets/App/MainWidget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:genopets/module.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");

  runApp(
      ModularApp(module: MainModule(), child: MainWidget(), debugMode: false));
}
