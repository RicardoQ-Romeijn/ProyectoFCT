// ignore_for_file: prefer_const_constructors

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/Utils.dart';

class SignUpWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const SignUpWidget({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  @override
  State<SignUpWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
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
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            TextFormField(
              controller: emailController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: 'Email'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) =>
                  email != null && !EmailValidator.validate(email)
                      ? 'Enter a valid email'
                      : null,
            ),
            SizedBox(height: 4),
            TextFormField(
              controller: passwordController,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value != null && value.length < 6
                  ? 'Enter min. 6 characters'
                  : null,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50),
              ),
              icon: Icon(Icons.arrow_circle_right_outlined, size: 32),
              label: Text(
                'Sign Up',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: signUp,
            ),
            SizedBox(height: 24),
            RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black, fontSize: 20),
                text: 'Already have an account? ',
                children: [
                  TextSpan(
                    text: 'Sign In',
                    recognizer: TapGestureRecognizer()
                      ..onTap = widget.onClickedSignUp,
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
