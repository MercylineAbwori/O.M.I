import 'package:flutter/material.dart';
import 'package:one_million_app/components/signin/login_screen.dart';
import 'package:one_million_app/core/constant_service.dart';
import 'package:one_million_app/shared/constants.dart';

class ForgotPassword extends StatefulWidget {

  final String phone;
  
  const ForgotPassword(
      {super.key,
      required this.phone,});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool _isButtonDisabled = false;
  String _buttonText = 'Submit';

  TextEditingController pinController = TextEditingController();
  TextEditingController pinConfirmController = TextEditingController();

  String? _pinErrorText;

  String? _confirmPinErrorText;

  
  bool isLoading = false;

  Future<void> _submitForm() async {
    if (!_isButtonDisabled) {
      setState(() {
        _isButtonDisabled = true;
        _buttonText = 'Loading...';
      }); // Perform the action that the button triggers here

      Future.delayed(const Duration(seconds: 5), () async {
        // if (formKey.currentState!.validate()) {
        // Form is valid, proceed with your logic here
        // For this example, we will simply print the email


        // Form is valid, proceed with your logic here
      // For this example, we will simply print the email
      print('Pin: ${pinController.text}');
      print('Confirm Pin: ${pinConfirmController.text}');

      await ApiService().PostResetPassword(
        widget.phone,
        pinController.text,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return LoginScreen(
            );
          },
        ),
      ); 

        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            isLoading = false;
          });
        });

        
        // }
        setState(() {
          _isButtonDisabled = false;
          _buttonText = 'Submit';
        });
      });
    }
  }


  bool passwordVisiblePin = false;
  bool passwordVisibleConfirmPin = false;




  @override
  void initState() {
    super.initState();
    passwordVisiblePin = true;
    passwordVisibleConfirmPin = true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff7f6fb),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 32,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/logos/slide_five.png',
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                'Forgot Pin',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Enter your new pin",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 28,
              ),
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Form(
                  key: formkey,
                  child: Column(
                    children: [
                      
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 15, bottom: 0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          // obscureText: true,
                          obscureText: passwordVisiblePin,
                          controller: pinController,
                          decoration: InputDecoration(
                            border: myinputborder(),
                            labelText: 'Pin',
                            hintText: 'Enter secure pin',
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(defaultPadding),
                              child: Icon(Icons.lock, color: kPrimaryColor),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(passwordVisiblePin
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(
                                  () {
                                    passwordVisiblePin = !passwordVisiblePin;
                                  },
                                );
                              },
                            ),
                            errorText: _pinErrorText,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              setState(() {
                                _pinErrorText = "* Required";
                              });
                            }
                            // else if (value.length < 4) {
                            //   _pinErrorText = "Password should be atleast 4 characters";
                            // }
                            else if (value.length > 4) {
                              setState(() {
                                _pinErrorText = "Password should not be greater than 4 characters";
                              });
                            } else {
                              setState(() {
                                _pinErrorText = null;
                              });
                            }
                          }, //Function to check validation
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 15, bottom: 0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          obscureText: passwordVisiblePin,
                          controller: pinConfirmController,
                          decoration: InputDecoration(
                            border: myinputborder(),
                            labelText: 'Confirm Pin',
                            hintText: 'Repeat the pin to confirm',
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(defaultPadding),
                              child: Icon(Icons.lock, color: kPrimaryColor),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(passwordVisibleConfirmPin
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(
                                  () {
                                    passwordVisibleConfirmPin =
                                        !passwordVisibleConfirmPin;
                                  },
                                );
                              },
                            ),
                            errorText: _confirmPinErrorText,
                          ),
                          validator: (value) {
                            if (value == pinController) {
                              setState(() {
                                _confirmPinErrorText = "Does not match the Pin";
                              });
                            } else {
                              setState(() {
                                _confirmPinErrorText = null;
                              });
                            }
                          }, //Function to check validation
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isButtonDisabled ? null : _submitForm,
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            // shape:
                            //     MaterialStateProperty.all<RoundedRectangleBorder>(
                            //   RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(24.0),
                            //   ),
                            // ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Text(
                              'Submit',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget _textFieldOTP({bool? first, last}) {
    return Container(
      height: 85,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: kPrimaryColor),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
  OutlineInputBorder myinputborder() {
    //return type is OutlineInputBorder
    return const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 0),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ));
  }
}