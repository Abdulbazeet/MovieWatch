import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:movie_watch/config/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({super.key});

  @override
  State<OnBoard> createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late Timer _timer;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  List<int> _visibleGenreIndexes = [];

  final List<String> _posters = [
    'assets/images/movie1.jpg',
    'assets/images/movie2.jpg',
    'assets/images/movie3.jpg',
    'assets/images/movie4.jpg',
    'assets/images/movie5.jpg',
    'assets/images/movie6.jpg',
    'assets/images/movie7.jpg',
  ];

  final List<String> _genres = [
    'Action',
    'Adventure',
    'Animation',
    'Comedy',
    'Crime',
    'Documentary',
    'Drama',
    'Fantasy',
    'Historical',
    'Horror',
    'Musical',
    'Mystery',
    'Romance',
    'Sci-Fi',
    'Sports',
    'Thriller',
    'War',
    'Western',
  ];

  final double _scrollSpeed = 25;
  bool _next = false;
  final Set<String> _selectedGenres = {};
  bool isOnline = true;

  @override
  void initState() {
    super.initState();
    // Connectivity().onConnectivityChanged.listen((event) async {
    //   final hasInternet = await InternetConnectionChecker() asConnection;
    //   setState(() {
    //     isOnline = hasInternet;
    //   });
    // });
    // print(isOnline);

    // Initialize animation controllers
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOutCubic,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutExpo),
        );

    // auto scroll every 50ms
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_scrollController.hasClients) {
        double nextOffset = _scrollController.offset + _scrollSpeed * 0.3;

        if (nextOffset >= _scrollController.position.maxScrollExtent) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.jumpTo(nextOffset);
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Widget _buildPosterGrid() {
    return MasonryGridView.builder(
      controller: _scrollController,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemCount: 200,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 32),
      itemBuilder: (context, index) {
        final imagePath = _posters[index % _posters.length];
        final height = (150 + (index % 4) * 60).toDouble();

        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            height: height,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey,
                height: height,
                child: const Center(
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: _buildPosterGrid()),

            // Animated overlay
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                child: _next
                    ? IgnorePointer(
                        key: const ValueKey('dark_overlay'),

                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: .9),
                          ),
                        ),
                      )
                    : IgnorePointer(
                        key: const ValueKey('gradient_overlay'),

                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withValues(alpha: .9),
                                Colors.black.withValues(alpha: .6),
                                Colors.black.withValues(alpha: .2),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.3, 0.7, 1.0],
                            ),
                          ),
                        ),
                      ),
              ),
            ),

            // Genre selection section with animations
            if (_next)
              Positioned(
                top: 15,
                right: 5,
                left: 5,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        Text(
                          'Select your favorite genres',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 3),

                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 2,
                          runSpacing: 1.5,
                          children: _genres.asMap().entries.map((entry) {
                            final index = entry.key;
                            final genre = entry.value;
                            final isVisible = _visibleGenreIndexes.contains(
                              index,
                            );
                            final isSelected = _selectedGenres.contains(genre);

                            return AnimatedOpacity(
                              key: ValueKey(genre),
                              duration: const Duration(milliseconds: 300),
                              opacity: isVisible ? 1 : 0,
                              curve: Curves.easeIn,
                              child: AnimatedScale(
                                scale: isVisible ? 1 : 0.8,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOutBack,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isSelected) {
                                        _selectedGenres.remove(genre);
                                      } else {
                                        _selectedGenres.add(genre);
                                      }
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          4,
                                      vertical:
                                          1.5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                          : Colors.black54,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: isSelected
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.primary
                                            : Colors.white24,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Text(
                                      genre,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.white70,
                                        fontSize: 12,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Bottom section with animated text
            Positioned(
              bottom: 20,
              right: 20,
              left: 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Follow up on your favourite movies \nor TV Series',
                    key: const ValueKey('tell_us'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color:Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      context.go('/sign-in');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEB2F3D),
                      foregroundColor: Colors.white,
                      textStyle: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4 ),
                    ),

                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
