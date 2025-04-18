import 'package:json_annotation/json_annotation.dart';
part 'politician.g.dart';

@JsonSerializable()
class Politician {

  final int pID;
  final String p_name;
  final String leadership;
  final String leg_image_path;
  final String gov_body_image = "https://tse3.mm.bing.net/th/id/OIP.DD5VbC2cx2pSmq6lcr_JaQHaHa?rs=1&pid=ImgDetMain";
  final String summary = "A Politician";
  final String type = "politician";

  Politician({required this.pID, required this.p_name, required this.leadership, required this.leg_image_path});

  factory Politician.fromJSON(Map<String, dynamic> json) => _$PoliticianFromJson(json);

  Map<String, dynamic> toJson() => _$PoliticianToJson(this);

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other is Politician && runtimeType == other.runtimeType && pID == other.pID);
  }

  @override
  int get hashCode => Object.hash(runtimeType, pID);
}