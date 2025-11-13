import 'dart:convert';
import 'package:agora_mobile/Pages/Charts/congress_chart.dart';
import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

/// Represents a seat change between sessions/congresses
class SeatChange {
  final String state;
  final int? district;
  final String previousHolder;
  final String previousParty;
  final String newHolder;
  final String newParty;
  final bool isVacant;

  SeatChange({
    required this.state,
    this.district,
    required this.previousHolder,
    required this.previousParty,
    required this.newHolder,
    required this.newParty,
    required this.isVacant,
  });
}

///Creates a page with the current congress
class CongressPage extends StatefulWidget {
  const CongressPage({super.key});

  @override
  State<CongressPage> createState() => _CongressPageState();
}

class _CongressPageState extends State<CongressPage> {
  String selectedCongress = "119";
  String selectedChamber = "Senate";
  int selectedSession = 1;
  int seats = 100;
  Map<Color, List<ChartMember>> members = {};
  List<SeatChange> seatChanges = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Color _getPartyColor(String party) {
    final p = party.toLowerCase();
    if (p.contains('democratic') || p.contains('democrat')) {
      return Colors.blue;
    } else if (p.contains('republican')) {
      return Colors.red;
    } else if (p.isEmpty) {
      return Colors.grey;
    } else {
      return Colors.green;
    }
  }

  Future<void> _loadMembers() async {
    setState(() {
      isLoading = true;
      members.clear();
      seatChanges.clear();
    });

    try {
      final chamber = selectedChamber == "Senate" ? "senate" : "house";
      final filename =
          'assets/Congress/${chamber}_members_${selectedCongress}_session$selectedSession.json';

      final jsonString = await rootBundle.loadString(filename);
      final List<dynamic> jsonList = json.decode(jsonString);

      final democrats = <ChartMember>[];
      final republicans = <ChartMember>[];
      final independents = <ChartMember>[];

      // Create a map of current seats
      final currentSeats = <String, ChartMember>{};
      
      for (final item in jsonList) {
        final member = ChartMember.fromJson(item);
        final party = member.party.toLowerCase();

        // Create seat key
        final seatKey = chamber == "senate" 
            ? member.state 
            : '${member.state}-${member.district}';
        currentSeats[seatKey] = member;

        if (party.contains('democratic') || party.contains('democrat')) {
          democrats.add(member);
        } else if (party.contains('republican')) {
          republicans.add(member);
        } else {
          independents.add(member);
        }
      }

      // Load previous session/congress data for comparison
      await _detectSeatChanges(chamber, currentSeats);

      setState(() {
        members = {
          Colors.blue: democrats,
          Colors.red: republicans,
          Colors.green: independents,
        };
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _detectSeatChanges(String chamber, Map<String, ChartMember> currentSeats) async {
    try {
      // Determine previous session/congress
      String prevCongress = selectedCongress;
      int prevSession = selectedSession - 1;
      
      if (prevSession < 1) {
        // Go to previous congress, session 2
        prevCongress = (int.parse(selectedCongress) - 1).toString();
        prevSession = 2;
      }

      final prevFilename =
          'assets/Congress/${chamber}_members_${prevCongress}_session$prevSession.json';

      final prevJsonString = await rootBundle.loadString(prevFilename);
      final List<dynamic> prevJsonList = json.decode(prevJsonString);

      final previousSeats = <String, ChartMember>{};
      for (final item in prevJsonList) {
        final member = ChartMember.fromJson(item);
        final seatKey = chamber == "senate" 
            ? member.state 
            : '${member.state}-${member.district}';
        previousSeats[seatKey] = member;
      }

      // Compare and find changes
      final changes = <SeatChange>[];
      
      for (final seatKey in currentSeats.keys) {
        final current = currentSeats[seatKey]!;
        final previous = previousSeats[seatKey];

        if (previous == null || previous.bioId != current.bioId) {
          changes.add(SeatChange(
            state: current.state,
            district: current.district,
            previousHolder: previous?.name ?? 'Vacant',
            previousParty: previous?.party ?? '',
            newHolder: current.name,
            newParty: current.party,
            isVacant: false,
          ));
        }
      }

      // Check for newly vacant seats
      for (final seatKey in previousSeats.keys) {
        if (!currentSeats.containsKey(seatKey)) {
          final previous = previousSeats[seatKey]!;
          changes.add(SeatChange(
            state: previous.state,
            district: previous.district,
            previousHolder: previous.name,
            previousParty: previous.party,
            newHolder: 'Vacant',
            newParty: '',
            isVacant: true,
          ));
        }
      }

      setState(() {
        seatChanges = changes;
      });
    } catch (e) {
      // No previous data available, that's ok
    }
  }

  void _onCongressSelected(String? congress) {
    if (congress == null) return;
    setState(() {
      selectedCongress = congress;
    });
    _loadMembers();
  }

  void _onChamberSelected(String? chamber) {
    if (chamber == null) return;
    setState(() {
      selectedChamber = chamber;
      seats = chamber == "Senate" ? 100 : 441;
    });
    _loadMembers();
  }

  void _onSessionSelected(int? session) {
    if (session == null) return;
    setState(() {
      selectedSession = session;
    });
    _loadMembers();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();

    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: appState.closeDetails,
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Row(
          children: [
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCongress,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: "119", child: Text("119th Congress")),
                    DropdownMenuItem(value: "118", child: Text("118th Congress")),
                    DropdownMenuItem(value: "117", child: Text("117th Congress")),
                    DropdownMenuItem(value: "116", child: Text("116th Congress")),
                    DropdownMenuItem(value: "115", child: Text("115th Congress")),
                  ],
                  onChanged: _onCongressSelected,
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedChamber,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: "Senate", child: Text("Senate")),
                    DropdownMenuItem(
                        value: "House of Representatives", child: Text("House"))
                  ],
                  onChanged: _onChamberSelected,
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: selectedSession,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 1, child: Text("Session 1")),
                    DropdownMenuItem(value: 2, child: Text("Session 2")),
                  ],
                  onChanged: _onSessionSelected,
                ),
              ),
            ),
          ],
        ),
      ),
      body: members.isEmpty
          ? Center(child: Text('No data available'))
          : Column(
              children: [
                // Chart at the top
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: CongressChart(
                      partySeats: members,
                      totalSeatsExpected: seats,
                      congress: int.parse(selectedCongress),
                    ),
                  ),
                ),
                
                // Seat changes list at the bottom
                if (seatChanges.isNotEmpty) ...[
                  Divider(height: 1, thickness: 1),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Seat Changes (${seatChanges.length})',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      itemCount: seatChanges.length,
                      itemBuilder: (context, index) {
                        final change = seatChanges[index];
                        final districtText = change.district != null 
                            ? ' District ${change.district}' 
                            : '';
                        
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          child: Row(
                            children: [
                              // State/District
                              Expanded(
                                flex: 2,
                                child: Text(
                                  '${change.state}$districtText',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                              
                              // Previous holder with color
                              Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: _getPartyColor(change.previousParty),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        change.previousHolder,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Arrow
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Icon(Icons.arrow_forward, size: 16),
                              ),
                              
                              // New holder with color
                              Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: change.isVacant 
                                            ? Colors.grey 
                                            : _getPartyColor(change.newParty),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        change.newHolder,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: change.isVacant 
                                              ? FontWeight.normal 
                                              : FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}