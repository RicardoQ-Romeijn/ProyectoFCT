import 'package:flutter/widgets.dart';
import 'package:flutter_application/Login/SignUpPage.dart';
import 'package:flutter_application/Login/SignInPage.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin ? SignInWidget(onClickedSignIn: toggle) : SignUpWidget(onClickedSignUp: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
