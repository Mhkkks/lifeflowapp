import 'package:lifeflowapp/OrgForm.dart';
import 'package:lifeflowapp/attendeeform.dart';
import 'package:lifeflowapp/signup.dart';
import 'package:flutter/material.dart';

class User {
  final String userType;
  final String name;

  User({required this.userType, required this.name});
}

class ProfileScreen extends StatelessWidget {
  final User user;

  ProfileScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Profile',
          style: TextStyle(
            fontFamily: 'Salsa',
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Name: ${user.name}'),
            Text('User Type: ${user.userType}'),
          ],
        ),
      ),
    );
  }
}

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserTypeSelectionScreen(),
    );
  }
}

class UserTypeSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 177, 177),
      appBar: AppBar(
        title: Text(
          'Select User Type',
          style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: Color.fromARGB(255, 189, 0, 0),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Center(
            child: Column(
              children: [
                const Icon(
                  (Icons.account_box),
                  size: 150,
                  color: Color.fromARGB(255, 189, 0, 0),
                ),
                ElevatedButton(
                  onPressed: () {
                    _navigateToProfile(
                        context,
                        User(
                            userType: 'Organization',
                            name: 'Organization Name'));
                  },
                  child: Text(
                    'Organization',
                    style: TextStyle(
                      color: Color.fromARGB(255, 189, 0, 0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                  width: 50,
                ),
                const Icon(
                  (Icons.account_balance),
                  size: 150,
                  color: Color.fromARGB(255, 189, 0, 0),
                ),
                ElevatedButton(
                  onPressed: () {
                    _navigateToProfile(context,
                        User(userType: 'Attendee', name: 'Attendee Name'));
                  },
                  child: Text(
                    'User',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 189, 0, 0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToProfile(BuildContext context, User user) {
    if (user.userType == 'Organization') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrgForm(user: user)),
      );
    } else if (user.userType == 'Attendee') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AttendeeForm(user: user)),
      );
    }
  }
}

void main() {
  runApp(MyPage());
}
