import 'package:agora_mobile/Pages/Dynamic_Pages/dynamic_politician.dart';
import 'package:agora_mobile/Pages/List_Items/politician_card.dart';
import 'package:agora_mobile/Types/legislation.dart';
import 'package:flutter/material.dart';
import 'package:agora_mobile/app_state.dart';
import 'package:provider/provider.dart';

class LegislationSponsorTab extends StatelessWidget{

  final Legislation legislation;

  const LegislationSponsorTab({required this.legislation, super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();

    return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                child: Wrap(
                  spacing: 0,
                  runSpacing: 10,
                  children: (legislation.sponsors_ids)
                  .map((politician) {
                    return SizedBox(
                      width: 155,
                      child: PoliticianCard(
                        politician: politician,
                        onTap:() {appState.openDetails(DynamicPolitician(politician: politician), true, false); },
                      ),
                    );
                  }).toList(),
                ),
              ),
            );

  }
}