import 'package:agora_mobile/Pages/Tab_Views/politician_vote_tab.dart';
import 'package:agora_mobile/Pages/Tab_Views/poltician_info_tab.dart';
import 'package:agora_mobile/Pages/Tab_Views/poltician_term_tab.dart';
import 'package:agora_mobile/Types/politician.dart';
import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Dynamic page for polticians
class DynamicPolitician extends StatelessWidget {
  final Politician politician;

  const DynamicPolitician({super.key, required this.politician});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset('assets/us-capitol.jpg',
                    height: 200, width: double.infinity, fit: BoxFit.cover),
                Positioned(
                  top: 140,
                  left: 20,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: appState.getBorderColor(politician.party),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundImage: Uri.parse(politician.image_url ?? '')
                              .isAbsolute
                          ? CachedNetworkImageProvider(politician.image_url!)
                          : const AssetImage('assets/No_Photo.png'),
                    ),
                  ),
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
                          politician.chamber == "Senate"
                              ? "Senator ${appState.formatPolticianName(politician.name)}"
                              : "Rep. ${appState.formatPolticianName(politician.name)}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          politician.chamber == "Senate"
                              ? (politician.chamber.contains("Utah")
                                ? "Utah Senator \nParty - ${politician.party}"
                                : "U.S. Senator from ${politician.state}\nParty - ${politician.party}")
                              : (politician.chamber.contains("Utah")
                                ? "Utah Rep. - District ${politician.district}\nParty - ${politician.party}"
                                : "U.S. Rep. from ${politician.state}, District ${politician.district}\nParty - ${politician.party}"),
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
                Tab(text: "Info"),
                Tab(text: "Terms"),
                Tab(text: "Voting History"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  PoliticianInfoTab(politician: politician),
                  PoliticianTermTab(terms: politician.terms_served),
                  PoliticianVoteTab(poltician: politician),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
