import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:one_million_app/components/onbording_screens/already_have_an_account_acheck.dart';
import 'package:one_million_app/components/signin/login_screen.dart';
import 'package:one_million_app/core/constant_service.dart';
import 'package:one_million_app/core/model/user_model.dart';
import 'package:one_million_app/shared/constants.dart';
import 'package:provider/provider.dart';

//constants
const buttonTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w900,
  
);

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserModal>(
      create: (context) => UserModal(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Consumer<UserModal>(
          builder: (context, modal, child) {
            switch (modal.activeIndex) {
              case 0:
                return const BasicDetails();
              case 1:
                return const IDUploadDetails();
              case 2:
                return const DrivingLincenseDetails();
              case 3:
                return const LogbookDetails();

              default:
                return const BasicDetails();
            }
          },
        ),
      ),
    );
  }
}

/// Widget for Basic details
class BasicDetails extends StatefulWidget {
  const BasicDetails({Key? key}) : super(key: key);

  @override
  _BasicDetailsState createState() => _BasicDetailsState();
}

class _BasicDetailsState extends State<BasicDetails> {
  GlobalKey<FormState> basicFormKey = GlobalKey<FormState>();

   TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController passwordontroller = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();


  String initialCountry = 'KE';

  FocusNode nameNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  FocusNode genderNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode passwordConfirmNode = FocusNode();
  FocusNode dateOfBirthNode = FocusNode();

  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModal>(builder: (context, modal, child) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: basicFormKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    cursorColor: kPrimaryColor,
                    controller: nameController,
                    focusNode: nameNode,
                    onSaved: (name) {},
                    decoration: InputDecoration(
                      labelText: "Your Name",
                      labelStyle: TextStyle(
                      color:  nameNode.hasFocus ? kPrimaryColor : Colors.grey   
                      ),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(defaultPadding),
                        child: Icon(Icons.person, color: kPrimaryColor),
                      ),
                      border: myinputborder(),
                      enabledBorder: myinputborder(),
                      focusedBorder: myfocusborder(),
                    ),
                    validator: RequiredValidator(
                      errorText: "Required *",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      cursorColor: kPrimaryColor,
                      controller: emailController,
                      focusNode: emailNode,
                      onSaved: (email) {},
                      decoration: InputDecoration(
                        labelText: "Your email",
                        labelStyle: TextStyle(
                          color:  emailNode.hasFocus ? kPrimaryColor : Colors.grey   
                        ),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          child: Icon(Icons.mail, color: kPrimaryColor),
                        ),
                        border: myinputborder(),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                      ),
                      validator: MultiValidator([
                        RequiredValidator(
                          errorText: "Required *",
                        ),
                        EmailValidator(
                          errorText: "Not Valid Email",
                        ),
                      ])),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: IntlPhoneField(
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next, 
                    cursorColor: kPrimaryColor,
                    controller: phoneController,
                    onSaved: (phone) {},
                    focusNode: phoneNode,
                    decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(
                          color:  phoneNode.hasFocus ? kPrimaryColor : Colors.grey   
                        ),
                        prefixIcon: const Padding(
                        padding: EdgeInsets.all(defaultPadding),
                        child: Icon(Icons.phone, color: kPrimaryColor,),
                      ),
                        border: myinputborder(),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                    ),
                    initialCountryCode: 'KE',
                    onChanged: (phone) {
                      print(phoneController);
                    },
                    validator: (value){
                          //allow upper and lower case alphabets and space
                          return "Enter your phone number should not start with a 0";
                      
                    },

                  ),
                  // TextFormField(
                  //     keyboardType: TextInputType.emailAddress,
                  //     textInputAction: TextInputAction.next,
                  //     cursorColor: kPrimaryColor,
                  //     onSaved: (phone) {},
                  //     decoration: InputDecoration(
                  //       labelText: "Your phone number",
                  //       prefixIcon: Padding(
                  //         padding: const EdgeInsets.all(defaultPadding),
                  //         child: Icon(Icons.phone),
                  //       ),
                  //       border: myinputborder(),
                  //       enabledBorder: myinputborder(),
                  //       focusedBorder: myfocusborder(),
                  //     ),
                  //     validator: MultiValidator([
                  //       RequiredValidator(
                  //         errorText: "Required *",
                  //       ),
                  //     ]
                  //   )
                  // ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: TextFormField(
                        focusNode: dateOfBirthNode,
                        decoration:  InputDecoration(
                          labelText: 'Date of Birth',
                          border: myinputborder(),
                          enabledBorder: myinputborder(),
                          focusedBorder: myfocusborder(),
                        ),
                        controller: dateOfBirthController,
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2050));

                          if (pickedDate != null) {
                            dateOfBirthController.text =pickedDate.toString();
                          }
                        },
                      ),
                ),
                SizedBox(width: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: DropdownButtonFormField<String>(
                    
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          hint: const Text(
                            'Gender',
                            style: TextStyle(fontSize: 17),
                          ),
                          value: dropdownValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                          validator: (value) => value == null
                              ? 'field required'
                              : null,
                          items: <String>['female', 'male']
                              .map<DropdownMenuItem<String>>(
                                  (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  
                                  Text(
                                    value,
                                  ),
                                ],
                              ),
                            );
                          }).toList()),
                ),
                SizedBox(width: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: Column(
                    children: [
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        cursorColor: kPrimaryColor,
                        controller: passwordontroller,
                        focusNode: passwordNode,
                        decoration: InputDecoration(
                          labelText: "Your password",
                          labelStyle: TextStyle(
                            color:  passwordNode.hasFocus ? kPrimaryColor : Colors.grey   
                          ),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(defaultPadding),
                            child: Icon(Icons.lock, color: kPrimaryColor),
                          ),
                          border: myinputborder(),
                          enabledBorder: myinputborder(),
                          focusedBorder: myfocusborder(),
                        ),
                        
                        // validator: MinLengthValidator(
                        //   6,
                        //   errorText: "Min 6 characters required",
                        // ),
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        cursorColor: kPrimaryColor,
                        controller: passwordConfirmController,
                        focusNode: passwordConfirmNode,
                        decoration: InputDecoration(
                          labelText: "Confirm password",
                          labelStyle: TextStyle(
                            color:  passwordConfirmNode.hasFocus ? kPrimaryColor : Colors.grey   
                          ),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(defaultPadding),
                            child: Icon(Icons.lock, color: kPrimaryColor),
                          ),
                          border: myinputborder(),
                          enabledBorder: myinputborder(),
                          focusedBorder: myfocusborder(),
                        ),
                        // validator: MinLengthValidator(
                        //   6, errorText: "Min 6 characters required",
                        // ),
                        validator: (value) {
                            if (passwordontroller != passwordConfirmController) {
                            return 'The password does not match';
                            }
                            MinLengthValidator(
                              6, errorText: "Min 6 characters required",
                            );
                          
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: defaultPadding / 2,
                ),
                SizedBox(
                  height: 40.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        fixedSize: const Size(200, 40)),
                    // onPressed: () {
                    //   if (basicFormKey.currentState?.validate() ?? false) {
                    //     // next
                    //     modal.changeStep(1);
                    //   }
                    // },
                    onPressed: () async {
                      await ApiService().addUsers(
                          nameController,
                          emailController,
                          phoneController,
                          dateOfBirthController,
                          dropdownValue,
                          passwordConfirmController,
                          passwordontroller
                          
                    );

                    },
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: defaultPadding / 2,
                ),
                const SizedBox(
                  height: 10,
                ),
                AlreadyHaveAnAccountCheck(
                  login: false,
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  OutlineInputBorder myinputborder(){ //return type is OutlineInputBorder
    return const OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.black, width: 0),
            borderRadius: BorderRadius.all(
            Radius.circular(8),
          )
        );
  }

  OutlineInputBorder myfocusborder(){
    return const OutlineInputBorder(
        borderSide: BorderSide(
            color: kPrimaryColor, width: 0),
            borderRadius: BorderRadius.all(
            Radius.circular(8),
          )
        );
  }
}

//Widget for ID Upload
class IDUploadDetails extends StatefulWidget {
  const IDUploadDetails({Key? key}) : super(key: key);

  @override
  _IDUploadDetailsState createState() => _IDUploadDetailsState();
}

class _IDUploadDetailsState extends State<IDUploadDetails> {
  GlobalKey<FormState> basicFormKey = GlobalKey<FormState>();

  File? _imageFrontId;
  File? _imageBackId;

  // Future getImageFrontID(ImageSource source) async {
  //   try{
  //   final image = await ImagePicker().pickImage(source: source);

  //   if(image == null) return;

  //   // final imageTemporary = File(image.path);
  //   final imagePermanent = await saveFilePermanently(image.path);

  //   setState(() {
  //     this._imageFrontId = imagePermanent;
  //   });
  //   } on PlatformException catch (e){
  //       print('Failed to pick image: $e');
  //   }
  // }
  // Future getImageBackID(ImageSource source) async {
  //   try{
  //   final image = await ImagePicker().pickImage(source: source);

  //   if(image == null) return;

  //   // final imageTemporary = File(image.path);
  //   final imagePermanent = await saveFilePermanently(image.path);

  //   setState(() {
  //     this._imageBackId = imagePermanent;
  //   });
  //   } on PlatformException catch (e){
  //       print('Failed to pick image: $e');
  //   }
  // }

  // Future<File> saveFilePermanently(String imagePath) async 
  // {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final name = basename(imagePath);
  //   final image = File("${directory.path}/$name");

  //   return File(imagePath).copy(image.path);
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModal>(builder: (context, modal, child) {
      return Card(
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: basicFormKey,
              child: Column(
                children: [
                  // Capture Front ID upload
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Front ID photo',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: DottedBorder(
                          color: Colors.black,
                          strokeWidth: 1,
                          radius: Radius.circular(30),
                          child: Center(
                            child: Column(
                              children: [
                                SizedBox(height: 20,),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: _imageFrontId != null ? Image.file(_imageFrontId!, width: 300, height: 250, fit: BoxFit.cover,) 
                                  : Image.asset('assets/images/upload_logo.png', width: 300, height: 250, fit: BoxFit.cover,),
                                ),
                                SizedBox(height: 20,),
                                Column(
                                  children: [
                                    // CustomButton(
                                    //   title: 'Pick from Gallery',
                                    //   icon: Icons.image_outlined,
                                    //   onClick: () => getImageFrontID(ImageSource.gallery),
                                    // ),
                                    // SizedBox(height: 10,),
                                    // CustomButton(
                                    //   title: 'Pick from Camera',
                                    //   icon: Icons.camera,
                                    //   onClick: () => getImageFrontID(ImageSource.camera),
                                    // ),
                                    SizedBox(height: 20,),
                                  ],
                                ),
                                
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  //Capture End ID upload
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'End ID photo',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: DottedBorder(
                          color: Colors.black,
                          strokeWidth: 1,
                          radius: Radius.circular(30),
                          child: Center(
                            child: Column(
                              children: [
                                SizedBox(height: 20,),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: _imageBackId != null ? Image.file(_imageBackId!, width: 300, height: 250, fit: BoxFit.cover,) 
                                  : Image.asset('assets/images/upload_logo.png', width: 300, height: 250, fit: BoxFit.cover,),
                                ),
                                SizedBox(height: 20,),
                                Column(
                                  children: [
                                    // CustomButton(
                                    //   title: 'Pick from Gallery',
                                    //   icon: Icons.image_outlined,
                                    //   onClick: () => getImageBackID(ImageSource.gallery),
                                    // ),
                                    // SizedBox(height: 10,),
                                    // CustomButton(
                                    //   title: 'Pick from Camera',
                                    //   icon: Icons.camera,
                                    //   onClick: () => getImageBackID(ImageSource.camera),
                                    // ),
                                    SizedBox(height: 20,),
                                  ],
                                ),
                                
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          fixedSize: const Size(200, 40)),
                      onPressed: () {
                        if (basicFormKey.currentState?.validate() ?? false) {
                          modal.changeStep(2);
                        }
                      },
                      child: Text("Next".toUpperCase()),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  AlreadyHaveAnAccountCheck(
                    login: false,
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginScreen();
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            )),
      );
    });
  }

  OutlineInputBorder myinputborder(){ //return type is OutlineInputBorder
    return const OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.black, width: 0),
            borderRadius: BorderRadius.all(
            Radius.circular(8),
          )
        );
  }

  OutlineInputBorder myfocusborder(){
    return const OutlineInputBorder(
        borderSide: BorderSide(
            color: kPrimaryColor, width: 0),
            borderRadius: BorderRadius.all(
            Radius.circular(8),
          )
        );
  }

  
}

//Class for Driving lincense
class DrivingLincenseDetails extends StatefulWidget {
  const DrivingLincenseDetails({Key? key}) : super(key: key);

  @override
  _DrivingLincenseDetailsState createState() => _DrivingLincenseDetailsState();
}

class _DrivingLincenseDetailsState extends State<DrivingLincenseDetails> {
  GlobalKey<FormState> basicFormKey = GlobalKey<FormState>();

  File? _image;

  // Future getImage(ImageSource source) async {
  //   try{
  //   final image = await ImagePicker().pickImage(source: source);

  //   if(image == null) return;

  //   // final imageTemporary = File(image.path);
  //   final imagePermanent = await saveFilePermanently(image.path);

  //   setState(() {
  //     this._image = imagePermanent;
  //   });
  //   } on PlatformException catch (e){
  //       print('Failed to pick image: $e');
  //   }
  // }

  // Future<File> saveFilePermanently(String imagePath) async 
  // {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final name = basename(imagePath);
  //   final image = File("${directory.path}/$name");

  //   return File(imagePath).copy(image.path);
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModal>(builder: (context, modal, child) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: basicFormKey,
            child: Column(
              children: [
                SizedBox(
                  width: 10,
                ),
                //Driving Licence upload
                Column(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'End ID photo',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ),
                        
                      ],
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: DottedBorder(
                        color: Colors.black,
                        strokeWidth: 1,
                        radius: Radius.circular(30),
                        child: Center(
                          child: Column(
                          children: [
                            SizedBox(height: 20,),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: _image != null ? Image.file(_image!, width: 300, height: 250, fit: BoxFit.cover,) 
                              : Image.asset('assets/images/upload_logo.png', width: 300, height: 250, fit: BoxFit.cover,),
                            ),
                            SizedBox(height: 20,),
                            Column(
                              children: [
                                // CustomButton(
                                //   title: 'Pick from Gallery',
                                //   icon: Icons.image_outlined,
                                //   onClick: () => getImage(ImageSource.gallery),
                                // ),
                                // SizedBox(height: 10,),
                                // CustomButton(
                                //   title: 'Pick from Camera',
                                //   icon: Icons.camera,
                                //   onClick: () => getImage(ImageSource.camera),
                                // ),
                                SizedBox(height: 20,),
                              ],
                            ),
                            
                          ],
                        ),
                      ),
                    ),
                    )
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        fixedSize: const Size(200, 40)),
                    onPressed: () {
                      if (basicFormKey.currentState?.validate() ?? false) {
                        modal.changeStep(3);
                      }
                    },
                    child: Text("Next".toUpperCase()),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                AlreadyHaveAnAccountCheck(
                  login: false,
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  OutlineInputBorder myinputborder(){ //return type is OutlineInputBorder
    return const OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.black, width: 0),
            borderRadius: BorderRadius.all(
            Radius.circular(8),
          )
        );
  }

  OutlineInputBorder myfocusborder(){
    return const OutlineInputBorder(
        borderSide: BorderSide(
            color: kPrimaryColor, width: 0),
            borderRadius: BorderRadius.all(
            Radius.circular(8),
          )
        );
  }

  
}

//Class for Driving lincense
class LogbookDetails extends StatefulWidget {
  const LogbookDetails({Key? key}) : super(key: key);

  @override
  _LogbookDetailsState createState() => _LogbookDetailsState();
}

class _LogbookDetailsState extends State<LogbookDetails> {
  GlobalKey<FormState> basicFormKey = GlobalKey<FormState>();

  // final ImagePicker _picker = ImagePicker();
  // File? _image;

  // Future getImage(ImageSource source) async {
  //   try{
  //   final image = await ImagePicker().pickImage(source: source);

  //   if(image == null) return;

  //   // final imageTemporary = File(image.path);
  //   final imagePermanent = await saveFilePermanently(image.path);

  //   setState(() {
  //     this._image = imagePermanent;
  //   });
  //   } on PlatformException catch (e){
  //       print('Failed to pick image: $e');
  //   }
  // }

  // Future<File> saveFilePermanently(String imagePath) async 
  // {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final name = basename(imagePath);
  //   final image = File("${directory.path}/$name");

  //   return File(imagePath).copy(image.path);
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModal>(builder: (context, modal, child) {
      return Card(
        
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: basicFormKey,
            child: Column(
              children: [
                SizedBox(
                  width: 10,
                ),
                //Driving Licence upload
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Log book attach',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: DottedBorder(
                        color: Colors.black,
                        strokeWidth: 1,
                        radius: Radius.circular(30),
                        child: Center(
                          child: Column(
                            children: [
                              // SizedBox(height: 20,),
                              // Padding(
                              //   padding: const EdgeInsets.all(20.0),
                              //   child: _image != null ? Image.file(_image!, width: 300, height: 250, fit: BoxFit.cover,) 
                              //   : Image.asset('assets/images/upload_logo.png', width: 300, height: 250, fit: BoxFit.cover,),
                              // ),
                              // SizedBox(height: 20,),
                              // Column(
                              //   children: [
                              //     CustomButton(
                              //       title: 'Pick from Gallery',
                              //       icon: Icons.image_outlined,
                              //       onClick: () => getImage(ImageSource.gallery),
                              //     ),
                              //     SizedBox(height: 10,),
                              //     CustomButton(
                              //       title: 'Pick from Camera',
                              //       icon: Icons.camera,
                              //       onClick: () => getImage(ImageSource.camera),
                              //     ),
                              //     SizedBox(height: 20,),
                              //   ],
                              // ),
                              
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        fixedSize: const Size(200, 40)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ),
                    );
                    print('');
                  },
                  child: Text("Sign Up".toUpperCase()),
                ),
              ),
                SizedBox(
                  height: 10,
                ),

                AlreadyHaveAnAccountCheck(
                  login: false,
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
            
          ),
        ),
      );
    });
  }

  OutlineInputBorder myinputborder(){ //return type is OutlineInputBorder
    return const OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.black, width: 0),
            borderRadius: BorderRadius.all(
            Radius.circular(8),
          )
        );
  }

  OutlineInputBorder myfocusborder(){
    return const OutlineInputBorder(
        borderSide: BorderSide(
            color: kPrimaryColor, width: 0),
            borderRadius: BorderRadius.all(
            Radius.circular(8),
          )
        );
  }

  // void imageSelected() async {
  //   final XFile? selectedImage = await _picker.pickImage(
  //       source: ImageSource.camera,
  //       maxWidth: 640,
  //       maxHeight: 480,
  //       imageQuality: 70);

  //   if (selectedImage!.path.isNotEmpty) {
  //     _imageList.add(selectedImage);
  //   }
  //   setState(() {});
  
}
Widget CustomButton({ 
  required String title,
  required IconData icon,
  required VoidCallback onClick
  }){
  return Container(
      width: 200,
      child: ElevatedButton(
        onPressed: onClick,
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: 10,),
            Text(title)
          ],
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryLightColor,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        ),
  );
}
