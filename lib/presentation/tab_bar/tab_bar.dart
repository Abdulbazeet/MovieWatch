import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_watch/presentation/anime/anime.dart';
import 'package:movie_watch/presentation/kdrama/kdama.dart';
import 'package:movie_watch/presentation/movies_screen/movies_screen.dart';
import 'package:movie_watch/presentation/tvshows/tvshows.dart';
import 'package:palette_generator_master/palette_generator_master.dart';

class TabScreen extends ConsumerStatefulWidget {
  const TabScreen({super.key});

  @override
  ConsumerState<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends ConsumerState<TabScreen> {
  late final PageController _pageController;

  int page = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(keepPage: true);
  }

  void changePage(int _page) {
    if (page == _page) {
      return;
    }
    setState(() {
      page = _page;
    });
  }

  void animateToPage(int _page) {
    _pageController.animateToPage(
      _page,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        animateToPage(0);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        decoration: BoxDecoration(
                          color: page == 0
                              ? Theme.of(context).colorScheme.primary
                              : null,
                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: Text(
                          'Movies',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: page == 0 ? Colors.white : Colors.black,
                              ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        animateToPage(1);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        decoration: BoxDecoration(
                          color: page == 1
                              ? Theme.of(context).colorScheme.primary
                              : null,
                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: Text(
                          'Tv Shows',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: page == 1 ? Colors.white : Colors.black,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                key: const PageStorageKey('tab_page_view'),
                controller: _pageController,
                onPageChanged: (value) {
                  changePage(value);
                },
                children: [MovieScreen(), TvShows()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
