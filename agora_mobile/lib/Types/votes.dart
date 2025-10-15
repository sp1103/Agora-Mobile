// The names are from the Database
// ignore_for_file: non_constant_identifier_names

import 'package:agora_mobile/Types/legislation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'votes.g.dart';

@JsonSerializable()

/// Creates a Vote object that holds all info related to a vote that is generated via JSON from the 
/// database
/// 
/// * bill - The bill being voted on
/// * vote_cast - the vote cast by the senetor
class Vote {

  final Legislation bill;
  final String vote_cast;


  //All of this is things required for the JSON
  Vote({required this.bill, required this.vote_cast});

  factory Vote.fromJson(Map<String, dynamic> json) => _$VoteFromJson(json);

  Map<String, dynamic> toJson() => _$VoteToJson(this);

}