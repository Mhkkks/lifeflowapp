import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeflowapp/page2.dart';
import 'package:flutter/material.dart';
import 'package:lifeflowapp/profile.dart';

void main() {
  User user = User(userType: 'Attendee', name: 'Your Attendee Name');
  runApp(MaterialApp(home: AttendeeForm(user: user)));
  //runApp(MaterialApp(home: AttendeeForm()));
}

FirebaseFirestore firestore = FirebaseFirestore.instance;

class AttendeeForm extends StatefulWidget {
  final User user;
  AttendeeForm({required this.user});
  @override
  _AttendeeFormState createState() => _AttendeeFormState();
}

class _AttendeeFormState extends State<AttendeeForm> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _pn = TextEditingController();
  final TextEditingController _bg = TextEditingController();
  final TextEditingController _pc = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Check for existing attendee profile data
    checkExistingProfile();
  }

  Future<void> checkExistingProfile() async {
    try {
      CollectionReference attendeeCollection =
          firestore.collection('attendee users');

      // Check if the attendee profile already exists
      QuerySnapshot existingProfiles = await attendeeCollection
          .where('name', isEqualTo: widget.user.name)
          .limit(1)
          .get();

      if (existingProfiles.docs.isNotEmpty) {
        print('Attendee profile already exists');

        var existingProfileData = existingProfiles.docs.first.data();

        // Check if the data is not null and is of type Map<String, dynamic>
        if (existingProfileData != null &&
            existingProfileData is Map<String, dynamic>) {
          setState(() {
            _name.text = existingProfileData['name'] ?? '';
            _pn.text = existingProfileData['pn'] ?? '';
            _pc.text = existingProfileData['pc'] ?? '';
            _bg.text = existingProfileData['bg'] ?? '';
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Attendee Form",
            style: TextStyle(
              fontFamily: 'Salsa',
              color: Colors.white70,
            ),
          ),
          backgroundColor: Color(0xff9B61BD),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Name",
                  icon: Icon(Icons.label),
                  border: OutlineInputBorder(),
                ),
                controller: _name,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Contact No",
                  icon: Icon(Icons.label),
                  border: OutlineInputBorder(),
                ),
                controller: _pc,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Blood Group",
                  icon: Icon(Icons.label),
                  border: OutlineInputBorder(),
                ),
                controller: _bg,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "PinCode",
                  icon: Icon(Icons.label),
                  border: OutlineInputBorder(),
                ),
                controller: _pc,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: addUser,
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  backgroundColor: Color(0xffAE72FD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size(150, 50),
                ),
                child: const Text(
                  "Create Profile",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void addUser() async {
    try {
      if (_name.text.isEmpty ||
          _pc.text.isEmpty ||
          _bg.text.isEmpty ||
          _pn.text.isEmpty) {
        print("Fill in all the details");
        return;
      }

      CollectionReference eventsCollection =
          firestore.collection('attendee users');

      QuerySnapshot existingProfiles = await eventsCollection
          .where('name', isEqualTo: _name.text)
          .limit(1)
          .get();

      if (existingProfiles.docs.isNotEmpty) {
        print('Attendee profile already exists');

        var existingProfileData = existingProfiles.docs.first.data();

        // Check if the data is not null and is of type Map<String, dynamic>
        if (existingProfileData != null &&
            existingProfileData is Map<String, dynamic>) {
          // Redirect to attendee profile screen with existing data
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AttendeeProfileScreen(
                name: existingProfileData['name'] ?? '',
                pc: existingProfileData['pc'] ?? '',
                bg: existingProfileData['bg'] ?? '',
                pn: existingProfileData['pn'] ?? '',
              ),
            ),
          );
        }
        return;
      }

      // Add a new document with an automatically generated ID
      DocumentReference newEventRef = await eventsCollection.add({
        'id': '', //Firestore will generate a unique ID
        'name': _name.text,
        'pn': _pn.text,
        'bg': _bg.text,
        'pc': _pc.text,
      });

      // Update the 'id' field with the document ID
      await newEventRef.update({'id': newEventRef.id});

      print('Attendee profile created');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AttendeeProfileScreen(
            name: _name.text,
            pn: _pn.text,
            bg: _bg.text,
            pc: _pc.text,
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
  }
}
