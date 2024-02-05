import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeflowapp/page2.dart';

class RegistrationPage extends StatefulWidget {
  final Map<String, dynamic> eventData;
  final User user;

  RegistrationPage({required this.eventData, required this.user});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late TextEditingController nameController;
  late TextEditingController bgController;
  late TextEditingController pcController;
  late TextEditingController pnController;
  late TextEditingController howDidYouKnowController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    bgController = TextEditingController();
    pcController = TextEditingController();
    pnController = TextEditingController();
    howDidYouKnowController = TextEditingController();
  }

  void checkRegistration() async {
    // Check if the attendee has already registered for the event
    var registrationQuery = await FirebaseFirestore.instance
        .collection('attendeeRegistrations')
        .where('eventName', isEqualTo: widget.eventData['name'])
        .where('attendeeName', isEqualTo: nameController.text)
        .get();

    if (registrationQuery.docs.isNotEmpty) {
      // Attendee has already registered
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Already Registered'),
          content: Text('You have already registered for this event.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Proceed with registration
      register();
    }
  }

  void register() async {
    try {
      if (nameController.text.isEmpty ||
          bgController.text.isEmpty ||
          pnController.text.isEmpty ||
          howDidYouKnowController.text.isEmpty ||
          pcController.text.isEmpty) {
        print("Fill in all the details");
        return;
      }
      // Create a new document in the attendeeRegistrations collection
      await FirebaseFirestore.instance.collection('attendeeRegistrations').add({
        'eventName': widget.eventData['name'],
        'attendeeName': nameController.text,
        'bg': bgController.text,
        'pc': pcController.text,
        'pn': pnController.text,
        'howDidYouKnow': howDidYouKnowController.text,
      });

      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Registration Successful'),
          content: Text('Thanks for registering!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error during registration: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration",
            style: TextStyle(fontFamily: 'Salsa', color: Colors.white70)),
        backgroundColor: Color(0xff9B61BD),
      ),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Name",
                    icon: Icon(Icons.label),
                    border: OutlineInputBorder(),
                  ),
                  controller: nameController,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "pn",
                    icon: Icon(Icons.label),
                    border: OutlineInputBorder(),
                  ),
                  controller: pnController,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Blood Group",
                    icon: Icon(Icons.label),
                    border: OutlineInputBorder(),
                  ),
                  controller: bgController,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "PinCode",
                    icon: Icon(Icons.label),
                    border: OutlineInputBorder(),
                  ),
                  controller: pcController,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'How did you know about this event?',
                    icon: Icon(Icons.label),
                    border: OutlineInputBorder(),
                  ),
                  controller: howDidYouKnowController,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: checkRegistration,
                  //register,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurpleAccent,
                    onPrimary: Colors.white,
                  ),
                  child: Text('Register',
                      style:
                          TextStyle(fontFamily: 'Salsa', color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
