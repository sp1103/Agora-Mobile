import 'package:agora_mobile/Types/topic.dart';
import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchMode = "Politicians";
  final TextEditingController controller = TextEditingController();

  // Legislation filters
  Topic? topic;
  String? status;
  String? billType;
  String? congressSessionLegislation;
  DateTime? dateIntroduced;
  DateTime? lastUpdateDate;

  // Politician filters
  String? chamber;
  String? state;
  DateTime? startYear;
  String? congressSessionPolitician;

  //Options

  final List<String> searchModes = ['Politicians', 'Legislation'];

  final List<String> states = [
    '',
    'Alabama',
    'Alaska',
    'Arizona',
    'Arkansas',
    'California',
    'Colorado',
    'Connecticut',
    'Delaware',
    'Florida',
    'Georgia',
    'Hawaii',
    'Idaho',
    'Illinois',
    'Indiana',
    'Iowa',
    'Kansas',
    'Kentucky',
    'Louisiana',
    'Maine',
    'Maryland',
    'Massachusetts',
    'Michigan',
    'Minnesota',
    'Mississippi',
    'Missouri',
    'Montana',
    'Nebraska',
    'Nevada',
    'New Hampshire',
    'New Jersey',
    'New Mexico',
    'New York',
    'North Carolina',
    'North Dakota',
    'Ohio',
    'Oklahoma',
    'Oregon',
    'Pennsylvania',
    'Rhode Island',
    'South Carolina',
    'South Dakota',
    'Tennessee',
    'Texas',
    'Utah',
    'Vermont',
    'Virginia',
    'Washington',
    'West Virginia',
    'Wisconsin',
    'Wyoming'
  ];

  final List<String> statuses = [
    '',
    'Introduced',
    'Became Law',
    'Passed House',
    'Passed Senate'
  ];

  final List<String> billTypes = [
    '',
    'House Bill',
    'Senate Bill',
    'House Joint Resolution',
    'Senate Joint Resolution',
    'House Concurrent Resolution',
    'Senate Concurrent Resolution',
    'House Simple Resolution',
    'Senate Simple Resolution'
  ];

  final Map<String, String> billTypeMap = {
  'House Bill': 'hr',
  'Senate Bill': 's',
  'House Joint Resolution': 'hjres',
  'Senate Joint Resolution': 'sjres',
  'House Concurrent Resolution': 'hconres',
  'Senate Concurrent Resolution': 'sconres',
  'House Simple Resolution': 'hres',
  'Senate Simple Resolution': 'sres',
};

  final List<String> congressSessions = ['', '118', '119'];

  final List<String> chambers = ['', 'Senate', 'House of Representatives'];

  //AI GENERATED CODE START
  Future<void> _selectDate(
      BuildContext context, ValueSetter<DateTime> onPicked) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    if (picked != null) onPicked(picked);
  }
  //AI GENERATED CODE END

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: appState.closeDetails,
            icon: Icon(Icons.arrow_back, color: Colors.black)),
        title: Text(
          "Search",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                value: searchMode,
                isExpanded: true,
                items: searchModes
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) =>
                    setState(() => searchMode = v ?? 'Politicians'),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(labelText: "Name"),
              ),
            ),
            SizedBox(height: 16),
            if (searchMode == 'Legislation') ...[
              // Topic
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<Topic>(
                  value: topic,
                  decoration: const InputDecoration(labelText: "Topic"),
                  items: appState.topics
                      .map((s) => DropdownMenuItem(
                          value: s,
                          child: Text(s.topic_name.isEmpty ? "" : s.topic_name)))
                      .toList(),
                  onChanged: (v) => setState(() => topic = v),
                ),
              ),
              const SizedBox(height: 16),

              // Status
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: status,
                  decoration: const InputDecoration(labelText: "Status"),
                  items: statuses
                      .map((s) => DropdownMenuItem(
                          value: s, child: Text(s.isEmpty ? "" : s)))
                      .toList(),
                  onChanged: (v) => setState(() => status = v),
                ),
              ),
              const SizedBox(height: 16),

              // Type
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: billType,
                  decoration: const InputDecoration(labelText: "Bill Type"),
                  items: billTypes
                      .map((s) => DropdownMenuItem(
                          value: s, child: Text(s.isEmpty ? "" : s)))
                      .toList(),
                  onChanged: (v) => setState(() => billType = v),
                ),
              ),
              const SizedBox(height: 16),

              // Congress Session
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: congressSessionLegislation,
                  decoration:
                      const InputDecoration(labelText: "Congress Session"),
                  items: congressSessions
                      .map((s) => DropdownMenuItem(
                          value: s, child: Text(s.isEmpty ? "" : s)))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => congressSessionLegislation = v),
                ),
              ),
              const SizedBox(height: 16),

              // Date Introduced
              ListTile(
                title: Text(
                  "Date Introduced: ${dateIntroduced != null ? dateIntroduced!.toLocal().toString().split(' ')[0] : '(Any)'}",
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(
                    context, (d) => setState(() => dateIntroduced = d)),
              ),
              const SizedBox(height: 16),

              // Last Status Update
              ListTile(
                title: Text(
                  "Last Status Update: ${lastUpdateDate != null ? lastUpdateDate!.toLocal().toString().split(' ')[0] : '(Any)'}",
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(
                    context, (d) => setState(() => lastUpdateDate = d)),
              ),
            ],
            if (searchMode == 'Politicians') ...[
              // Chamber
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: chamber,
                  decoration: const InputDecoration(labelText: "Chamber"),
                  items: chambers
                      .map((s) => DropdownMenuItem(
                          value: s, child: Text(s.isEmpty ? "" : s)))
                      .toList(),
                  onChanged: (v) => setState(() => chamber = v),
                ),
              ),
              const SizedBox(height: 16),

              // State
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: state,
                  decoration: const InputDecoration(labelText: "State"),
                  items: states
                      .map((s) => DropdownMenuItem(
                          value: s, child: Text(s.isEmpty ? "" : s)))
                      .toList(),
                  onChanged: (v) => setState(() => state = v),
                ),
              ),
              const SizedBox(height: 16),

              // Start Year
              ListTile(
                title: Text(
                  "Start Year: ${startYear != null ? startYear!.year.toString() : ''}",
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () =>
                    _selectDate(context, (d) => setState(() => startYear = d)),
              ),
              const SizedBox(height: 16),

              // Congress Session
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: congressSessionPolitician,
                  decoration:
                      const InputDecoration(labelText: "Congress Session"),
                  items: congressSessions
                      .map((s) => DropdownMenuItem(
                          value: s, child: Text(s.isEmpty ? "" : s)))
                      .toList(),
                  onChanged: (v) => setState(() => congressSessionPolitician = v),
                ),
              ),
            ],
             const SizedBox(height: 32),
            // Search Button
            ElevatedButton.icon(
              onPressed: () {final String backendBillType = billTypeMap[billType] ?? ''; appState.advancedSearch(searchMode, controller.text, topic, status, backendBillType, congressSessionLegislation, dateIntroduced, lastUpdateDate, chamber, state, startYear, congressSessionPolitician);},
              icon: const Icon(Icons.search),
              label: const Text("Search"),
            ),
          ],
        ),
      ),
    );
  }
}
