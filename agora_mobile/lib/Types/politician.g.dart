// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'politician.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Politician _$PoliticianFromJson(Map<String, dynamic> json) => Politician(
      bio_id: json['bio_id'] as String,
      chamber: json['chamber'] as String,
      congress: (json['congress'] as num).toInt(),
      current_title: json['current_title'] as String,
      district: (json['district'] as num).toInt(),
      image_url: json['image_url'] as String?,
      name: json['name'] as String,
      party: json['party'] as String,
      start_date: json['start_date'] as String,
      state: json['state'] as String,
      terms_served: (json['terms_served'] as List<dynamic>)
          .map((e) => Term.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PoliticianToJson(Politician instance) =>
    <String, dynamic>{
      'bio_id': instance.bio_id,
      'chamber': instance.chamber,
      'congress': instance.congress,
      'current_title': instance.current_title,
      'district': instance.district,
      'image_url': instance.image_url,
      'name': instance.name,
      'party': instance.party,
      'start_date': instance.start_date,
      'state': instance.state,
      'terms_served': instance.terms_served,
    };
