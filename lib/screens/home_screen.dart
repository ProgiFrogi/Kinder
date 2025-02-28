import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../api/cat_api.dart';
import '../widgets/like_button.dart';
import '../widgets/dislike_button.dart';
import 'cat_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  HomeScreen({required this.toggleTheme, required this.isDarkMode});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CatApi _catApi = CatApi();
  final CardSwiperController _swiperController = CardSwiperController();
  List<Map<String, dynamic>> _cats = [];
  int _likeCount = 0;
  int _logoTapCount = 0;
  bool _easterEggEnabled = false;

  Future<void> _fetchRandomCat() async {
    final cat;
    try {
      if (_easterEggEnabled) {
        final response = await http.get(Uri.parse(
            'https://api.nekosia.cat/api/v1/images/catgirl?session=id&id=437808476106784770&additionalTags=foxgirl,wolf-girl,tail&blacklistedTags=dog-girl'));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          cat = {
            'url': data['image']['original']['url'],
            'breeds': [
              {'name': 'Catgirl', 'description': 'Anime-style catgirl'}
            ]
          };
        } else {
          return;
        }
      } else {
        cat = await _catApi.fetchRandomCat();
      }

      // Предзагрузка изображения
      await _preloadImage(cat['url']);

      setState(() {
        _cats.add(cat);
      });
    } catch (e) {
      // Можно обработать ошибку
    }
  }

  Future<void> _preloadImage(String imageUrl) async {
    try {
      final image = NetworkImage(imageUrl);
      final completer = Completer<void>();

      image.resolve(ImageConfiguration()).addListener(
        ImageStreamListener((_, __) {
          completer.complete();
        }, onError: (dynamic exception, StackTrace? stackTrace) {
          completer.complete(); // Завершаем даже при ошибке
        }),
      );

      await completer.future;
    } catch (e) {
      print('Ошибка загрузки изображения: $e');
    }
  }

  Future<void> _loadLikeCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _likeCount = prefs.getInt('likeCount') ?? 0;
    });
  }

  Future<void> _saveLikeCount() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('likeCount', _likeCount);
  }

  void _handleSwipe(bool isRight) {
    if (isRight) {
      setState(() {
        _likeCount++;
      });
      _saveLikeCount();
    }
    _fetchRandomCat();
  }

  void _resetLikeCount() {
    setState(() {
      _likeCount = 0;
      _easterEggEnabled = false; // Выход из пасхалки
    });
    _saveLikeCount();
  }

  @override
  void initState() {
    super.initState();
    _loadLikeCount();
    _fetchRandomCat();
  }

  @override
  Widget build(BuildContext context) {
    if (_easterEggEnabled) {
      _likeCount = 999;  // При активации пасхалки устанавливаем лайк на 999
    }

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: _cats.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : CardSwiper(
                        controller: _swiperController,
                        cards: _cats.map((cat) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CatDetailScreen(cat: cat),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    cat['url'],
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                                  (loadingProgress.expectedTotalBytes ?? 1)
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Icon(Icons.error, color: Colors.red, size: 50),
                                      );
                                    },
                                  ),
                                  Positioned(
                                    left: 16,
                                    bottom: 90,
                                    child: Text(
                                      cat['breeds'][0]['name'],
                                      style: TextStyle(
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
                                      color: Colors.black.withOpacity(0.5),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      child: Text(
                                        cat['breeds'][0]['description'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        numberOfCardsDisplayed: _cats.length < 3 ? _cats.length : 3,
                        onSwipe: (index, direction) {
                          _handleSwipe(direction == CardSwiperDirection.right);
                        },
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DislikeButton(onPressed: () {
                    _swiperController.swipeLeft();
                  }),
                  LikeButton(onPressed: () {
                    _swiperController.swipeRight();
                  }),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.indigo,
                      child: IconButton(
                        icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                            color: Colors.white),
                        onPressed: widget.toggleTheme,
                      ),
                    ),
                    SizedBox(width: 16),
                    Chip(
                      backgroundColor: Colors.indigo,
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.favorite, color: Colors.redAccent),
                          SizedBox(width: 4),
                          Text(
                            '$_likeCount',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    IconButton(
                      icon: Icon(Icons.restart_alt, color: Colors.indigo, size: 32),
                      onPressed: _resetLikeCount,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 20,
            left: 20,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _logoTapCount++;
                  if (_logoTapCount >= 5) {
                    _easterEggEnabled = true;
                  }
                });
              },
              child: SvgPicture.asset(
                'assets/catlogo.svg',
                width: 80,
                height: 80,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
