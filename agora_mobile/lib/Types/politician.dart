import 'package:json_annotation/json_annotation.dart';
part 'politician.g.dart';

@JsonSerializable()
class Politician {

  final int politicianID;
  final String name;
  final String imageLink;
  final String state;
  final String office;

  Politician({required this.politicianID, required this.name, required this.imageLink, required this.state, required this.office});

  factory Politician.fromJSON(Map<String, dynamic> json) => _$PoliticianFromJson(json);

  Map<String, dynamic> toJson() => _$PoliticianToJson(this);
}