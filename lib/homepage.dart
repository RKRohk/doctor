import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/diagnosis.dart';
import 'package:doctor/models/patient.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Patients"),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection("details").snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return CircularProgressIndicator();
              else {
                List<Patient> patients = snapshot.data.documents
                    .map<Patient>((e) => Patient.fromJson(e.data()))
                    .toList();

                return ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(patients[index].name),
                      subtitle: Text(patients[index].gender),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Diagnosis(
                                      patient: patients[index],
                                    )));
                      },
                    );
                  },
                  itemCount: patients.length,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
