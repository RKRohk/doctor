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
  Future<String> fetchCondition() async {
    print(widget.patient.symptoms.map((e) => e.ID).toList().toString());
    try {
      var response = await Dio().get(DotEnv().env["API_URL"], queryParameters: {
        "symptoms":
            widget.patient.symptoms.map((e) => e.ID).toList().toString(),
        "gender": widget.patient.gender,
        "year_of_birth": widget.patient.dob.toString(),
        "token": DotEnv().env["key"],
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
                        ? ListView(
                            children: medicines[condition].map((e) {
                              bool value = false;
                              return CheckboxListTile(
                                  value: value,
                                  onChanged: (newVal) {
                                    setState(() {
                                      value = newVal;
                                    });
                                  },
                                  title: Text(e));
                            }).toList(),
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
              onPressed: () {},
              child: Text("Send"),
            )
          ],
        ),
      ),
    );
  }
}
