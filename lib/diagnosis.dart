import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:doctor/models/medication.dart';
import 'package:doctor/models/patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Diagnosis extends StatefulHookWidget {
  final Patient patient;

  const Diagnosis({this.patient});

  @override
  _DiagnosisState createState() => _DiagnosisState();
}

class _DiagnosisState extends State<Diagnosis> {
  Future<void> sendDiagnosis() async {
    var selectedMedication = List<String>();
    choice.asMap().forEach((key, value) {
      if (value) selectedMedication.add(medicines[condition][key]);
    });
    var update = {"diagnosis": condition, "medication": selectedMedication};
    var userDoc = await FirebaseFirestore.instance
        .collection("details")
        .where("name", isEqualTo: widget.patient.name)
        .get();
    await FirebaseFirestore.instance
        .collection("details")
        .doc(userDoc.docs.first.id)
        .update(update);
  }

  Future<String> fetchCondition() async {
    print(widget.patient.symptoms.map((e) => e.ID).toList().toString());
    try {
      var response = await Dio().get(DotEnv().env["API_URL"], queryParameters: {
        "symptoms": "[9,10]",
        // widget.patient.symptoms.map((e) => e.ID).toList().toString(),
        "gender": widget.patient.gender,
        "year_of_birth": "2000",
        // "token": DotEnv().env["key"],
        "token":
            "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6InJrYWthcjIwMDBAZ21haWwuY29tIiwicm9sZSI6IlVzZXIiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9zaWQiOiI1NTI3IiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy92ZXJzaW9uIjoiMTA5IiwiaHR0cDovL2V4YW1wbGUub3JnL2NsYWltcy9saW1pdCI6IjEwMCIsImh0dHA6Ly9leGFtcGxlLm9yZy9jbGFpbXMvbWVtYmVyc2hpcCI6IkJhc2ljIiwiaHR0cDovL2V4YW1wbGUub3JnL2NsYWltcy9sYW5ndWFnZSI6ImVuLWdiIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9leHBpcmF0aW9uIjoiMjA5OS0xMi0zMSIsImh0dHA6Ly9leGFtcGxlLm9yZy9jbGFpbXMvbWVtYmVyc2hpcHN0YXJ0IjoiMjAyMC0xMS0yMCIsImlzcyI6Imh0dHBzOi8vYXV0aHNlcnZpY2UucHJpYWlkLmNoIiwiYXVkIjoiaHR0cHM6Ly9oZWFsdGhzZXJ2aWNlLnByaWFpZC5jaCIsImV4cCI6MTYwNjYwMjYzMSwibmJmIjoxNjA2NTk1NDMxfQ.Nd-_sc0q59Ff4Hk4utfHsEb1WZ2IcnwJA-J09l3FIds",
        "format": "json",
        "language": "en-gb"
      });
      print(response.statusMessage);
      print(response.data);
      return response.data[0]["Issue"]["Name"];
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        // print(e.response.headers);
        print(e.response.request.uri);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
    return "OK";
  }

  String condition = "";

  List<bool> choice;

  getCondition() async {
    String res = await fetchCondition();
    setState(() {
      condition = res;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getCondition();
    choice = List<bool>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Diagnosis")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Name: ${widget.patient.name}\n" ?? "",
              style: TextStyle(fontWeight: FontWeight.w400),
              textScaleFactor: 2,
            ),
            Text(
              "Born : ${widget.patient.dob.year}",
              textScaleFactor: 1.5,
            ),
            Text("Symptoms"),
            ...widget.patient.symptoms.map((e) {
              return ListTile(
                title: Text(e.Name),
              );
            }).toList(),
            Expanded(
                child: Container(
              child: Column(
                children: [
                  Text(
                    "Diagnosis: ${condition}",
                    textScaleFactor: 1.2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Suggested Medication"),
                  Expanded(
                    child: medicines.containsKey(condition)
                        ? ListView.builder(
                            itemBuilder: (context, index) {
                              choice.add(false);
                              bool value = choice[index];
                              return CheckboxListTile(
                                  value: value,
                                  onChanged: (newVal) {
                                    setState(() {
                                      choice[index] = newVal;
                                    });
                                  },
                                  title: Text(medicines[condition][index]));
                            },
                            itemCount: medicines[condition].length,
                          )
                        : Container(),
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: "Doctor's remarks"),
                  )
                ],
              ),
            )),
            RaisedButton(
              onPressed: () async {
                sendDiagnosis();
              },
              child: Text("Send"),
            )
          ],
        ),
      ),
    );
  }
}
