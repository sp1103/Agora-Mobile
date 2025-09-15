// The names are from the Database
// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
part 'topic.g.dart';

@JsonSerializable()

/// Creates a topic that holds all topic info that is generated via JSON from the databse
/// 
/// * topic_id - Number repersenting the topic id
/// * topic_name - String with topic name
class Topic {
  final int topic_id;
  final String topic_name;
  final String type = "topic";

  //All of this is things required for the JSON Converter
  Topic({required this.topic_id, required this.topic_name});

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);

  Map<String, dynamic> toJson() => _$TopicToJson(this);

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other is Topic && runtimeType == other.runtimeType && topic_id == other.topic_id);
  }

  @override
  int get hashCode => Object.hash(type, topic_id);
}