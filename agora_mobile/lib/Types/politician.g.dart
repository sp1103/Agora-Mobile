// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'politician.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Politician _$PoliticianFromJson(Map<String, dynamic> json) => Politician(
      pID: (json['pID'] as num).toInt(),
      p_name: json['p_name'] as String,
      leadership: json['leadership'] as String,
      leg_image_path: json['leg_image_path'] as String?,
      gov_body_image: json['gov_body_image'] as String?,
    );

Map<String, dynamic> _$PoliticianToJson(Politician instance) =>
    <String, dynamic>{
      'pID': instance.pID,
      'p_name': instance.p_name,
      'leadership': instance.leadership,
      'leg_image_path': instance.leg_image_path,
      'gov_body_image': instance.gov_body_image,
    };
