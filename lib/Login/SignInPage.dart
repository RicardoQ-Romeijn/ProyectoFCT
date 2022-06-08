// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/Utils.dart';
import 'package:flutter_application/Views/MainPage.dart';

class SignInWidget extends StatefulWidget {
  final VoidCallback onClickedSignIn;

  const SignInWidget({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  final emailController = TextEditingController(text: 'admin@experience.com');
  final passwordController = TextEditingController(text: 'administrador');

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 40),
          TextField(
            controller: emailController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          SizedBox(height: 4),
          TextField(
            controller: passwordController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(50),
            ),
            icon: Icon(Icons.lock_open, size: 32),
            label: Text(
              'Sign In',
              style: TextStyle(fontSize: 24),
            ),
            onPressed: signIn,
          ),
          SizedBox(height: 24),
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 20),
              text: 'No Account? ',
              children: [
                TextSpan(
                  text: 'Sign Up',
                  recognizer: TapGestureRecognizer()
                    ..onTap = widget.onClickedSignIn,
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 20),
              text: 'Sign In Anonymously? ',
              children: [
                TextSpan(
                  text: 'Continue',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => FirebaseAuth.instance.signInAnonymously(),
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e);
      }

      Utils.showSnackBar(e.message);
    }
  }
}
