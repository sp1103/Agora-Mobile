import 'package:agora_mobile/Pages/List_Items/list_item.dart';
import 'package:agora_mobile/Pages/List_Items/topic_item.dart';
import 'package:agora_mobile/Types/topic.dart';
import 'package:flutter/material.dart';

//AI CODE START
/// A tab for a favorites list of a certain type (topic, poltician, legislation)
class FavoritesListTab extends StatefulWidget {
  final List<ListItem> favorites;
  final bool isTopic;
  final List<Topic> allTopics;

  const FavoritesListTab({
    super.key,
    required this.favorites,
    this.isTopic = false,
    this.allTopics = const [],
  });

  @override
  State<FavoritesListTab> createState() => _FavoritesListTabState();
}

class _FavoritesListTabState extends State<FavoritesListTab> {
  final _scrollController = ScrollController();

  void _openAddTopicsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final double modalHeight = MediaQuery.of(context).size.height * 0.6;

        return SizedBox(
          height: modalHeight,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Add Topics",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.allTopics.length,
                    itemBuilder: (context, index) {
                      final item = TopicItem(widget.allTopics[index]);
                      return ListTile(title: item.build(context));
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalCount = widget.isTopic
        ? widget.favorites.length + 1
        : widget.favorites.length;

    return ListView.builder(
      controller: _scrollController,
      itemCount: totalCount,
      itemBuilder: (context, index) {
        if (widget.isTopic && index == 0) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Add Topics"),
              onPressed: _openAddTopicsSheet,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          );
        }

        final itemIndex = widget.isTopic ? index - 1 : index;
        final item = widget.favorites[itemIndex];

        return ListTile(title: item.build(context));
      },
    );
  }
}
//AI CODE END
