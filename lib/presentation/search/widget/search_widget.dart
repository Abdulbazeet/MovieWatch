import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final String media_type;
  final Widget child;
  const SearchWidget({
    super.key,
    required this.media_type,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30),
        Row(
          children: [
            SizedBox(
              height: 29,
              child: VerticalDivider(
                color: Theme.of(context).colorScheme.primary,
                thickness: 4,
              ),
            ),
            SizedBox(width: 10),
            Text(media_type, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.all(10),

            //   height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: .4),
                width: 1,
              ),
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}
