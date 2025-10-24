import 'package:flutter/material.dart';
import 'package:movie_watch/presentation/movies_screen/movies_screen.dart';
import 'package:movie_watch/presentation/profile/profile.dart';
import 'package:movie_watch/presentation/search/search.dart';
import 'package:movie_watch/presentation/tab_bar/tab_bar.dart';
import 'package:movie_watch/presentation/watchlist/watchlist.dart';
import 'package:sizer/sizer.dart';

class Bottombar extends StatefulWidget {
  const Bottombar({super.key});

  @override
  State<Bottombar> createState() => _BottombarState();
}

class _BottombarState extends State<Bottombar> {
  int _index = 0;
  void _onTap(int index) {
    setState(() {
      _index = index;
    });
  }

  Widget _bottomItems({
    required String image,
    required String title,
    required int index,
  }) {
    bool isSelected = _index == index;
    return AnimatedSwitcher(
      reverseDuration: Duration(milliseconds: 300),
      switchInCurve: Curves.easeInCubic,
      switchOutCurve: Curves.easeOutCubic,
      duration: Duration(milliseconds: 300),

      child: isSelected
          ? InkWell(
              key: ValueKey(isSelected),
              onTap: () => _onTap(index),
              child: Container(
                height: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 1.h),
                padding: EdgeInsets.symmetric(horizontal: 4.sw),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(3.sw),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/$image.png',
                      height: 3.h,
                      width: 3.h,
                      color: isSelected
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                    SizedBox(width: 0.5.h),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: isSelected
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : InkWell(
              key: ValueKey(isSelected),
              onTap: () => _onTap(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/$image.png',
                    height: 3.h,
                    width: 3.h,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  final List<Widget> _body = [TabScreen(), Search(), Watchlist(), Profile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          Positioned.fill(child: _body[_index]),
          Positioned(
            right: 6.sw,
            left: 6.sw,
            bottom: 6.sh,

            child: Container(
              height: 8.5.sh,

              padding: _index == 0
                  ? EdgeInsets.symmetric(horizontal: 6.sw).copyWith(left: 1.h)
                  : _index == 3
                  ? EdgeInsets.symmetric(horizontal: 6.sw).copyWith(right: 1.h)
                  : EdgeInsets.symmetric(horizontal: 6.sw),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.sw),
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _bottomItems(image: 'home', title: 'Home', index: 0),
                  _bottomItems(image: 'search', title: 'Search', index: 1),

                  _bottomItems(
                    image: 'bookmark (1)',
                    title: 'Watchlist',
                    index: 2,
                  ),
                  _bottomItems(image: 'user', title: 'Profile', index: 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
