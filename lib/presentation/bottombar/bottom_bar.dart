import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_watch/config/utils.dart';
import 'package:movie_watch/presentation/profile/profile.dart';
import 'package:movie_watch/presentation/search/search.dart';
import 'package:movie_watch/presentation/tab_bar/tab_bar.dart';
import 'package:movie_watch/presentation/watchlist/screen/watchlist.dart';

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class Bottombar extends ConsumerWidget {
  const Bottombar({super.key});

  void _onTap(WidgetRef ref, int index) {
    ref.read(bottomNavIndexProvider.notifier).state = index;
  }

  Widget _bottomItems({
    required WidgetRef ref,
    required String image,
    required int index,
  }) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final isSelected = currentIndex == index;
    return InkWell(
      onTap: () => _onTap(ref, index),
      child: SizedBox(
        height: 59,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SvgPicture.asset(
            'assets/svg/$image.svg',
            height: 17,
            width: 17,
            colorFilter: isSelected
                ? ColorFilter.mode(
                    Theme.of(ref.context).colorScheme.primary,
                    BlendMode.srcIn,
                  )
                : ColorFilter.mode(
                    Theme.of(ref.context).colorScheme.onSurface,
                    BlendMode.srcIn,
                  ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(bottomNavIndexProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          Positioned.fill(
            child: IndexedStack(
              index: index,
              children: const [
                TabScreen(),
                Search(),
                Watchlist(),
                Profile(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _bottomItems(ref: ref, image: 'home', index: 0),
                    _bottomItems(ref: ref, image: 'search', index: 1),
                    _bottomItems(ref: ref, image: 'bookmark', index: 2),
                    _bottomItems(ref: ref, image: 'user', index: 3),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
