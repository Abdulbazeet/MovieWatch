import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _visible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.sw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.sh),
                Row(
                  children: [
                    Spacer(),

                    InkWell(
                      onTap: () async {
                        SharedPreferences sp =
                            await SharedPreferences.getInstance();
                        sp.setBool('skipOnboard', true);
                        context.go('/home');
                      },
                      child: Text(
                        'Skip',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.sh),
                Text('Sign up', style: Theme.of(context).textTheme.bodyLarge),
                SizedBox(height: 3.sh),
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      /// borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(3.sw),
                    ),
                    border: OutlineInputBorder(
                      /// borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(3.sw),
                    ),
                    // errorBorder: OutlineInputBorder(
                    //   /// borderSide: BorderSide(color: Colors.grey),
                    //   borderRadius: BorderRadius.circular(3.sw),

                    // ),
                    focusedBorder: OutlineInputBorder(
                      /// borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(3.sw),
                    ),

                    hint: Text(
                      'Email',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                    ),
                  ),
                ),
                SizedBox(height: 3.sh),
                TextField(
                  controller: _password,
                  keyboardType: TextInputType.emailAddress,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  obscureText: _visible,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      /// borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(3.sw),
                    ),
                    enabledBorder: OutlineInputBorder(
                      /// borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(3.sw),
                    ), // errorBorder: OutlineInputBorder(
                    //   /// borderSide: BorderSide(color: Colors.grey),
                    //   borderRadius: BorderRadius.circular(3.sw),

                    // ),
                    focusedBorder: OutlineInputBorder(
                      /// borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(3.sw),
                    ),

                    hint: Text(
                      'Password',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _visible = !_visible;
                        });
                      },
                      icon: Icon(
                        _visible ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 3.sh),
                Row(
                  children: [
                    Spacer(),

                    InkWell(
                      //  borderRadius: BorderRadius.circular(3.sw),
                      onTap: () {},
                      child: Text(
                        'Forgot password ?',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.sh),
                ElevatedButton(
                  onPressed: () {},
                  

                  child: Text('Sign up'),
                ),
                SizedBox(height: 3.sh),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'By clicking the “sign up” button, you accept the terms of the ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.sh),
                Row(
                  children: [
                    Expanded(child: Divider()),
                    SizedBox(width: 2.sw),
                    Text('Or', style: Theme.of(context).textTheme.bodyMedium),
                    SizedBox(width: 2.sw),
                    Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: 3.sh),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size.fromHeight(6.sh),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surface,
                        ),
                        onPressed: () {},
                        child: Image.asset('assets/icons/facebook (1).png'),
                      ),
                    ),

                    SizedBox(width: 6.sw),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size.fromHeight(6.sh),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surface,
                        ),
                        onPressed: () {},
                        child: Image.asset('assets/icons/gmail.png'),
                      ),
                    ),
                    SizedBox(width: 6.sw),

                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size.fromHeight(6.sh),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surface,
                        ),
                        onPressed: () {},
                        child: Image.asset('assets/icons/apple-logo.png'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 31.sh),
                Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'ALready have an account ',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: 'Sign in',
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.go('/sign-in');
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
