// The names are from the Database
// ignore_for_file: non_constant_identifier_names

import 'package:agora_mobile/Types/term.dart';
import 'package:json_annotation/json_annotation.dart';
part 'politician.g.dart';

@JsonSerializable()

/// Creates a poltician object that holds all info related to a politician that is generated via JSON from the 
/// database
/// 
///  * bio_id - ID# of the politician
///  * chamber - position in government
///  * congress - session of congress
///  * current_title - current leadership role
///  * district - the district they repersent
///  * img_url - URL to image of politician
///  * name - the politician name
///  * party - their party
///  * starte_date - date they started
///  * state - state they repersent
class Politician {

  final String bio_id;
  final String? bio_text;
  final String chamber;
  // Comitties
  final int congress;
  final String current_title;
  final int district;
  final String? image_url;
  final String name;
  final String party;
  final String start_date;
  final String state;
  final List<Term> terms_served; 
  final String type = "politician";


  //All of this is things required for the JSON Converter
  Politician({required this.bio_id, this.bio_text, required this.chamber, required this.congress, required this.current_title, 
  required this.district, this.image_url, required this.name, required this.party, required this.start_date,
  required this.state, required this.terms_served});

  factory Politician.fromJson(Map<String, dynamic> json) => _$PoliticianFromJson(json);

  Map<String, dynamic> toJson() => _$PoliticianToJson(this);

  /// Returns true if two politicians are the same item
  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other is Politician && runtimeType == other.runtimeType && bio_id == other.bio_id);
  }

  /// Returns an int for the hash code of a politician object
  @override
  int get hashCode => Object.hash(runtimeType, bio_id);
}