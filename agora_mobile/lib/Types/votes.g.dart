// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'votes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vote _$VoteFromJson(Map<String, dynamic> json) => Vote(
      bill: Legislation.fromJson(json['bill'] as Map<String, dynamic>),
      vote_cast: json['vote_cast'] as String,
    );

Map<String, dynamic> _$VoteToJson(Vote instance) => <String, dynamic>{
      'bill': instance.bill,
      'vote_cast': instance.vote_cast,
    };
