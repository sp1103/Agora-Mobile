import 'package:agora_mobile/Types/politician.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Simplfied poltician view item designed for selection and sponsors
class PoliticianCard extends StatelessWidget{

  final Politician politician;
  final VoidCallback onTap;

  const PoliticianCard({required this.politician, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    
    return InkWell(
      onTap: onTap,
      splashColor: Colors.blue.withAlpha(30),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
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
            Text(politician.name, style: TextStyle(fontSize: 20, color: Colors.indigo, fontWeight: FontWeight.bold),),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}