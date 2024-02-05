import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:lifeflowapp/signup.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBA2KlSt6i4XjDtR5bFj130oeYAWuUegPU",
          appId: "1:705643751438:web:2a29f4b9ba1ab924b7b45f",
          messagingSenderId: "705643751438",
          projectId: "lifeflow-a1947"),
    );
    FirebaseFirestore.instance.settings =
        const Settings(persistenceEnabled: true);

    runApp(MaterialApp(
      title: "LifeFlow",
      home: SignUp(),
      debugShowCheckedModeBanner: false,
    ));
  }
}
