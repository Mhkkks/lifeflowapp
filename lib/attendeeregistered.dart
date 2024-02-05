import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeflowapp/page2.dart';

class AttendeeRegisteredEvents extends StatefulWidget {
  final User user;

  AttendeeRegisteredEvents({required this.user});

  @override
  _AttendeeRegisteredEventsState createState() =>
      _AttendeeRegisteredEventsState();
}

class _AttendeeRegisteredEventsState extends State<AttendeeRegisteredEvents> {
  late Future<List<Map<String, dynamic>>> registeredEvents;

  @override
  void initState() {
    super.initState();
    registeredEvents = fetchRegisteredEvents();
  }

  Future<List<Map<String, dynamic>>> fetchRegisteredEvents() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('attendeeRegistrations')
          .where('attendeeName', isEqualTo: widget.user.name)
          .get();
      return querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registered Events",
            style: TextStyle(fontFamily: 'Salsa', color: Colors.white70)),
        backgroundColor: Color(0xff9B61BD),
      ),
      body: Container(
        child: Center(
          child: Stack(
            children: [
              FutureBuilder<List<Map<String, dynamic>>>(
                future: registeredEvents,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text("There is some error fetching the data"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No events are registered"));
                  } else {
                    print(snapshot.data!);
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var registration = snapshot.data![index];
                        return Card(
                          elevation: 5,
                          margin: EdgeInsets.all(8.0),
                          color: Color(0xffF5ECCD),
                          child: ListTile(
                            title: Text(
                              "Event: ${registration['eventName']}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff4C2A85)),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("bg: ${registration['bg']}"),
                                Text("pn: ${registration['pn']}"),
                                Text("pc: ${registration['pc']}"),
                                Text(
                                    "How Did You Know: ${registration['howDidYouKnow']}"),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
