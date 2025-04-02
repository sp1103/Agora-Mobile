import 'package:agora_mobile/Pages/List_Items/legislation_item.dart';
import 'package:agora_mobile/Types/legislation.dart';
import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LegislationPage extends StatelessWidget {
  const LegislationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var app_state = context.watch<AgoraAppState>();

    Legislation legislation = Legislation(legislationID: 0, billNumber: "H. R. 8281", name: "SAVE Act", shortDescription: "This bill requires individuals to provide documentary proof of U.S. citizenship in order to register to vote in federal elections.", date: DateTime(2024, 7, 10), fullContent: "h", govLevel: "US Congress", govLink: "h", state: "Federal", image: "https://tse1.mm.bing.net/th/id/OIP.DdPweGtpNTo-i9AmSE4lzwAAAA?rs=1&pid=ImgDetMain", issueCategories: ["Citizenship", "Voting"]);

    return LegislationItem(legislation).build(context);

  }

}