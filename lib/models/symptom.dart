import 'package:json_annotation/json_annotation.dart';

part 'symptom.g.dart';

@JsonSerializable(explicitToJson: true)
class Symptom {
  int ID;
  String Name;
  Symptom({this.ID, this.Name});

  factory Symptom.fromJson(Map<String, dynamic> json) =>
      _$SymptomFromJson(json);

  Map<String, dynamic> toJson() => _$SymptomToJson(this);
}
