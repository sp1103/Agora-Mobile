// The names are from the Database
// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
part 'legislation.g.dart';

@JsonSerializable()

/// Creates a legislation object that holds all info related to a legislation that is generated via JSON from the 
/// database
/// 
/// * bill_id - Unique id for legislation
/// * bill_num - The number of the bill
/// * bill_name - The name of the bill
/// * summary - The short description of a bill
/// * last_action_date - Date that the bill was updated
/// * fullContent - Full content of the bill
/// * bill_orgin - The goverment level US COngress, Utah Congress, etc.
/// * govLink - Link to gov site
/// * state - State of bill
/// * body_image - Crest of goverment level in URL
/// * interests_arr - Categories it falls in i.e. Citizenship, Voting, etc.
class Legislation {

  final int bill_id;
  final int bill_num; 
  final String bill_name; 
  final String summary; 
  final String last_action_date;
  final String? fullContent;
  final String bill_origin; 
  final String? govLink; 
  final String? state; 
  final String body_image = "https://tse3.mm.bing.net/th/id/OIP.DD5VbC2cx2pSmq6lcr_JaQHaHa?rs=1&pid=ImgDetMain"; 
  final List<String> interests_arr = []; 
  final String type = "legislation"; //Used only for hashing


  //All of this is things required for the JSON
  Legislation({required this.bill_id, required this.bill_num, required this.bill_name, 
  required this.summary, required this.last_action_date, this.fullContent, required this.bill_origin, 
  this.govLink, this.state});

  factory Legislation.fromJSON(Map<String, dynamic> json) => _$LegislationFromJson(json);

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