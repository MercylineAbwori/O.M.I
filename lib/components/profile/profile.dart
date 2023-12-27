import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one_million_app/components/notification/notification.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/model/fetch_document.model.dart';
import 'package:one_million_app/core/model/notification_model.dart';
import 'package:one_million_app/core/model/upload_document_model.dart';
import 'package:one_million_app/shared/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

class ProfileScreen extends StatefulWidget {
  final num userId;
  final String userName;
  final String phone;
  final String email;

  final List<String> title;
  final List<String> message;
  final List<String> readStatus;
  final List<num> notificationIdList;

  final String profilePic;

  const ProfileScreen(
      {Key? key,
      required this.userId,
      required this.userName,
      required this.phone,
      required this.email,
      required this.title,
      required this.message,
      required this.readStatus,
      required this.notificationIdList,
      required this.profilePic})
      : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _imageProfile;

  Future getImageProfilePicture(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);

      if (image == null) return;

      // final imageTemporary = File(image.path);
      final imagePermanent = await saveFilePermanently(image.path);

      setState(() {
        this._imageProfile = imagePermanent;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<File> saveFilePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File("${directory.path}/$name");

    return File(imagePath).copy(image.path);
  }

  Future<List<UploadFileModal>?> pickerFiles(userId, documentName, file) async {
    try {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              ApiConstants.baseUrl + ApiConstants.uploadDocumentEndpoint));

      // open a bytestream
      var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
      // get file length
      var length = await file.length();

      // multipart that takes file
      var multipartFile = http.MultipartFile('file', stream, length,
          filename: basename(file.path));

      request.fields.addAll(
          {"userId": json.encode(userId), "documentName": documentName});
      // request.fields["documentName"] = documentName;
      // request.fields["userId"] = userId.toString();

      // add file to multipart
      request.files.add(multipartFile);

      var response = await request.send();
      var responced = await http.Response.fromStream(response);

      final responseData = json.decode(responced.body);

      print('rESPONCE bODY : $responseData');

      // log('The Request Payload : ${request.files}');
    } on PlatformException catch (e) {
      // log('Unsupported operation' + e.toString());
    } catch (e) {
      // log(e.toString());
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Container(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(
              iconSize: 30,
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              // the method which is called
              // when button is pressed
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        actions: <Widget>[
          // notification icon
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              iconSize: 30,
              icon: const Icon(
                Icons.notifications,
                color: kPrimaryColor,
              ),
              // the method which is called
              // when button is pressed
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return NotificationPage(
                          userId: widget.userId,
                          readStatus: widget.readStatus,
                          title: widget.title,
                          message: widget.message);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // const CircleAvatar(
              //   radius: 70,
              //   backgroundImage:
              //       AssetImage('assets/icons/profile_icons/profile.jpg'),
              // ),
              CircleAvatar(
                
                backgroundColor: kPrimaryLightColor,
                child: _imageProfile != null
                    ? Image.file(
                        _imageProfile!,
                        width: 300,
                        height: 250,
                        fit: BoxFit.cover,
                      )
                    : (widget.profilePic == '')
                        ? Image.asset(
                            'assets/icons/profile_icons/profile.jpg',
                            width: 300,
                            height: 250,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            widget.profilePic,
                            width: 300,
                            height: 250,
                            fit: BoxFit.cover,
                          ),
              ),
              InkWell(
                  onTap: () {
                    getImageProfilePicture(ImageSource.gallery);
                  },
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          height: 30.00,
                          width: 30.00,
                          margin: const EdgeInsets.only(
                            left: 183.00,
                            top: 10.00,
                            right: 113.00,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(
                              5.00,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            size: 20,
                            color: Colors.black,
                          )))),

              SizedBox(
                  height: 40.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        fixedSize: const Size(200, 40)),
                    onPressed: () async {
                      // await pickerFiles(widget.userId, 'Front National ID', _imageFrontId);
                      await pickerFiles(
                          widget.userId,
                          // 'Front National ID',
                          'profile',
                          _imageProfile);
                    },
                    child: const Text(
                      "Submit Profile Picture",
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  )),
              const SizedBox(height: 20),
              itemProfile('Name', widget.userName, CupertinoIcons.person),
              const SizedBox(height: 10),
              itemProfile('Phone', widget.phone, CupertinoIcons.phone),
              const SizedBox(height: 10),
              itemProfile('Email', widget.email, CupertinoIcons.mail),
              const SizedBox(
                height: 20,
              ),
              itemProfile('Policy Management', 'policy management',
                  CupertinoIcons.person_crop_circle_badge_checkmark),
              const SizedBox(
                height: 20,
              ),
              itemProfile('Two factor Authentification',
                  'enable two  factor auth', CupertinoIcons.lock_circle),
              const SizedBox(
                height: 20,
              ),
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //       onPressed: () {},
              //       style: ElevatedButton.styleFrom(
              //         padding: const EdgeInsets.all(15),
              //       ),
              //       child: const Text('Edit Profile')
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
                offset: Offset(0, 5),
                color: kPrimaryLightColor,
                spreadRadius: 2,
                blurRadius: 10)
          ]),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
        trailing: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
        tileColor: Colors.white,
      ),
    );
  }
}
