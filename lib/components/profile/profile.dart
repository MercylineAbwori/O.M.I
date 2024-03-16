import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one_million_app/components/notification/notification.dart';
import 'package:one_million_app/core/constant_service.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/local_storage.dart';
import 'package:one_million_app/core/model/upload_document_model.dart';
import 'package:one_million_app/core/services/models/fetch_profile_model.dart';
import 'package:one_million_app/core/services/providers/fetch_profile_providers.dart';
import 'package:one_million_app/shared/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:badges/badges.dart';
import 'package:badges/badges.dart' as badges;

class ProfileScreen extends ConsumerStatefulWidget {
  final num userId;
  final String name;
  final String email;
  final String phoneNo;
  const ProfileScreen({super.key, 
  required this.userId,
      required this.name,
      required this.email,
      required this.phoneNo,});

  @override
  ConsumerState<ProfileScreen> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _imageProfile;

  num? count = 1;

  String _data = '';
  var _isLoading = true;
  String? error;

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


  String? profilePic;

  @override
  void initState() {
    super.initState();

    // // Reload shops
    ref.read(profilePicProvider.notifier).fetchprofilePic();
  }

  late profilePicModel availableData;

  @override
  Widget build(BuildContext context) {
    availableData = ref.watch(profilePicProvider);

    setState(() {
      _data = availableData.profile_url;
      _isLoading = availableData.isLoading;

      profilePic = _data;

      log("Profile : $profilePic");
    });

    return Scaffold(
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 40),

              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/icons/profile_icons/profile.jpg')
                // _imageProfile != null
                // ? FileImage(_imageProfile!)
                // : (profilePic == '')
                // ? AssetImage('assets/icons/profile_icons/profile.jpg')
                // : NetworkImage(profilePic!)
                      
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
                          )
                        )
                      )
                    ),

              SizedBox(
                  height: 40.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        fixedSize: const Size(200, 40)),
                    onPressed: () async {
                      // await pickerFiles(widget.userId, 'Front National ID', _imageFrontId);
                      await ApiService().pickerFiles(
                          widget.userId,
                          // 'Front National ID',
                          'profile',
                          _imageProfile);
                    },
                    child: const Text(
                      "Submit Profile Picture",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.white
                      ),
                    ),
                  )
              ),
              const SizedBox(height: 20),
              itemProfile('Name', widget.name!, CupertinoIcons.person),
              const SizedBox(height: 10),
              itemProfile('Phone', widget.phoneNo, CupertinoIcons.phone),
              const SizedBox(height: 10),
              itemProfile('Email', widget.email!, CupertinoIcons.mail),
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
