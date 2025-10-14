import 'package:agora_mobile/Types/politician.dart';
import 'package:flutter/material.dart';

/// Creates a tab that contains poltician info
class PoliticianInfoTab extends StatelessWidget {
  final Politician politician;
  
  const PoliticianInfoTab({super.key, required this.politician});
  

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Biography",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            politician.bio_text ?? "No Biography Available",
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}