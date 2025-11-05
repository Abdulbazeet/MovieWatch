import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Spacer(),

                    InkWell(
                      //  borderRadius: BorderRadius.circular(3.w),
                      onTap: () async {
                        SharedPreferences sp =
                            await SharedPreferences.getInstance();
                        sp.setBool('skipOnboard', true);
                        context.go('/bottom-bar');
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
                SizedBox(height: 20.h),
                Text('Sign in', style: Theme.of(context).textTheme.bodyLarge),
                SizedBox(height: 20.h),
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
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    border: OutlineInputBorder(
                      /// borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    // errorBorder: OutlineInputBorder(
                    //   /// borderSide: BorderSide(color: Colors.grey),
                    //   borderRadius: BorderRadius.circular(3.w),

                    // ),
                    focusedBorder: OutlineInputBorder(
                      /// borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.r),
                    ),

                    hint: Text(
                      'Email',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
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
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      /// borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.r),
                    ), // errorBorder: OutlineInputBorder(

                    focusedBorder: OutlineInputBorder(
                      /// borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.r),
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

                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Sign in'),
                  
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(child: Divider()),
                    SizedBox(width: 10.w),
                    Text('Or', style: Theme.of(context).textTheme.bodyMedium),
                    SizedBox(width: 10.w),
                    Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size.fromHeight(6.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surface,
                        ),
                        onPressed: () {},
                        child: Image.asset('assets/icons/facebook (1).png'),
                      ),
                    ),

                    SizedBox(width: 20.w),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size.fromHeight(6.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surface,
                        ),
                        onPressed: () {},
                        child: Image.asset('assets/icons/gmail.png'),
                      ),
                    ),
                    SizedBox(width: 20.w),

                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size.fromHeight(6.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
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
                SizedBox(height: 40.h),
                Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Don\'t have an account? ',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.normal),
                        ),
                        TextSpan(
                          text: 'Sign up',
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.go('/sign-up');
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
