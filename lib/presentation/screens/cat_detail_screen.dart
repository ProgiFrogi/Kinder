import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CatDetailScreen extends StatelessWidget {
  final Map<String, dynamic> cat;

  const CatDetailScreen({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cat['breeds'][0]['name']),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: cat['url'],
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) =>
                      const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) {
                return const Center(
                  child: Icon(Icons.error, color: Colors.red, size: 50),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cat['breeds'][0]['name'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cat['breeds'][0]['description'],
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
