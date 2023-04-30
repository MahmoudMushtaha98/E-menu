import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:newemenu/screen/enter_meal.dart';
import 'firebase_options.dart';
import 'screen/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EnterTheMeals(categories: ['sand','burg'],numberOfMeals: [2,1]),
    );
  }
}
