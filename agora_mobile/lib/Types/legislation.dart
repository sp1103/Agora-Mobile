import 'package:json_annotation/json_annotation.dart';
part 'legislation.g.dart';

@JsonSerializable()
class Legislation {

  final int legislationID; //Unique id for legislation
  final String billNumber; //The number of the bill
  final String name; //The name of the bill
  final String shortDescription; //The short description of a bill about 1 sentence
  final DateTime date; //Date that the bill was updated 
  final String? fullContent; //Full content of the bill
  final String govLevel; //The goverment level US COngress, Utah Congress, etc. 
  final String govLink; //Link to gov site
  final String state; //State of bill
  final String image; //Crest of goverment level in URL
  final List<String> issueCategories; //Categories it falls in i.e. Citizenship, Voting, etc. 
  final String type = "legislation";

  Legislation({required this.legislationID, required this.billNumber, required this.name, 
  required this.shortDescription, required this.date, required this.fullContent, required this.govLevel, 
  required this.govLink, required this.state, required this.image, required this.issueCategories});

  factory Legislation.fromJSON(Map<String, dynamic> json) => _$LegislationFromJson(json);

  Map<String, dynamic> toJson() => _$LegislationToJson(this);

}