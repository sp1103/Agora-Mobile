// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legislation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Legislation _$LegislationFromJson(Map<String, dynamic> json) => Legislation(
      legislationID: (json['legislationID'] as num).toInt(),
      billNumber: json['billNumber'] as String,
      name: json['name'] as String,
      shortDescription: json['shortDescription'] as String,
      date: DateTime.parse(json['date'] as String),
      fullContent: json['fullContent'] as String?,
      govLevel: json['govLevel'] as String,
      govLink: json['govLink'] as String,
      state: json['state'] as String,
      image: json['image'] as String,
      issueCategories: (json['issueCategories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$LegislationToJson(Legislation instance) =>
    <String, dynamic>{
      'legislationID': instance.legislationID,
      'billNumber': instance.billNumber,
      'name': instance.name,
      'shortDescription': instance.shortDescription,
      'date': instance.date.toIso8601String(),
      'fullContent': instance.fullContent,
      'govLevel': instance.govLevel,
      'govLink': instance.govLink,
      'state': instance.state,
      'image': instance.image,
      'issueCategories': instance.issueCategories,
    };
