import 'package:agora_mobile/Pages/List_Items/politician_card.dart';
import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Page allows user to select initial polticians to follow during sign up process
class PoliticianSelectionPage extends StatefulWidget{
  const PoliticianSelectionPage({super.key});

  @override
  State<PoliticianSelectionPage> createState() => _PoliticianSelectionPageState();

}

class _PoliticianSelectionPageState extends State<PoliticianSelectionPage> {
  String _search = "";
  Set<String> selected = {};

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();

    return Scaffold(
      appBar: AppBar(
          title: Center(
              child: Text("Polticians",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 40)))),
      body: Column(
        children: [
          SizedBox(height: 10),
          Center(child: Text("Pick 3 or more politicians")),
          SizedBox(height: 30),
          Padding(
            //AI GENERATED CODE START
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search for more topics...",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val) =>
                  setState(() => _search = val), //AI GENERATED CODE END
            ),
          ),
          if (appState.polticianSelecttionList.length <= 6) Padding(padding: EdgeInsets.symmetric(horizontal: 50, vertical:0), child: Center(child: CircularProgressIndicator())),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                child: Wrap(
                  spacing: 0,
                  runSpacing: 10,
                  children: (_search.isEmpty
                          ? appState.polticianSelecttionList.take(6).toList()
                          : appState.polticianSelecttionList
                              .where((p) =>
                                  p.name.toLowerCase().contains(_search.toLowerCase()))
                              .toList())
                      .map((politician) {
                    bool isSelected = selected.contains(politician.bio_id);
                    return SizedBox(
                      width: 155,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selected.remove(politician.bio_id);
                              appState.selectedPolticians.remove(politician.bio_id);
                            } else {
                              selected.add(politician.bio_id);
                              appState.selectedPolticians.add(politician.bio_id);
                            }
                          });
                        },
                        child: PoliticianCard(
                          politician: politician,
                          isSelected: isSelected,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 0),
            child: Center(
              child: ElevatedButton(
                onPressed: appState.selectedPolticians.length >= 3
                ? () { appState.finishSignUpProcess(); }
                : null,
                child: Center(child: Text("Next")),
              ),
            ),
          ),
          if (appState.selectedPolticians.length < 3) Padding(
            padding: const EdgeInsets.symmetric(horizontal: 58, vertical: 8),
            child: Text(
              "Please select at least 3 topics to continue",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  
}