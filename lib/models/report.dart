import 'package:json_annotation/json_annotation.dart';

part 'report.g.dart';

@JsonSerializable(explicitToJson: true)
class Report {
  String filename;
  String title;
  String url;

  Report({this.filename, this.title, this.url});

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);

  Map<String, dynamic> toJson() => _$ReportToJson(this);
}
