import 'package:agora_mobile/Types/politician.dart';
import 'package:flutter/material.dart';

/// Creates a tab that contains poltician info
class PoliticianInfoTab extends StatelessWidget {
  final Politician politician;
  
  const PoliticianInfoTab({super.key, required this.politician});

  String sanitizeBio(String? text) {
    if (text == null || text.isEmpty) return "No Biography Available";

    String clean = text.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');

    clean = clean.replaceAll(RegExp(r'<[^>]*>'), '');

    // Decode common HTML entities
    clean = clean
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&apos;', "'")
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>');

    // Remove unsupported Unicode replacement characters (�)
    clean = clean.replaceAll('�', '');

    // Trim extra whitespace/newlines
    clean = clean.trim();

    // Fallback if it becomes empty
    if (clean.isEmpty) return "No Biography Available";

    return clean;
  }
  

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Biography",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.indigo),
          ),
          const SizedBox(height: 8),
          Text(
            sanitizeBio(politician.bio_text),
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          if (politician.current_title != "No current leadership role") ...[
            Text(
              "Current Leadership Role",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.indigo),
            ),
            const SizedBox(height: 8),
            Text(
              politician.current_title,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ],
      ),
    );
  }
}