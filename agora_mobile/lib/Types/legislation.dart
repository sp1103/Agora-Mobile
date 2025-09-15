// The names are from the Database
// ignore_for_file: non_constant_identifier_names

import 'package:agora_mobile/Types/politician.dart';
import 'package:agora_mobile/Types/topic.dart';
import 'package:json_annotation/json_annotation.dart';
part 'legislation.g.dart';

@JsonSerializable()

/// Creates a legislation object that holds all info related to a legislation that is generated via JSON from the 
/// database
/// 
/// * bill_id - Unique id for legislation
/// * congress - session of congress
/// * intro_date - date the bill was introduced
/// * number - The number of the bill
/// * stautus - Status of bill
/// * status_update_date - Date that the bill was updated
/// * summary - The short description of a bill
/// * title - The name of the bill
/// * type - The goverment level US COngress, Utah Congress, etc.
class Legislation {

  final int bill_id;
  final int congress;
  final String intro_date;
  final int number; 
  final List<Politician> sponsors_ids; 
  final String status; 
  final String status_update_date;
  final String summary; 
  final String title; 
  final List<Topic> topics;
  final String type;
  final String hashType = "legislation"; //Used only for hashing


  //All of this is things required for the JSON
  Legislation({required this.bill_id, required this.congress, required this.intro_date, 
  required this.number, required this.sponsors_ids, required this.status, required this.status_update_date, 
  required this.summary, required this.title, required this.topics, required this.type});

  factory Legislation.fromJson(Map<String, dynamic> json) => _$LegislationFromJson(json);

  Map<String, dynamic> toJson() => _$LegislationToJson(this);

  /// Returns true if two legislation object are the same item
  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other is Legislation && runtimeType == other.runtimeType && bill_id == other.bill_id);
  }

  /// Returns an int for the hash code of a legislation object
  @override
  int get hashCode => Object.hash(runtimeType, bill_id);

}