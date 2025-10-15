import 'package:agora_mobile/Pages/Tab_Views/politician_vote_tab.dart';
import 'package:agora_mobile/Pages/Tab_Views/poltician_info_tab.dart';
import 'package:agora_mobile/Pages/Tab_Views/poltician_term_tab.dart';
import 'package:agora_mobile/Types/politician.dart';
import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Dynamic page for polticians
class DynamicPolitician extends StatefulWidget {
  final Politician politician;

  const DynamicPolitician({super.key, required this.politician});

   @override
  State<DynamicPolitician> createState() => _DynamicPoliticianState();
}

class _DynamicPoliticianState extends State<DynamicPolitician> {
  @override
  void initState() {
    super.initState();
    // Fetch votes only once
    final appState = context.read<AgoraAppState>();
    appState.getVotes(widget.politician.bio_id);
  }

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
                      color: appState.getBorderColor(widget.politician.party),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundImage: Uri.parse(widget.politician.image_url ?? '')
                              .isAbsolute
                          ? CachedNetworkImageProvider(widget.politician.image_url!)
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
                          widget.politician.chamber == "Senate"
                              ? "Senator ${appState.formatPolticianName(widget.politician.name)}"
                              : "Rep. ${appState.formatPolticianName(widget.politician.name)}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.politician.chamber == "Senate"
                              ? "U.S. Senator from ${widget.politician.state}\nParty - ${widget.politician.party}"
                              : "U.S. Rep. from ${widget.politician.state}, District ${widget.politician.district}\nParty - ${widget.politician.party}",
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
                  PoliticianInfoTab(politician: widget.politician),
                  PoliticianTermTab(terms: widget.politician.terms_served),
                  PoliticianVoteTab(votes: appState.votes),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
