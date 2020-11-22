import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/models/report.dart';
import 'package:doctor/models/symptom.dart';
import 'package:json_annotation/json_annotation.dart';

part 'patient.g.dart';

@JsonSerializable(explicitToJson: true)
class Patient {
  static toDateTime(Timestamp value) {
    return (value).toDate();
  }

  @JsonKey(fromJson: toDateTime)
  DateTime dob;

  String gender;
  String name;
  List<Report> reports;
  List<Symptom> symptoms;
  Patient({this.dob, this.gender, this.name, this.reports, this.symptoms});

  factory Patient.fromJson(Map<String, dynamic> json) =>
      _$PatientFromJson(json);

  Map<String, dynamic> toJson() => _$PatientToJson(this);
}
