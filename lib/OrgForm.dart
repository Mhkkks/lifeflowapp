import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeflowapp/page2.dart';
import 'package:flutter/material.dart';
import 'package:lifeflowapp/profile.dart';

void main() {
  User user = User(userType: 'Org', name: 'Your Org Name');
  runApp(MaterialApp(home: OrgForm(user: user)));
}

FirebaseFirestore firestore = FirebaseFirestore.instance;

class OrgForm extends StatefulWidget {
  final User user;

  OrgForm({required this.user});
  @override
  _OrgFormState createState() => _OrgFormState();
}

class _OrgFormState extends State<OrgForm> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _no = TextEditingController();
  final TextEditingController _pc = TextEditingController();
  final TextEditingController _ln = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Check for existing org profile data
    checkExistingProfile();
  }

  Future<void> checkExistingProfile() async {
    try {
      CollectionReference orgCollection = firestore.collection('org users');

      // Check if the org profile already exists
      QuerySnapshot existingProfiles = await orgCollection
          .where('name', isEqualTo: widget.user.name)
          .limit(1)
          .get();

      if (existingProfiles.docs.isNotEmpty) {
        print('Organization profile already exists');

        // Get the existing org profile data
        var existingProfileData = existingProfiles.docs.first.data();

        // Check if the data is not null and is of type Map<String, dynamic>
        if (existingProfileData != null &&
            existingProfileData is Map<String, dynamic>) {
          setState(() {
            // Populate the text controllers with existing data
            _name.text = existingProfileData['name'] ?? '';
            _no.text = existingProfileData['no'] ?? '';
            _pc.text = existingProfileData['pc'] ?? '';
            _ln.text = existingProfileData['ln'] ?? '';
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
        backgroundColor: Color.fromARGB(255, 255, 177, 177),
        appBar: AppBar(
          title: const Text(
            "Organization Details form",
            style: TextStyle(
              fontFamily: 'Salsa',
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          backgroundColor: Color.fromARGB(255, 189, 0, 0),
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
                  labelText: "Contact Number",
                  icon: Icon(Icons.label),
                  border: OutlineInputBorder(),
                ),
                controller: _no,
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
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "License Number",
                  icon: Icon(Icons.label),
                  border: OutlineInputBorder(),
                ),
                controller: _ln,
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: addUser,
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  backgroundColor: Color.fromARGB(255, 189, 0, 0),
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
          _no.text.isEmpty ||
          _ln.text.isEmpty) {
        print("Fill in all the details");
        return;
      }

      CollectionReference eventsCollection = firestore.collection('org users');

      // Check if the org profile already exists
      QuerySnapshot existingProfiles = await eventsCollection
          .where('name', isEqualTo: _name.text)
          .limit(1)
          .get();

      if (existingProfiles.docs.isNotEmpty) {
        print('Organization profile already exists');

        // Get the existing org profile data
        var existingProfileData = existingProfiles.docs.first.data();

        // Check if the data is not null and is of type Map<String, dynamic>
        if (existingProfileData != null &&
            existingProfileData is Map<String, dynamic>) {
          // Redirect to the organization profile screen with existing data
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrganizationProfileScreen(
                name: existingProfileData['name'] ?? '',
                no: existingProfileData['no'] ?? '',
                pc: existingProfileData['pc'] ?? '',
                ln: existingProfileData['ln'] ?? '',
              ),
            ),
          );
        }

        return;
      }

      // Add a new document with an automatically generated ID
      DocumentReference newEventRef = await eventsCollection.add({
        'id': '', // Leave it empty; Firestore will generate a unique ID
        'name': _name.text,
        'ln': _ln.text,
        'no': _no.text,
        'pc': _pc.text,
      });

      // Update the 'id' field with the document ID
      await newEventRef.update({'id': newEventRef.id});

      print('Organization profile created');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrganizationProfileScreen(
            name: _name.text,
            no: _no.text,
            pc: _pc.text,
            ln: _ln.text,
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
  }
}
