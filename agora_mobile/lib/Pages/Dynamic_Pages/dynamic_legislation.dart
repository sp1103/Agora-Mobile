import 'package:agora_mobile/Pages/Tab_Views/legislation_info_tab.dart';
import 'package:agora_mobile/Pages/Tab_Views/legislation_sponsor_tab.dart';
import 'package:agora_mobile/Pages/Tab_Views/legislation_chat_tab.dart';
import 'package:agora_mobile/Types/legislation.dart';
import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

class DynamicLegislation extends StatelessWidget {
  final Legislation legislation;

  const DynamicLegislation({super.key, required this.legislation});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset('assets/gavel.jpg',
                    height: 200, width: double.infinity, fit: BoxFit.cover),
                Positioned(
                  top: 140,
                  left: 20,
                  child: appState.houseOrSenate(legislation.type)
                      ? Image.asset('assets/us-h.png', width: 110, height: 110)
                      : Image.asset('assets/us-s.png', width: 110, height: 110),
                ),
                Positioned(
                  top: 40,
                  left: 8,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => appState.closeDetails(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${appState.formatBillPrefix(legislation.type)}${legislation.number.toString()}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          legislation.title,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const TabBar(
              labelColor: Colors.indigo,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: "Summary"),
                Tab(text: "Info"),
                Tab(text: "Sponsors"),
                Tab(text: "Chat"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SingleChildScrollView(child: Html(data: legislation.summary)),
                  LegislationInfoTab(legislation: legislation),
                  LegislationSponsorTab(legislation: legislation),
                  LegislationChatTab(legislation: legislation),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
