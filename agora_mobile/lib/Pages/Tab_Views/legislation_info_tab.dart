import 'package:agora_mobile/Types/legislation.dart';
import 'package:flutter/material.dart';

/// Creates a tab that contains legislation info
class LegislationInfoTab extends StatelessWidget {
  final Legislation legislation;
  
  const LegislationInfoTab({super.key, required this.legislation});
  

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Introduction Date",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.indigo),
          ),
          const SizedBox(height: 8),
          Text(
            legislation.intro_date.split("00:00:00").first.trim(),
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Text(
            "Date Of Most Recent Action",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.indigo),
          ),
          const SizedBox(height: 8),
          Text(
            legislation.status_update_date.split("00:00:00").first.trim(),
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Text(
            "Status",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.indigo),
          ),
          const SizedBox(height: 8),
          Text(
            legislation.status,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}