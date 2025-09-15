// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'term.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Term _$TermFromJson(Map<String, dynamic> json) => Term(
      chamber: json['chamber'] as String,
      congress: (json['congress'] as num).toInt(),
      start_date: json['start_date'] as String,
      state: json['state'] as String,
      term_id: (json['term_id'] as num).toInt(),
    );

Map<String, dynamic> _$TermToJson(Term instance) => <String, dynamic>{
      'chamber': instance.chamber,
      'congress': instance.congress,
      'start_date': instance.start_date,
      'state': instance.state,
      'term_id': instance.term_id,
    };
