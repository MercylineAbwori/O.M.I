import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:one_million_app/components/onbording_screens/already_have_an_account_acheck.dart';
import 'package:one_million_app/components/signin/login_screen.dart';
import 'package:one_million_app/core/constant_service.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/model/regisration_otp_model.dart';
import 'package:one_million_app/core/model/registration_model.dart';
import 'package:one_million_app/core/model/registration_otp_verify.dart';
import 'package:one_million_app/core/model/user_model.dart';
import 'package:one_million_app/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

//constants
const buttonTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w900,
);

// class SignUpForm extends StatelessWidget {
//   const SignUpForm({
//     Key? key,
//   }) : super(key: key);
class UploadFiles extends StatefulWidget {
  const UploadFiles({Key? key}) : super(key: key);

  @override
  _UploadFilesState createState() => _UploadFilesState();
}

class _UploadFilesState extends State<UploadFiles> 

with SingleTickerProviderStateMixin {
  
  late TabController _tabController;

  final _selectedColor = kPrimaryColor;

  final _tabs = [
    const Tab(text: 'ID Upload'),
    const Tab(text: 'Driving License'),
    const Tab(text: 'Logbook Upload'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.white,

        leading: Container(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(
              iconSize: 100,
              icon: Icon(Icons.arrow_back,
              color: Colors.black,
              size: 20,),
              // the method which is called
              // when button is pressed
              onPressed: () {
                Navigator.pop(context);
                
              },
            ),
          ),
        ),
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(height: 80),
              padding: EdgeInsets.all(10),
              child: Container(
                
              height: kToolbarHeight - 8.0,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: _selectedColor),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: _tabs,
              ),
            ),
            ),
            Expanded(
              child: Container(
                child: TabBarView(children: [
                  Container(
                    child: buildIDUpload(),
                  ),
                  Container(
                    child: buildDrivingLincenseUpload(),
                  ),
                  Container(
                    child: buildLogbookUpload(),
                  ),
                ]),
              ),
            )
          ],
        ),
      )
    );
}

}
  
Widget buildIDUpload() {
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

  return SingleChildScrollView(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          child: Column(
            children: [
              // Capture Front ID upload
              const SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Front ID photo',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: DottedBorder(
                      color: Colors.black,
                      strokeWidth: 1,
                      radius: const Radius.circular(30),
                      child: Center(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: _imageFrontId != null
                                  ? Image.file(
                                      _imageFrontId!,
                                      width: 300,
                                      height: 250,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/images/upload_logo.png',
                                      width: 300,
                                      height: 250,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Column(
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
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              //Capture End ID upload
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'End ID photo',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: DottedBorder(
                      color: Colors.black,
                      strokeWidth: 1,
                      radius: const Radius.circular(30),
                      child: Center(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: _imageBackId != null
                                  ? Image.file(
                                      _imageBackId!,
                                      width: 300,
                                      height: 250,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/images/upload_logo.png',
                                      width: 300,
                                      height: 250,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Column(
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
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              
            ],
          ),
        )),
    ),
  );
}

Widget buildDrivingLincenseUpload() {
  // final ImagePicker _picker = ImagePicker();
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
  return SingleChildScrollView(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          child: Column(
            children: [
              const SizedBox(
                width: 10,
              ),
              //Driving Licence upload
              Column(
                children: [
                  const Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'End ID photo',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: DottedBorder(
                      color: Colors.black,
                      strokeWidth: 1,
                      radius: const Radius.circular(30),
                      child: Center(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: _image != null
                                  ? Image.file(
                                      _image!,
                                      width: 300,
                                      height: 250,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/images/upload_logo.png',
                                      width: 300,
                                      height: 250,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Column(
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
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              
            ],
          ),
        ),
      ),
    ),
  );
}

Widget buildLogbookUpload() {

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
  return SingleChildScrollView(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          child: Column(
            children: [
              const SizedBox(
                width: 10,
              ),
              //Driving Licence upload
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Log book attach',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: DottedBorder(
                      color: Colors.black,
                      strokeWidth: 1,
                      radius: const Radius.circular(30),
                      child: const Center(
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
              const SizedBox(
                width: 10,
              ),
              
            ],
          ),
        ),
      ),
    ),
  );
}

Widget CustomButton(
    {required String title,
    required IconData icon,
    required VoidCallback onClick}) {
  return Container(
    width: 200,
    child: ElevatedButton(
      onPressed: onClick,
      child: Row(
        children: [
          Icon(icon),
          SizedBox(
            width: 10,
          ),
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