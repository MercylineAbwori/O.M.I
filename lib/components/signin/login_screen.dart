import 'package:flutter/material.dart';
import 'package:one_million_app/components/onbording_screens/background.dart';
import 'package:one_million_app/shared/responsive.dart';
import 'components/login_form.dart';
import 'components/login_screen_top_image.dart';

class LoginScreen extends StatelessWidget {

  final String promotionCode;
  
  const LoginScreen({Key? key, required this.promotionCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileLoginScreen(promotionCode: promotionCode),
          desktop: const Row(
            children: [
              Expanded(
                child: LoginScreenTopImage(),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(
                    //   width: 450,
                    //   child: LoginForm(),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MobileLoginScreen extends StatelessWidget {

  final String promotionCode;

  const MobileLoginScreen({
    Key? key,
    required this.promotionCode
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const LoginScreenTopImage(),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: LoginPage(promotionCode : promotionCode),
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}
