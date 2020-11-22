// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Patient _$PatientFromJson(Map<String, dynamic> json) {
  return Patient(
    dob: Patient.toDateTime(json['dob'] as Timestamp),
    gender: json['gender'] as String,
    name: json['name'] as String,
    reports: (json['reports'] as List)
        ?.map((e) =>
            e == null ? null : Report.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    symptoms: (json['symptoms'] as List)
        ?.map((e) =>
            e == null ? null : Symptom.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PatientToJson(Patient instance) => <String, dynamic>{
      'dob': instance.dob?.toIso8601String(),
      'gender': instance.gender,
      'name': instance.name,
      'reports': instance.reports?.map((e) => e?.toJson())?.toList(),
      'symptoms': instance.symptoms?.map((e) => e?.toJson())?.toList(),
    };
