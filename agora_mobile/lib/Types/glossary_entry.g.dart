// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glossary_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GlossaryEntry _$GlossaryEntryFromJson(Map<String, dynamic> json) =>
    GlossaryEntry(
      term: json['term'] as String,
      definition: json['definition'] as String,
    );

Map<String, dynamic> _$GlossaryEntryToJson(GlossaryEntry instance) =>
    <String, dynamic>{
      'term': instance.term,
      'definition': instance.definition,
    };
