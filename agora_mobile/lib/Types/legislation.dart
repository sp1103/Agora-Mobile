import 'package:json_annotation/json_annotation.dart';
part 'legislation.g.dart';

@JsonSerializable()
class Legislation {

  final int bill_id; //Unique id for legislation
  final int bill_num; //The number of the bill
  final String bill_name; //The name of the bill
  final String summary; //The short description of a bill about 1 sentence
  final String last_action_date; //Date that the bill was updated 
  final String? fullContent; //Full content of the bill
  final String body; //The goverment level US COngress, Utah Congress, etc. 
  final String? govLink; //Link to gov site
  final String? state; //State of bill
  final String body_image = "https://tse3.mm.bing.net/th/id/OIP.DD5VbC2cx2pSmq6lcr_JaQHaHa?rs=1&pid=ImgDetMain"; //Crest of goverment level in URL
  final List<String> interests_arr = []; //Categories it falls in i.e. Citizenship, Voting, etc. 
  final String type = "legislation";

  Legislation({required this.bill_id, required this.bill_num, required this.bill_name, 
  required this.summary, required this.last_action_date, this.fullContent, required this.body, 
  this.govLink, this.state});

  factory Legislation.fromJSON(Map<String, dynamic> json) => _$LegislationFromJson(json);

  Map<String, dynamic> toJson() => _$LegislationToJson(this);

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other is Legislation && runtimeType == other.runtimeType && bill_id == other.bill_id);
  }

  @override
  int get hashCode => Object.hash(runtimeType, bill_id);

}