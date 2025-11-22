import 'package:flutter/material.dart';
 
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Widget profilesettigs({
    required String title,
    required List<String> subtitles,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 20 , top: 10 ),
          padding: EdgeInsets.symmetric(vertical: 10 , horizontal: 10 ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(10 ),
          ),
          child: ListView.builder(
            itemCount: subtitles.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                margin: index < subtitles.length - 1
                    ? EdgeInsets.only(bottom: 10 )
                    : null,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        subtitles[index],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, size: 15 ),
                  ],
                ),
              );
            },
          ),
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
        padding: EdgeInsets.symmetric(horizontal: 20 , vertical: 20 ),
        child: ListView(
          children: [
            profilesettigs(
              subtitles: [
                'Edit profile',
                'Email & passord',
                'Manage linked accounts',
                'Language & region',
              ],
              title: 'Profile',
            ),
            SizedBox(height: 20 ),
            profilesettigs(
              title: 'Preference',
              subtitles: [
                'Notifications',
                'Theme & appearance',
                'Content filters',
                'Playback rediretion',
              ],
            ),
            SizedBox(height: 20 ),
            profilesettigs(
              title: 'Billing & Monetization',
              subtitles: [
                'Subscription status',
                'Upgrade / manage plans',
                'Redeem code',
              ],
            ),
            SizedBox(height: 20 ),
            profilesettigs(
              title: 'Support & About',
              subtitles: [
                'Help center / FAQs',
                'Contact support',
                'Report a problem',
                'Privacy policy & terms',
                'App version 7 credits',
              ],
            ),
          ],
        ),
      ),
    );
  }
}
