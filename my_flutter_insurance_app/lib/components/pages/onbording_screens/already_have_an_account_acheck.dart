import 'package:flutter/material.dart';
import 'package:one_million_app/shared/constants.dart';
class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function? press;
  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Don’t have an Account ? " : "Already have an Account ? ",
          style: const TextStyle(color: kPrimaryColor),
        ),
        GestureDetector(
          onTap: press as void Function()?,
          child: Text(
            login ? "Sign Up" : "Sign In",
            style: const TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}

class ForgotPasswordCheck extends StatelessWidget {
  final bool login;
  final Function? press;
  const ForgotPasswordCheck({
    Key? key,
    this.login = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        
        GestureDetector(
          onTap: press as void Function()?,
          child: const Text(
            "Forgot Password ? ",
            style: TextStyle(
              color: kPrimaryColor
            ),
          ),
        )
        
      ],
    );
  }
}

class ViewAll extends StatelessWidget {
  final bool login;
  final Function? press;
  const ViewAll({
    Key? key,
    this.login = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        
        GestureDetector(
          onTap: press as void Function()?,
          child: const Text(
            "View All",
            style: TextStyle(
              color: kPrimaryColor
            ),
          ),
        )
        
      ],
    );
  }
}

class ResendCode extends StatelessWidget {
  final bool login;
  final Function? press;
  const ResendCode({
    Key? key,
    this.login = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        
        GestureDetector(
          onTap: press as void Function()?,
          child: const Text(
            "Resend New Code",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        )
        
      ],
    );
  }
}
