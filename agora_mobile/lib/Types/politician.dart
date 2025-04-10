import 'package:json_annotation/json_annotation.dart';
part 'politician.g.dart';

@JsonSerializable()
class Politician {

  final int politicianID;
  final String name;
  final String role;
  final String imageLink;
  final String sealLink;
  final String shortBio;
  final String state;
  final String type = "politician";

  Politician({required this.politicianID, required this.name, required this.role, required this.imageLink, required this.sealLink, required this.shortBio, required this.state});

  factory Politician.fromJSON(Map<String, dynamic> json) => _$PoliticianFromJson(json);

  Map<String, dynamic> toJson() => _$PoliticianToJson(this);

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other is Politician && runtimeType == other.runtimeType && politicianID == other.politicianID);
  }

  @override
  int get hashCode => Object.hash(runtimeType, politicianID);
}