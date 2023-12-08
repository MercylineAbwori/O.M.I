import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_million_app/components/notification/notification.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/model/notification_model.dart';
import 'package:one_million_app/shared/constants.dart';


class ProfileScreen extends StatefulWidget {

  final num userId;
  final String userName;
  final String phone;
  final String email;

  const ProfileScreen({
    Key? key,
    required this.userId,
    required this.userName,
    required this.phone,
    required this.email,}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

    late String _statusMessage;
    num? _statusCode;

    late List<String> message =[];

    Future<List<NotificationModal>?> getNotification(userId) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.notificationEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "userId": userId
      });

      final response = await http.post(url, headers: headers, body: body);

      print('Responce Status Code : ${response.statusCode}');
      print('Responce Body : ${response.body}');

      var obj = jsonDecode(response.body);

      obj.forEach((key, value) {
        _statusCode = obj["statusCode"];
        _statusMessage = obj["statusMessage"];
      });

      if (response.statusCode == 200) {
        print('checking');
      } else {
        throw Exception('Unexpected Login error occured!');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        // leading: Container(
        //   child: Padding(
        //     padding: const EdgeInsets.all(4.0),
        //     child: IconButton(
        //       iconSize: 30,
        //       icon: const Icon(
        //         Icons.arrow_back,
        //         color: Colors.black,
        //       ),
        //       // the method which is called
        //       // when button is pressed
        //       onPressed: () {
        //         Navigator.pop(context);
        //       },
        //     ),
        //   ),
        // ),
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
              onPressed: () async {
                    await getNotification(
                      message
                    );

                    (_statusCode == 5000)
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return NotificationPage(message: message);
                              },
                            ),
                          )
                        : Navigator.pop(context);
                    setState(
                      () {},
                    );

                    final snackBar = SnackBar(
                      content: Text(_statusMessage),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
              const CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage('assets/icons/profile_icons/profile.jpg'),
              ),
              const SizedBox(height: 20),
              itemProfile('Name', widget.userName, CupertinoIcons.person),
              const SizedBox(height: 10),
              itemProfile('Phone', widget.phone, CupertinoIcons.phone),
              const SizedBox(height: 10),
              itemProfile('Email', widget.email, CupertinoIcons.mail),
              const SizedBox(height: 20,),
              itemProfile('Policy Management', 'policy management', CupertinoIcons.person_crop_circle_badge_checkmark),
              const SizedBox(height: 20,),
              itemProfile('Two factor Authentification', 'enable two  factor auth', CupertinoIcons.lock_circle),
              const SizedBox(height: 20,),
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
                blurRadius: 10
            )
          ]
      ),
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