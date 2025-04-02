// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'politician.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Politician _$PoliticianFromJson(Map<String, dynamic> json) => Politician(
      politicianID: (json['politicianID'] as num).toInt(),
      name: json['name'] as String,
      imageLink: json['imageLink'] as String,
      state: json['state'] as String,
      office: json['office'] as String,
    );

Map<String, dynamic> _$PoliticianToJson(Politician instance) =>
    <String, dynamic>{
      'politicianID': instance.politicianID,
      'name': instance.name,
      'imageLink': instance.imageLink,
      'state': instance.state,
      'office': instance.office,
    };
