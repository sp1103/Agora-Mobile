import 'package:agora_mobile/Types/politician.dart';
import 'package:agora_mobile/app_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Simplfied poltician view item designed for selection and sponsors
class PoliticianCard extends StatelessWidget{

  final Politician politician;
  final VoidCallback? onTap;
  final bool isSelected;

  const PoliticianCard({required this.politician, this.onTap, this.isSelected = false, super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();
    
    return InkWell(
      onTap: onTap,
      splashColor: Colors.blue.withAlpha(30),
      child: Card(
        color: isSelected ? Colors.blue.shade50 : Colors.white, //AI GENRATED CODE
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSelected 
          ? BorderSide(color: Colors.blue, width: 2)
          : BorderSide.none,
        ),
        elevation: isSelected ? 6 : 4,
        child: Container(
          width: 150,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              CircleAvatar(
                radius: 40,
                backgroundImage: 
                Uri.parse(politician.image_url ?? '').isAbsolute
                ? CachedNetworkImageProvider(politician.image_url!)
                : const AssetImage('assets/No_Photo.png'),
              ),
              const SizedBox(height: 8),
              Text(appState.formatPolticianName(politician.name), style: TextStyle(fontSize: 20, color: Colors.indigo, fontWeight: FontWeight.bold),),
              const SizedBox(height: 8),
              if (isSelected) Padding(
                padding: const EdgeInsets.only(top: 6),
                  child: Icon(
                  Icons.check_circle,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}