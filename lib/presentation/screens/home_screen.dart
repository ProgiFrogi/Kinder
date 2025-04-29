import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:http/http.dart' as http;
import 'package:kinder/api/cat_api.dart';
import 'package:kinder/data/datasources/local_database.dart';
import 'package:kinder/di/dependency_injection.dart';
import 'package:kinder/domain/models/liked_cat.dart';
import 'package:kinder/presentation/screens/cat_detail_screen.dart';
import 'package:kinder/presentation/screens/liked_cats_screen.dart';
import 'package:kinder/presentation/widgets/like_button.dart';
import 'package:kinder/presentation/widgets/dislike_button.dart';
import 'package:kinder/presentation/widgets/cat_card.dart';
import 'package:kinder/domain/cubits/liked_cats_cubit.dart';
import 'package:kinder/data/liked_cats_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final CatApi _catApi = getIt<CatApi>();
  final LikedCatsRepository _repository = getIt<LikedCatsRepository>();
  final CardSwiperController _swiperController = CardSwiperController();
  final List<Map<String, dynamic>> _cats = [];
  final List<Map<String, dynamic>> _allCats = [];
  int _likeCount = 0;
  int _logoTapCount = 0;
  bool _easterEggEnabled = false;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _loadLikeCount();
    _loadOfflineCats();
    _fetchRandomCat();
  }

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  void _checkConnectivity() {
    Connectivity().onConnectivityChanged.listen((result) {
      if (!mounted) return;
      final isConnected = result != ConnectivityResult.none;
      setState(() {
        _isConnected = isConnected;
      });
      if (!isConnected) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Нет соединения с интернетом')),
        );
      }
    });
  }

  Future<void> _loadOfflineCats() async {
    final cats = await _repository.getAllCats();
    if (!mounted) return;
    setState(() {
      _allCats.clear();
      _allCats.addAll(
        cats.map(
          (cat) => {
            'id': cat.id,
            'url': cat.url,
            'breeds': [
              {'name': cat.breed, 'description': cat.description},
            ],
          },
        ),
      );
      if (_cats.isEmpty) {
        _cats.addAll(_allCats);
      }
    });
  }

  Future<void> _fetchRandomCat() async {
    if (!_isConnected) {
      if (_cats.isEmpty && _allCats.isNotEmpty) {
        if (!mounted) return;
        setState(() {
          _cats.addAll(_allCats);
        });
      }
      return;
    }
    try {
      final cat =
          _easterEggEnabled
              ? await _fetchCatgirl()
              : await _catApi.fetchRandomCat();
      if (!mounted) return;
      setState(() {
        _cats.add(cat);
        _allCats.add(cat);
      });
      await _repository.upsertCat(
        Cat(
          id: cat['id'],
          url: cat['url'],
          breed: cat['breeds'][0]['name'],
          description: cat['breeds'][0]['description'],
          isLiked: false,
          isDisliked: false,
          likedAt: null,
        ),
      );
    } catch (e) {
      if (_isConnected && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось загрузить котика')),
        );
      }
    }
  }

  Future<Map<String, dynamic>> _fetchCatgirl() async {
    final response = await http.get(
      Uri.parse(
        'https://api.nekosia.cat/api/v1/images/catgirl?session=id&id=437808476106784770&additionalTags=foxgirl,wolf-girl,tail&blacklistedTags=dog-girl',
      ),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'id': data['image']['id'],
        'url': data['image']['original']['url'],
        'breeds': [
          {'name': 'Catgirl', 'description': 'Anime-style catgirl'},
        ],
      };
    } else {
      throw Exception('Failed to fetch catgirl');
    }
  }

  Future<void> _loadLikeCount() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _likeCount = prefs.getInt('likeCount') ?? 0;
    });
  }

  Future<void> _saveLikeCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('likeCount', _likeCount);
  }

  void _handleSwipe(bool isRight) {
    if (_cats.isEmpty) return;
    final cat = _cats.last;
    if (isRight) {
      setState(() {
        _likeCount++;
      });
      _saveLikeCount();
      getIt<LikedCatsCubit>().addLikedCat(LikedCat.fromCat(cat));
    } else {
      _repository.addDislikedCat(LikedCat.fromCat(cat));
    }
    setState(() {
      _cats.removeLast();
    });
    _fetchRandomCat();
  }

  void _resetLikeCount() {
    if (!mounted) return;
    setState(() {
      _likeCount = 0;
      _easterEggEnabled = false;
    });
    _saveLikeCount();
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
                  DislikeButton(
                    onPressed: () {
                      if (mounted) _swiperController.swipeLeft();
                    },
                  ),
                  LikeButton(
                    onPressed: () {
                      if (mounted) _swiperController.swipeRight();
                    },
                  ),
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
                if (!mounted) return;
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
