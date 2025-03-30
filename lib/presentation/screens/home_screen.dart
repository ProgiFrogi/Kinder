import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:kinder/api/cat_api.dart';
import 'package:kinder/di/dependency_injection.dart';
import 'package:kinder/domain/models/liked_cat.dart';
import 'package:kinder/presentation/screens/cat_detail_screen.dart';
import 'package:kinder/presentation/screens/liked_cats_screen.dart';
import 'package:kinder/presentation/widgets/like_button.dart';
import 'package:kinder/presentation/widgets/dislike_button.dart';
import 'package:kinder/presentation/widgets/cat_card.dart';
import 'package:kinder/domain/cubits/liked_cats_cubit.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CatApi _catApi = getIt<CatApi>();
  final CardSwiperController _swiperController = CardSwiperController();
  final List<Map<String, dynamic>> _cats = [];
  int _likeCount = 0;
  int _logoTapCount = 0;
  bool _easterEggEnabled = false;

  Future<void> _fetchRandomCat() async {
    try {
      final Map<String, dynamic> cat;
      if (_easterEggEnabled) {
        final response = await http.get(
          Uri.parse(
            'https://api.nekosia.cat/api/v1/images/catgirl?session=id&id=437808476106784770&additionalTags=foxgirl,wolf-girl,tail&blacklistedTags=dog-girl',
          ),
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          cat = {
            'id': data['image']['id'],
            'url': data['image']['original']['url'],
            'breeds': [
              {'name': 'Catgirl', 'description': 'Anime-style catgirl'},
            ],
          };
        } else {
          throw Exception('Failed to fetch catgirl');
        }
      } else {
        cat = await _catApi.fetchRandomCat();
      }

      await _preloadImage(cat['url']);

      setState(() {
        _cats.add(cat);
      });
    } catch (e) {
      _showErrorDialog();
    }
  }

  Future<void> _preloadImage(String imageUrl) async {
    try {
      final image = NetworkImage(imageUrl);
      final completer = Completer<void>();

      image
          .resolve(const ImageConfiguration())
          .addListener(
            ImageStreamListener(
              (_, __) => completer.complete(),
              onError: (_, __) => completer.complete(),
            ),
          );

      await completer.future;
    } catch (_) {}
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
      final cat = _cats.last;
      getIt<LikedCatsCubit>().addLikedCat(LikedCat.fromCat(cat));
    }
    _fetchRandomCat();
  }

  void _resetLikeCount() {
    setState(() {
      _likeCount = 0;
      _easterEggEnabled = false;
    });
    _saveLikeCount();
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Network Error'),
            content: const Text(
              'Failed to load cat image. Please check your connection.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _fetchRandomCat();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
    );
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
      _likeCount = 999;
    }

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child:
                    _cats.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : CardSwiper(
                          controller: _swiperController,
                          cards:
                              _cats.map((cat) {
                                return CatCard(
                                  cat: cat,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                CatDetailScreen(cat: cat),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                          numberOfCardsDisplayed:
                              _cats.length < 3 ? _cats.length : 3,
                          onSwipe: (index, direction) {
                            _handleSwipe(
                              direction == CardSwiperDirection.right,
                            );
                          },
                        ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DislikeButton(onPressed: () => _swiperController.swipeLeft()),
                  LikeButton(onPressed: () => _swiperController.swipeRight()),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.indigo,
                      child: IconButton(
                        icon: Icon(
                          widget.isDarkMode
                              ? Icons.wb_sunny
                              : Icons.nightlight_round,
                          color: Colors.white,
                        ),
                        onPressed: widget.toggleTheme,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Chip(
                      backgroundColor: Colors.indigo,
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.favorite, color: Colors.redAccent),
                          const SizedBox(width: 4),
                          Text(
                            '$_likeCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(
                        Icons.restart_alt,
                        color: Colors.indigo,
                        size: 32,
                      ),
                      onPressed: _resetLikeCount,
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(
                        Icons.list,
                        color: Colors.indigo,
                        size: 32,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LikedCatsScreen(),
                          ),
                        );
                      },
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
