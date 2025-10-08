import 'package:azlistview/azlistview.dart';
import 'package:json_annotation/json_annotation.dart';
part 'glossary_entry.g.dart';

@JsonSerializable()

/// A class which reperesents an entry in a glossary
/// It takes two strings term and definition
class GlossaryEntry extends ISuspensionBean{
  final String term;
  final String definition;

  GlossaryEntry({required this.term, required this.definition});

  factory GlossaryEntry.fromJson(Map<String, dynamic> json) => _$GlossaryEntryFromJson(json);

  Map<String, dynamic> toJson() => _$GlossaryEntryToJson(this);
  
  @override
  String getSuspensionTag() { //Needed to create a contacts style azlist using the azlistview package
    final clean = term.replaceAll(RegExp(r'[^A-Za-z]'), '').trim();

    return clean[0].toUpperCase();
  }

}