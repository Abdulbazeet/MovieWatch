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

class _TabScreenState extends ConsumerState<TabScreen>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(keepPage: true);
    _tabController = TabController(length: 2, vsync: this);
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
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              onTap: animateToPage,
              // indicator: BoxDecoration(
              //   color: Theme.of(context).colorScheme.primary,
              //   borderRadius: BorderRadius.circular(18),
              // ),
              indicatorPadding: const EdgeInsets.all(4),
              labelColor: Colors.black87,
              unselectedLabelColor: Colors.black87,
              labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
              unselectedLabelStyle:
                  Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,

                      ),
                      dividerColor: Colors.transparent,
                    
              tabs: const [
                Tab(text: 'Movies'),
                Tab(text: 'TV Shows'),
              ],
            ),
            Expanded(
              child: PageView(
                key: const PageStorageKey('tab_page_view'),
                controller: _pageController,
                onPageChanged: (value) {
                  _tabController.animateTo(value);
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
