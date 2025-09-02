// The names are from the Database
// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
part 'politician.g.dart';

@JsonSerializable()

/// Creates a poltician object that holds all info related to a politician that is generated via JSON from the 
/// database
/// 
///  * pID - ID# of the politician
///  * p_name - the politician name
///  * leadership - position in government
///  * leg_image_path - URL to image of politician
///  * gov_body_image - Crest of goverment level in URL
///  * summary - Info about the politician 
class Politician {

  final int pID;
  final String p_name;
  final String leadership;
  final String? leg_image_path;
  final String? gov_body_image;
  final String summary = "A Politician";
  final String type = "politician";


  //All of this is things required for the JSON Converter
  Politician({required this.pID, required this.p_name, required this.leadership, required this.leg_image_path, required this.gov_body_image});

  factory Politician.fromJSON(Map<String, dynamic> json) => _$PoliticianFromJson(json);

  Map<String, dynamic> toJson() => _$PoliticianToJson(this);

  /// Returns true if two politicians are the same item
  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other is Politician && runtimeType == other.runtimeType && pID == other.pID);
  }

  /// Returns an int for the hash code of a politician object
  @override
  int get hashCode => Object.hash(runtimeType, pID);
}