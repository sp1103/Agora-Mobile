import 'package:flutter/material.dart';
import 'package:azlistview/azlistview.dart';
import 'package:provider/provider.dart';
import 'package:agora_mobile/app_state.dart';
import 'package:agora_mobile/Types/glossary_entry.dart';

/// A glossary
class GlossaryPage extends StatefulWidget {
  const GlossaryPage({super.key});

  @override
  State<GlossaryPage> createState() => _GlossaryPageState();
}

class _GlossaryPageState extends State<GlossaryPage> {

  final Set<GlossaryEntry> expandedItems = {};

  //AI GENERATED CODE START
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AgoraAppState>();
    final list = appState.glossaryList;

    return Scaffold(
      appBar: AppBar(title: const Text("Glossary")),
      body: AzListView(
        data: list,
        itemCount: list.length,
        itemBuilder: (context, index) {
          final entry = list[index];
          final isExpanded = expandedItems.contains(entry);

          return Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                title: Text(appState.titleCasePreservePunctuation(entry.term), style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 20)),
                onTap: () {
                  setState(() {
                    if (isExpanded) {
                      expandedItems.remove(entry);
                    } else {
                      expandedItems.add(entry);
                    }
                  });
                },
              ),
              if (isExpanded) Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                child: SizedBox(width: 360, child: Text(entry.definition)), 
              ),
            ],
          );
        },
        indexBarData: SuspensionUtil.getTagIndexList(list),
        indexBarOptions: const IndexBarOptions(
          needRebuild: true,
          ignoreDragCancel: true,
          textStyle: TextStyle(fontSize: 12, color: Colors.indigo),
        ),
      ),
    );
  }
  //AI GENERATED CODE END
}
