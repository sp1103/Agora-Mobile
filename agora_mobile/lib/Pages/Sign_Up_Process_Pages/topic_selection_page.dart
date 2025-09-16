import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopicSelectionPage extends StatefulWidget {
  const TopicSelectionPage({super.key});

  @override
  State<TopicSelectionPage> createState() => _TopicSelectionPageState();
}

class _TopicSelectionPageState extends State<TopicSelectionPage> {
  String _search = "";
  Set<String> selected = {};

  final List<String> popularTopics = [
    "Climate change and greenhouse gases",
    "Abortion",
    "Education",
    "Firearms and explosives",
    "Immigration",
    "Human rights"
  ];

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();

    //AI GENERATED CODE START
    var allTopics = appState.topics.map((t) => t.topic_name).toList();
    allTopics.sort();

    var filtered = _search.isEmpty
        ? []
        : allTopics
            .where((t) => t.toLowerCase().contains(_search.toLowerCase()))
            .toList();
    //AI GENERATED CODE END

    return Scaffold(
      appBar: AppBar(
          title: Center(
              child: Text("Topics",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 40)))),
      body: Column(
        children: [
          SizedBox(height: 10),
          Center(child: Text("Pick 3 or more topics to view on your homepage")),
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
          if (_search.isEmpty) Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            child: Wrap(
              spacing: 10,
              runSpacing: 15,
              children: popularTopics.map((topic) {
                bool isSelected = selected.contains(topic);
                return ChoiceChip(
                  label: Text(topic),
                  selected: isSelected,
                  onSelected: (val) {
                    setState(() {
                      if (isSelected) {
                        selected.remove(topic);
                        appState.selectedTopics.remove(topic);
                      } else {
                        selected.add(topic);
                        appState.selectedTopics.add(topic);
                      }
                    });
                  },
                );
              }).toList(), //AI GENERATED CODE END
            ),
          ),
          if (filtered.isNotEmpty) Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              child: Wrap(
                spacing: 10,
                runSpacing: 15,
                children: filtered.map((topic) {
                  bool isSelected = selected.contains(topic);
                  return ChoiceChip(
                    label: Text(topic),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() {
                        if (isSelected) {
                          selected.remove(topic);
                          appState.selectedTopics.remove(topic);
                        } else {
                          selected.add(topic);
                          appState.selectedTopics.add(topic);
                        }
                      });
                    },
                ) ;
                }).toList(), //AI GENERATED CODE END
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 0),
            child: Center(
              child: ElevatedButton(
                onPressed: appState.selectedTopics.length >= 3
                ? () { }
                : null,
                child: Center(child: Text("Next")),
              ),
            ),
          ),
          if (appState.selectedTopics.length < 3) Padding(
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
