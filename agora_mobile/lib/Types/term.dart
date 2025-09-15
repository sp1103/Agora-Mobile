// The names are from the Database
// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
part 'term.g.dart';

@JsonSerializable()

class Term {

  final String chamber;
  final int congress;
  final String start_date; 
  final String state;
  final int term_id;
  final String type = "term";

  Term({required this.chamber, required this.congress, required this.start_date, 
  required this.state, required this.term_id});

  factory Term.fromJson(Map<String, dynamic> json) => _$TermFromJson(json);

  Map<String, dynamic> toJson() => _$TermToJson(this);

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other is Term && runtimeType == other.runtimeType && term_id == other.term_id);
  }

  @override
  int get hashCode => Object.hash(runtimeType, term_id);
  

}