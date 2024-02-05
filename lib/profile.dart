import 'package:lifeflowapp/Myhomepage.dart';
import 'package:flutter/material.dart';
import 'package:lifeflowapp/page2.dart' as page2;

class AttendeeProfileScreen extends StatelessWidget {
  final String name;
  final String pn;
  final String bg;
  final String pc;

  AttendeeProfileScreen({
    required this.name,
    required this.pn,
    required this.bg,
    required this.pc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Attendee Profile',
          style: TextStyle(
            fontFamily: 'Salsa',
          ),
        ),
        backgroundColor: Color(0xff9B61BD),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  top: 120,
                  right: 20,
                ),
              ),

              SizedBox(height: 20),
              // Profile Information
              Text('Name: $name',
                  style: TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(111, 20, 128, 0.8),
                      fontFamily: 'Salsa',
                      fontWeight: FontWeight.w600)),
              const SizedBox(
                height: 20,
              ),
              Text('pn: $pn',
                  style: TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(111, 20, 128, 0.8),
                      fontFamily: 'Salsa',
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w600)),
              const SizedBox(
                height: 20,
              ),
              Text('bg: $bg',
                  style: TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(111, 20, 128, 0.8),
                      fontFamily: 'Salsa',
                      fontWeight: FontWeight.w600)),
              const SizedBox(
                height: 20,
              ),
              Text('pc: $pc',
                  style: TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(111, 20, 128, 0.8),
                      fontFamily: 'Salsa',
                      fontWeight: FontWeight.w600)),
              // Add other profile information based on user type
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(
                          user: page2.User(userType: 'Attendee', name: name)),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Go to Home",
                    style: TextStyle(fontFamily: 'Salsa')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrganizationProfileScreen extends StatelessWidget {
  final String name;
  final String no;
  final String pc;
  final String ln;

  OrganizationProfileScreen({
    required this.name,
    required this.no,
    required this.pc,
    required this.ln,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Organization Profile',
          style: TextStyle(
            fontFamily: 'Salsa',
          ),
        ),
        backgroundColor: Color(0xff9B61BD),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  top: 120,
                  right: 20,
                ),
              ),

              SizedBox(height: 20),
              // Profile Info
              Text('Name: $name',
                  style: TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(111, 20, 128, 0.8),
                      fontFamily: 'Salsa',
                      fontWeight: FontWeight.w600)),
              const SizedBox(
                height: 20,
              ),
              Text('no: $no',
                  style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 189, 0, 0),
                      fontFamily: 'Salsa',
                      fontWeight: FontWeight.w600)),
              const SizedBox(
                height: 20,
              ),
              Text('pc: $pc',
                  style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 189, 0, 0),
                      fontFamily: 'Salsa',
                      fontWeight: FontWeight.w600)),
              const SizedBox(
                height: 20,
              ),
              Text('ln: $ln',
                  style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 189, 0, 0),
                      fontFamily: 'Salsa',
                      fontWeight: FontWeight.w600)),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(
                          user: page2.User(userType: 'Org', name: name)),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Go to Home",
                    style: TextStyle(fontFamily: 'Salsa')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
