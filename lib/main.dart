import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:student_management_system/providers/students.dart';
import 'package:student_management_system/screens/add_new_student.dart';
import 'package:student_management_system/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _firebaseInstance = Firebase.initializeApp();
    return ChangeNotifierProvider(
      create: (_) => Students(),
      child: MaterialApp(
        title: 'Students Manager',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        routes: {
          AddNewStudent.routeName: (c) => const AddNewStudent(),
        },
        home: FutureBuilder(
          future: _firebaseInstance,
          builder: (ctx, snapshot) {
            if (snapshot.hasError) {
              return const Scaffold(
                body: Center(
                  child: Text("Some Error Occured"),
                ),
              );
            } else if (snapshot.hasData) {
              return const HomeScreen();
            } else {
              return const Scaffold(
                body: CircularProgressIndicator(),
              );
            }
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
