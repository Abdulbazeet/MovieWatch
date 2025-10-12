import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

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
            padding: EdgeInsets.symmetric(horizontal: 4.sw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.sh),
                Row(
                  children: [
                    Spacer(),

                    // TextButton(
                    //   style: TextButton.styleFrom(
                    //    // padding: EdgeInsets.zero
                    //    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    //   ),
                    //   onPressed: () {},

                    //   chi
                    // ld:
                    // ),
                    InkWell(
                      //  borderRadius: BorderRadius.circular(3.sw),
                      onTap: () {
                        context.go('/home');
                      },
                      child: Text(
                        'Skip',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Material(
                    //   borderRadius: BorderRadius.circular(3.sw),
                    //   child: InkWell(onTap: () {},
                    //   child: Text('Skip', style: Theme.of(context).textTheme.bodyMedium,),
                    //   ),

                    // ),
                  ],
                ),
                SizedBox(height: 3.sh),
                Text('Sign in', style: Theme.of(context).textTheme.bodyLarge),
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
                  // onChanged: (value) {
                  //   if (!value.contains('@')) {
                  //    // return 'invalid mail';
                  //   }
                  // },
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
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(90.sw, 6.sh),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  child: Text('Sign in'),
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
                        child: Image.asset('assets/facebook (1).png'),
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
                        child: Image.asset('assets/gmail.png'),
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
                        child: Image.asset('assets/apple-logo.png'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40.sh),
                Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Don\'t have an account? ',
                          style: Theme.of(context).textTheme.bodyMedium,
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
