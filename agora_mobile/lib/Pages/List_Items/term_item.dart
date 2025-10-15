import 'package:agora_mobile/Pages/List_Items/list_item.dart';
import 'package:agora_mobile/Types/term.dart';
import 'package:flutter/material.dart';

/// This class implements an abstract ListItem. This one in particular contains a politician type and
/// has the details on how to display a single term object. (i.e. one row of data)
class TermItem implements ListItem {
  final Term term;

  TermItem(this.term);

  String getOrdinal(int number) {
    if (number >= 11 && number <= 13 || number >= 111 && number <= 113) {
      return 'th';
    }
    switch (number % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }


  @override
  Widget build(BuildContext context) {

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            term.chamber == "Senate"
            ? Image.asset('assets/us-s.png', width: 50, height: 50)
            : Image.asset('assets/us-h.png', width: 50, height: 50),
            SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: Text(
                term.chamber.split(' ').first,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '${term.congress}${getOrdinal(term.congress)} Congress',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                term.start_date.split("00:00:00").first.trim().split(' ').last.split('-').first, 
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
