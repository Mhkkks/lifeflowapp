// ignore_for_file: use_build_context_synchronously

import 'package:lifeflowapp/page2.dart' as page2;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  final page2.User user;
  const Login({Key? key, required this.user}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 177, 177),
      appBar: AppBar(
        title: const Text(
          "Login",
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 189, 0, 0),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                top: size.height * 0.15,
                right: 20,
              ),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                    width: 20,
                  ),
                  Image.asset(
                    "images/login.png",
                    height: 100,
                    width: 250,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Enter Email",
                      icon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    controller: _emailTextController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Enter Password",
                      icon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                    controller: _passwordTextController,
                    obscureText: true, // Hide the password
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: helper,
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      backgroundColor: Color(0xffAE72FD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: const Size(150, 50),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> doesUserExist(String email) async {
    try {
      // Check if email is already registered
      var methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      // If methods is not empty, a user with this email exists
      return methods.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  void helper() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailTextController.text,
        password: _passwordTextController.text,
      );

      print("User with email ${_emailTextController.text} is logged in");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => page2.MyPage()),
      );
    } on FirebaseAuthException catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Error'),
          content: Text("Error ${error.toString()}"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
