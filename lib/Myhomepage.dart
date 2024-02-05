import 'package:lifeflowapp/AttendeeRegistered.dart';
import 'package:lifeflowapp/form.dart';
import 'package:lifeflowapp/eventlist.dart';
import 'package:flutter/material.dart';
import 'package:lifeflowapp/page2.dart';
import 'package:lifeflowapp/orgreg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  User user = User(userType: 'user', name: 'Your user Name');
  runApp(MaterialApp(home: MyHomePage(user: user)));
}

class MyHomePage extends StatelessWidget {
  final User user;
  MyHomePage({required this.user});

  Future<int> fetchRegistrationCount(String eventName) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('attendeeRegistrations')
          .where('eventName', isEqualTo: eventName)
          .get();
      return querySnapshot.size; // Number of registered attendees
    } catch (e) {
      print("Error fetching registration count: $e");
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> fetchOrganizationEvents() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('org', isEqualTo: user.name)
          .get();
      return querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  TextButton buildRegistrationInfoButton(BuildContext context) {
    return TextButton(
      onPressed: () async {
        if (user.userType == 'Org') {
          // Get the organization's events
          List<Map<String, dynamic>> orgEvents =
              await fetchOrganizationEvents();

          if (orgEvents.isNotEmpty) {
            String eventName = orgEvents[0]['name']; // Assuming the first event
            int registrationCount = await fetchRegistrationCount(eventName);

            // Show the registration info
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text('Registration Info'),
                content: user.userType == 'Org'
                    ? Text(
                        "Congratulations! Your organization's $eventName has $registrationCount registrations.")
                    : Text(
                        "This particular event of your organization has $registrationCount registered attendees."),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text('Error'),
                content: Text('No events available for your organization.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          }
        }
      },
      style: TextButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 182, 23, 23),
        foregroundColor: Colors.white,
      ),
      child: const Text("Show Registration Info",
          style: TextStyle(fontFamily: 'Salsa')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 177, 177),
      appBar: AppBar(
        title: const Text("LifeFlow",
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontFamily: 'Salsa',
              color: Color.fromARGB(255, 255, 255, 255),
            )),
        backgroundColor: Color.fromARGB(255, 179, 13, 13),
        elevation: 10.0,
        shadowColor: Color.fromARGB(255, 223, 8, 73),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/logo.jpeg'),
                fit: BoxFit.cover,
              ),
            )),
            const SizedBox(
              height: 50,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
            ),
            buildRegistrationInfoButton(context),
            const SizedBox(
              height: 50,
            ),
            TextButton(
              onPressed: () {
                // Check if the user is an attendee
                if (user.userType == 'Attendee') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text('Error'),
                      content: Text(
                          'As an attendee, you cannot add events. Only organizations can add events.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Allow organization to add events
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyForm(user: user)));
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 189, 0, 0),
                foregroundColor: Colors.white,
              ),
              child: const Text("Add BloodDonation Camp details",
                  style: TextStyle(fontFamily: 'Salsa')),
            ),
            const SizedBox(
              height: 50,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EventListPage(user: user)));
              },
              style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 189, 0, 0),
                  foregroundColor: Colors.white),
              child: const Text("Show Donation Details",
                  style: TextStyle(
                    fontFamily: 'Salsa',
                  )),
            ),
            const SizedBox(
              height: 50,
            ),
            TextButton(
              onPressed: () {
                if (user.userType == 'Attendee') {
                  // Allow only attendees to view registered events
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AttendeeRegisteredEvents(user: user)),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text('Error'),
                      content: Text(
                          'Only users can view registered events. Organizations cannot view registered events.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 189, 0, 0),
                  foregroundColor: Colors.white),
              child: const Text("View Registered Camps",
                  style: TextStyle(fontFamily: 'Salsa')),
            ),
            const SizedBox(
              height: 50,
            ),
            TextButton(
              onPressed: () {
                if (user.userType == 'Org') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            OrganizationEventsPage(user: user)),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text('Error'),
                      content:
                          Text('Only organizations can view their events.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 189, 0, 0),
                  foregroundColor: Colors.white),
              child: const Text("View Their Events",
                  style: TextStyle(fontFamily: 'Salsa')),
            ),
          ],
        ),
      ),
    );
  }
}
