// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legislation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Legislation _$LegislationFromJson(Map<String, dynamic> json) => Legislation(
      bill_id: (json['bill_id'] as num).toInt(),
      congress: (json['congress'] as num).toInt(),
      intro_date: json['intro_date'] as String,
      number: (json['number'] as num).toInt(),
      sponsors_ids: (json['sponsors_ids'] as List<dynamic>)
          .map((e) => Politician.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String,
      status_update_date: json['status_update_date'] as String,
      summary: json['summary'] as String,
      title: json['title'] as String,
      topics: (json['topics'] as List<dynamic>)
          .map((e) => Topic.fromJson(e as Map<String, dynamic>))
          .toList(),
      type: json['type'] as String,
    );

Map<String, dynamic> _$LegislationToJson(Legislation instance) =>
    <String, dynamic>{
      'bill_id': instance.bill_id,
      'congress': instance.congress,
      'intro_date': instance.intro_date,
      'number': instance.number,
      'sponsors_ids': instance.sponsors_ids,
      'status': instance.status,
      'status_update_date': instance.status_update_date,
      'summary': instance.summary,
      'title': instance.title,
      'topics': instance.topics,
      'type': instance.type,
    };
