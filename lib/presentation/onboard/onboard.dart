// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:sizer/sizer.dart';

// class OnBoard extends StatefulWidget {
//   const OnBoard({super.key});

//   @override
//   State<OnBoard> createState() => _OnBoardState();
// }

// class _OnBoardState extends State<OnBoard> with TickerProviderStateMixin {
//   final ScrollController _scrollController = ScrollController();
//   late Timer _timer;
//   late AnimationController _fadeController;
//   late AnimationController _slideController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;

//   final List<String> _posters = [
//     'assets/movie1.jpg',
//     'assets/movie2.jpg',
//     'assets/movie3.jpg',
//     'assets/movie4.jpg',
//     'assets/movie5.jpg',
//     'assets/movie6.jpg',
//     'assets/movie7.jpg',
//   ];

//   final List<String> _genres = [
//     'Action',
//     'Adventure',
//     'Animation',
//     'Comedy',
//     'Crime',
//     'Documentary',
//     'Drama',
//     'Fantasy',
//     'Historical',
//     'Horror',
//     'Musical',
//     'Mystery',
//     'Romance',
//     'Sci-Fi',
//     'Sports',
//     'Thriller',
//     'War',
//     'Western',
//   ];

//   final double _scrollSpeed = 25;
//   bool _next = false;
//   final Set<String> _selectedGenres = {};

//   @override
//   void initState() {
//     super.initState();

//     // auto scroll every 50ms
//     _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
//       if (_scrollController.hasClients) {
//         double nextOffset =
//             _scrollController.offset + _scrollSpeed * 0.05; // smooth movement

//         if (nextOffset >= _scrollController.position.maxScrollExtent) {
//           _scrollController.jumpTo(0);
//         } else {
//           _scrollController.jumpTo(nextOffset);
//         }
//       }
//     });

//     // animation controllers

//     _fadeController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );

//     _slideController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );

//     _fadeAnimation = CurvedAnimation(
//       parent: _fadeController,
//       curve: Curves.easeInOut,
//     );

//     _slideAnimation =
//         Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
//           CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
//         );
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     _scrollController.dispose();
//     _fadeController.dispose();
//     _slideController.dispose();
//     super.dispose();
//   }

//   Widget _buildPosterGrid() {
//     return MasonryGridView.builder(
//       controller: _scrollController,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//       ),
//       mainAxisSpacing: 12,
//       crossAxisSpacing: 12,
//       itemCount: 200, // repeat posters infinitely
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 32),
//       itemBuilder: (context, index) {
//         final imagePath = _posters[index % _posters.length];
//         final height = (150 + (index % 4) * 60).toDouble();

//         return ClipRRect(
//           borderRadius: BorderRadius.circular(16),
//           child: Image.asset(
//             imagePath,
//             fit: BoxFit.cover,
//             height: height,
//             errorBuilder: (context, error, stackTrace) {
//               return Container(
//                 color: Colors.grey,
//                 height: height,
//                 child: const Center(
//                   child: Icon(
//                     Icons.broken_image,
//                     color: Colors.white,
//                     size: 40,
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Positioned.fill(child: _buildPosterGrid()),

//             Positioned.fill(
//               child: AnimatedSwitcher(
//                 duration: Duration(milliseconds: 600),
//                 child: _next
//                     ? IgnorePointer(
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Colors.black.withValues(alpha: .9),
//                           ),
//                         ),
//                       )
//                     : IgnorePointer(
//                         child: Container(
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               begin: Alignment.bottomCenter,
//                               end: Alignment.topCenter,
//                               colors: [
//                                 Colors.black.withValues(alpha: .9),
//                                 Colors.black.withValues(alpha: .6),
//                                 Colors.black.withValues(alpha: .2),
//                                 Colors.transparent,
//                               ],
//                               stops: const [0.0, 0.3, 0.7, 1.0],
//                             ),
//                           ),
//                         ),
//                       ),
//               ),
//             ),
//             if (_next)
//               Positioned(
//                 top: 15.h,
//                 right: 5.w,
//                 left: 5.w,
//                 child: FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: SlideTransition(
//                     position: _slideAnimation,
//                     child: Column(
//                       children: [
//                         Wrap(
//                           alignment: WrapAlignment.center,
//                           spacing: 2.w,
//                           runSpacing: 1.5.h,
//                           children: _genres.asMap().entries.map((entry) {
//                             final index = entry.key;
//                             final genre = entry.value;
//                             final isSelected = _selectedGenres.contains(genre);

//                             return TweenAnimationBuilder<double>(
//                               duration: Duration(
//                                 milliseconds: 400 + (index * 30),
//                               ),
//                               tween: Tween(begin: 0.0, end: 1.0),
//                               curve: Curves.easeOutBack,
//                               builder: (context, value, child) {
//                                 return Transform.scale(
//                                   scale: value,
//                                   child: Opacity(opacity: value, child: child),
//                                 );
//                               },
//                               child: GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     if (isSelected) {
//                                       _selectedGenres.remove(genre);
//                                     } else {
//                                       _selectedGenres.add(genre);
//                                     }
//                                   });
//                                 },
//                                 child: AnimatedContainer(
//                                   duration: const Duration(milliseconds: 250),
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: 4.w,
//                                     vertical: 1.5.h,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: isSelected
//                                         ? Theme.of(context).colorScheme.primary
//                                         : Colors.black54,
//                                     borderRadius: BorderRadius.circular(30),
//                                     border: Border.all(
//                                       color: isSelected
//                                           ? Theme.of(
//                                               context,
//                                             ).colorScheme.primary
//                                           : Colors.white24,
//                                       width: 1.5,
//                                     ),
//                                   ),
//                                   child: Text(
//                                     genre,
//                                     style: TextStyle(
//                                       color: isSelected
//                                           ? Colors.white
//                                           : Colors.white70,
//                                       fontSize: 12.sp,
//                                       fontWeight: isSelected
//                                           ? FontWeight.bold
//                                           : FontWeight.normal,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//             Positioned(
//               top: 0,
//               right: 0,
//               child: TextButton(
//                 onPressed: () {
//                   // Navigate to main app
//                 },
//                 child: Text(
//                   'Skip',
//                   style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),

//             Positioned(
//               bottom: 5.h,
//               right: 5.w,
//               left: 5.w,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   AnimatedSwitcher(
//                     duration: Duration(milliseconds: 800),
//                     transitionBuilder: (child, animation) {
//                       return FadeTransition(
//                         opacity: animation,
//                         child: SlideTransition(
//                           position: Tween<Offset>(
//                             begin: const Offset(0, 0.2),
//                             end: Offset.zero,
//                           ).animate(animation),
//                           child: child,
//                         ),
//                       );
//                     },

//                     child: !_next
//                         ? Text(
//                             'Tell us your favourite genre',
//                              key: const ValueKey('tell_us'),
//                             style: Theme.of(context).textTheme.headlineSmall
//                                 ?.copyWith(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                             textAlign: TextAlign.center,
//                           )
//                         : Text(
//                             'Choose at least one genre to get started',
//                              key: const ValueKey('choose_genre'),
//                             style: Theme.of(context).textTheme.headlineSmall
//                                 ?.copyWith(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                             textAlign: TextAlign.center,
//                           ),
//                   ),

//                   SizedBox(height: 2.h),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (_next) {
//                         // Navigate to main app or validate selection
//                         if (_selectedGenres.isEmpty) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Please select at least one genre'),
//                             ),
//                           );
//                         } else {}
//                       } else {
//                         setState(() {
//                           _next = true;
//                         });
//                         _fadeController.forward();
//                         _slideController.forward();
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       fixedSize: Size(90.w, 6.h),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: Text(
//                       _next ? 'Get Started' : 'Next',
//                       style: TextStyle(
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 2.h),

//                   // bottom indicators
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         width: 10.w,
//                         height: 4,
//                         decoration: BoxDecoration(
//                           color: !_next
//                               ? Theme.of(context).colorScheme.primary
//                               : Colors.grey,
//                           borderRadius: BorderRadius.circular(2),
//                         ),
//                       ),
//                       SizedBox(width: 2.w),
//                       Container(
//                         width: 10.w,
//                         height: 4,
//                         decoration: BoxDecoration(
//                           color: _next
//                               ? Theme.of(context).colorScheme.primary
//                               : Colors.grey,
//                           borderRadius: BorderRadius.circular(2),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sizer/sizer.dart';

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
    'assets/movie1.jpg',
    'assets/movie2.jpg',
    'assets/movie3.jpg',
    'assets/movie4.jpg',
    'assets/movie5.jpg',
    'assets/movie6.jpg',
    'assets/movie7.jpg',
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

  @override
  void initState() {
    super.initState();

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

_slideAnimation = Tween<Offset>(
  begin: const Offset(0, 0.4),
  end: Offset.zero,
).animate(CurvedAnimation(
  parent: _slideController,
  curve: Curves.easeOutExpo,
));

    // auto scroll every 50ms
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_scrollController.hasClients) {
        double nextOffset = _scrollController.offset + _scrollSpeed * 0.05;

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
      itemCount: 100,
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
                top: 15.h,
                right: 5.w,
                left: 5.w,
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
                        SizedBox(height: 3.h),
                        // Wrap(
                        //   alignment: WrapAlignment.center,
                        //   spacing: 2.w,
                        //   runSpacing: 1.5.h,
                        //   children: _genres.map((genre) {
                        //     final isSelected = _selectedGenres.contains(genre);

                        //     return GestureDetector(
                        //       onTap: () {
                        //         setState(() {
                        //           if (isSelected) {
                        //             _selectedGenres.remove(genre);
                        //           } else {
                        //             _selectedGenres.add(genre);
                        //           }
                        //         });
                        //       },
                        //       child: AnimatedContainer(
                        //         duration: const Duration(milliseconds: 250),
                        //         padding: EdgeInsets.symmetric(
                        //           horizontal: 4.w,
                        //           vertical: 1.5.h,
                        //         ),
                        //         decoration: BoxDecoration(
                        //           color: isSelected
                        //               ? Theme.of(context).colorScheme.primary
                        //               : Colors.black54,
                        //           borderRadius: BorderRadius.circular(30),
                        //           border: Border.all(
                        //             color: isSelected
                        //                 ? Theme.of(context).colorScheme.primary
                        //                 : Colors.white24,
                        //             width: 1.5,
                        //           ),
                        //         ),
                        //         child: Text(
                        //           genre,
                        //           style: TextStyle(
                        //             color: isSelected
                        //                 ? Colors.white
                        //                 : Colors.white70,
                        //             fontSize: 12.sp,
                        //             fontWeight: isSelected
                        //                 ? FontWeight.bold
                        //                 : FontWeight.normal,
                        //           ),
                        //         ),
                        //       ),
                        //     );
                        //   }).toList(),
                        // ),

                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 2.w,
                          runSpacing: 1.5.h,
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
                                      horizontal: 4.w,
                                      vertical: 1.5.h,
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
                                        fontSize: 12.sp,
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

            // Skip button
            Positioned(
              top: 0,
              right: 0,
              child: TextButton(
                onPressed: () {
                  // Navigate to main app
                },
                child: Text(
                  'Skip',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Bottom section with animated text
            Positioned(
              bottom: 5.h,
              right: 5.w,
              left: 5.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 800),
                  transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position:
                              Tween<Offset>(
                                begin: const Offset(0, 0.2),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOutCubic,
                                ),
                              ),
                          child: child,
                        ),
                      );
                    },

                    child: !_next
                        ? Text(
                            'Tell us your favourite genre',
                            key: const ValueKey('tell_us'),
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          )
                        : const SizedBox.shrink(key: ValueKey('empty')),
                  ),
                  SizedBox(height: 2.h),
                  ElevatedButton(
                  onPressed: () async {
                      if (_next) {
                        if (_selectedGenres.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select at least one genre'),
                            ),
                          );
                        } else {
                          // Navigate to next screen
                        }
                      } else {
                        setState(() {
                          _next = true;
                        });

                        // Wait for bottom text exit
                        await Future.delayed(const Duration(milliseconds: 800));

                        // Play entry animations
                        _fadeController.forward();
                        _slideController.forward();

                        // Staggered reveal for genres
                        for (int i = 0; i < _genres.length; i++) {
                          await Future.delayed(
                            const Duration(milliseconds: 50),
                          );
                          setState(() {
                            _visibleGenreIndexes.add(i);
                          });
                        }
                      }
                    },


                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(90.w, 6.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _next ? 'Get Started' : 'Next',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        width: 10.w,
                        height: 4,
                        decoration: BoxDecoration(
                          color: !_next
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        width: 10.w,
                        height: 4,
                        decoration: BoxDecoration(
                          color: _next
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
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
