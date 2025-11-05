import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Widget profilesettigs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 20.r, top: 10.r),
          padding: EdgeInsets.symmetric(vertical: 10.r, horizontal: 10.r),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: ListView.builder(
            itemCount: 2,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Expanded(
                    child: Text(
                      'Edit profile',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, size: 15.r),
                ],
              );
            },
          ),

          // Column(
          //   children: [

          //     SizedBox(height: 10.r),
          //     Row(
          //       children: [
          //         Expanded(
          //           child: Text(
          //             'Change Linked Account',
          //             style: Theme.of(context).textTheme.bodySmall?.copyWith(
          //               color: Theme.of(context).colorScheme.onSurface,
          //             ),
          //           ),
          //         ),
          //         Icon(Icons.arrow_forward_ios_rounded, size: 15.r),
          //       ],
          //     ),
          //   ],
          // ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: Theme.of(context).textTheme.bodyLarge),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 20.r),
        child: ListView(
          children: [
            profilesettigs(),
            SizedBox(height: 20.r),
          ],
        ),
      ),
    );
  }
}
