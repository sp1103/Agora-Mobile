// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'politician.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Politician _$PoliticianFromJson(Map<String, dynamic> json) => Politician(
      politicianID: (json['politicianID'] as num).toInt(),
      name: json['name'] as String,
      role: json['role'] as String,
      imageLink: json['imageLink'] as String,
      sealLink: json['sealLink'] as String,
      shortBio: json['shortBio'] as String,
      state: json['state'] as String,
    );

Map<String, dynamic> _$PoliticianToJson(Politician instance) =>
    <String, dynamic>{
      'politicianID': instance.politicianID,
      'name': instance.name,
      'role': instance.role,
      'imageLink': instance.imageLink,
      'sealLink': instance.sealLink,
      'shortBio': instance.shortBio,
      'state': instance.state,
    };
