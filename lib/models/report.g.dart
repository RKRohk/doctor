// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String, dynamic> json) {
  return Report(
    filename: json['filename'] as String,
    title: json['title'] as String,
    url: json['url'] as String,
  );
}

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'filename': instance.filename,
      'title': instance.title,
      'url': instance.url,
    };
