import 'package:comfi/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  // loading duration
  Duration get loadingTime => const Duration(milliseconds: 2000);

  // Login
  Future<String?> _authUser(LoginData data) {
    return Future.delayed(loadingTime).then((value) => null);
  }

  // Recover Password
  Future<String?> _recoverPassword(String name) {
    return Future.delayed(loadingTime).then((value) => null);
  }

  // sign up
  Future<String?> _signupUser(SignupData data) {
    return Future.delayed(loadingTime).then((value) => null);
  }
  // Future<String?> _homePage(String name) {
  //   return Future.delayed(loadingTime).then((value)=> null);
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.amber,
      home: Scaffold(
        body: FlutterLogin(
          title: 'Comfi',
          navigateBackAfterRecovery: true,
          onLogin: _authUser,
          onRecoverPassword: _recoverPassword,
          onSignup: _signupUser,
          loginAfterSignUp: true,

          onSubmitAnimationCompleted: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
      ),
    );
  }
}
