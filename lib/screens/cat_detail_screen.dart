import 'package:flutter/material.dart';

class CatDetailScreen extends StatelessWidget {
  final Map<String, dynamic> cat;

  CatDetailScreen({required this.cat});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // По тапу на экран возвращаемся назад
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(cat['breeds'][0]['name']),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network(
                    cat['url'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                cat['breeds'][0]['description'],
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
