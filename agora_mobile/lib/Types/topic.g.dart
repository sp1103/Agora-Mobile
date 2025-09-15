// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Topic _$TopicFromJson(Map<String, dynamic> json) => Topic(
      topic_id: (json['topic_id'] as num).toInt(),
      topic_name: json['topic_name'] as String,
    );

Map<String, dynamic> _$TopicToJson(Topic instance) => <String, dynamic>{
      'topic_id': instance.topic_id,
      'topic_name': instance.topic_name,
    };
