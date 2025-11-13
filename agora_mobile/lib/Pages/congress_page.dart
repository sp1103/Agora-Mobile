import 'package:agora_mobile/Pages/Charts/congress_chart.dart';
import 'package:agora_mobile/Types/politician.dart';
import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Creates a page with the current congress
class CongressPage extends StatefulWidget{

  const CongressPage({super.key});

  @override
  State<CongressPage> createState() => _CongressPageState();
}

class _CongressPageState extends State<CongressPage> {
  String selectedCongress = "119";
  String selectedChamber = "Senate";
  int seats = 100;
  Map<Color, List<Politician>> members = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = context.read<AgoraAppState>();
      _loadMembers(selectedCongress, selectedChamber, appState);
    });
  }

  Future<void> _loadMembers(String congress, String chamber, AgoraAppState state) async {
    final map = await state.getCongressChart(int.parse(congress), chamber, 1);

    setState(() {
      members = map;
    });
  }

  void _onCongressSelected(String? congress, AgoraAppState state) {
    if (congress == null) return;
    members.clear();
    setState(() {
      selectedCongress = congress;
    });
    _loadMembers(congress, selectedChamber, state);
  }

  void _onChamberSelected(String? chamber, AgoraAppState state) {
    if (chamber == null) return;
    members.clear();
    setState(() {
      selectedChamber = chamber;
      if (chamber == "Senate") {
        seats = 100;
      } else {
        seats = 441;
      }
    });
    _loadMembers(selectedCongress, chamber, state);
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();

    if (members.isEmpty) return Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: appState.closeDetails,
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Row(
          children: [
            Expanded(
              child: DropdownButton<String>(
                value: selectedCongress,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: "119", child: Text("119th Congress"))
                ], 
                onChanged: (v) => _onCongressSelected(v, appState),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: DropdownButton<String>(
                value: selectedChamber,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: "Senate", child: Text("Senate")),
                  DropdownMenuItem(value: "House of Representatives", child: Text("House"))
                ], 
                onChanged: (v) => _onChamberSelected(v, appState),
              ),
            ),
          ],
        ),
      ),
      body: CongressChart(partySeats: members, totalSeatsExpected: seats),
    );
  }
}