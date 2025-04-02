import 'package:agora_mobile/Pages/List_Items/politician_item.dart';
import 'package:agora_mobile/Types/politician.dart';
import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PoliticianPage extends StatelessWidget {
  const PoliticianPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var app_state = context.watch<AgoraAppState>();

    Politician politician = Politician(politicianID: 0, name: "Derek Brown", role: "Attorney General of Utah", imageLink: "https://s3.amazonaws.com/ballotpedia-api4/files/thumbs/200/300/Derek_Brown.jpg", sealLink: "https://ballotpedia.s3.amazonaws.com/images/thumb/1/1f/UT_Atty_Gen_logo.JPG/225px-UT_Atty_Gen_logo.JPG", shortBio: "Derek Brown (Republican Party) is the Attorney General of Utah. He assumed office on January 7, 2025. His current term ends on January 1, 2029.", state: "Utah");

    return PoliticianItem(politician).build(context);

  }

}