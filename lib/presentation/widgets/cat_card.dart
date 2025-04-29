import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CatCard extends StatelessWidget {
  final Map<String, dynamic> cat;
  final VoidCallback onTap;

  const CatCard({super.key, required this.cat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: cat['url'],
              fit: BoxFit.cover,
              placeholder:
                  (context, url) =>
                      const Center(child: CircularProgressIndicator()),
              errorWidget:
                  (context, url, error) => const Center(
                    child: Icon(Icons.error, color: Colors.red, size: 50),
                  ),
            ),
            Positioned(
              left: 16,
              bottom: 90,
              child: Text(
                cat['breeds'][0]['name'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Text(
                  cat['breeds'][0]['description'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
