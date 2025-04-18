// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legislation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Legislation _$LegislationFromJson(Map<String, dynamic> json) => Legislation(
      bill_id: (json['bill_id'] as num).toInt(),
      bill_num: (json['bill_num'] as num).toInt(),
      bill_name: json['bill_name'] as String,
      summary: json['summary'] as String,
      last_action_date: json['last_action_date'] as String,
      fullContent: json['fullContent'] as String?,
      bill_origin: json['bill_origin'] as String,
      govLink: json['govLink'] as String?,
      state: json['state'] as String?,
    );

Map<String, dynamic> _$LegislationToJson(Legislation instance) =>
    <String, dynamic>{
      'bill_id': instance.bill_id,
      'bill_num': instance.bill_num,
      'bill_name': instance.bill_name,
      'summary': instance.summary,
      'last_action_date': instance.last_action_date,
      'fullContent': instance.fullContent,
      'bill_origin': instance.bill_origin,
      'govLink': instance.govLink,
      'state': instance.state,
    };
