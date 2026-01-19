import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_watch/config/utils.dart';
import 'package:movie_watch/presentation/profile/profile.dart';
import 'package:movie_watch/presentation/search/search.dart';
import 'package:movie_watch/presentation/tab_bar/tab_bar.dart';
import 'package:movie_watch/presentation/watchlist/watchlist.dart';

class Bottombar extends StatefulWidget {
  const Bottombar({super.key});

  @override
  State<Bottombar> createState() => _BottombarState();
}

class _BottombarState extends State<Bottombar> {
  int _index = 2;
  void _onTap(int index) {
    setState(() {
      _index = index;
    });
  }

  Widget _bottomItems({required String image, required int index}) {
    bool isSelected = _index == index;
    return InkWell(
      onTap: () => _onTap(index),
      child: SizedBox(
        height: 59,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          // height: double.infinity,
          // margin: EdgeInsets.symmetric(vertical: 0),
          //  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          // decoration: BoxDecoration(
          //   color: Theme.of(context).colorScheme.primary,
          //   borderRadius: BorderRadius.circular(60),
          // ),
          child: SvgPicture.asset(
            // 'assets/svg/$image.svg',
            'assets/svg/$image.svg',
            height: 17,
            width: 17,
            colorFilter: isSelected
                ? ColorFilter.mode(
                    Theme.of(context).colorScheme.primary,
                    BlendMode.srcIn,
                  )
                : ColorFilter.mode(
                    Theme.of(context).colorScheme.onSurface,
                    BlendMode.srcIn,
                  ),
          ),
        ),
      ),
    );

    //   ),
    // );
  }

  final List<Widget> _body = [TabScreen(), Search(), Watchlist(), Profile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          Positioned.fill(child: _body[_index]),
          Align(
            alignment: Alignment.bottomCenter,

            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Container(
                height: 60,

                // padding: _index == 0
                //     ? EdgeInsets.symmetric(
                //         horizontal: 20,
                //         vertical: 4,
                //       ).copyWith(left: 5)
                //     : _index == 3
                //     ? EdgeInsets.symmetric(
                //         horizontal: 20,
                //         vertical: 4,
                //       ).copyWith(right: 5)
                //     : EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _bottomItems(image: 'home', index: 0),
                    _bottomItems(image: 'search', index: 1),

                    _bottomItems(image: 'bookmark', index: 2),
                    _bottomItems(image: 'user', index: 3),
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
