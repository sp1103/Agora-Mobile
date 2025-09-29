import 'package:flutter/material.dart';

//AI GENERATED CODE START
///Creates a search bar with filters
class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller; 
  final ValueChanged<String> onQueryChanged; //What happens when enter is clicked on the search bar
  final VoidCallback onClear;

  const SearchAppBar({
    super.key,
    required this.controller,
    required this.onQueryChanged,
    required this.onClear 
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onSubmitted: onQueryChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        prefixIcon: const Icon(Icons.search),
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
        suffixIcon: IconButton(onPressed: onClear, icon: Icon(Icons.clear))
      ),
    );
  }
}
//END AI GENERATED CODE