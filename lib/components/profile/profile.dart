
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_million_app/components/notification/notification.dart';
import 'package:one_million_app/shared/constants.dart';


class ProfileScreen extends StatelessWidget {
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return NotificationPage();
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
              CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage('assets/icons/profile_icons/profile.jpg'),
              ),
              const SizedBox(height: 20),
              itemProfile('Name', 'Ahad Hashmi', CupertinoIcons.person),
              const SizedBox(height: 10),
              itemProfile('Phone', '03107085816', CupertinoIcons.phone),
              const SizedBox(height: 10),
              itemProfile('Address', 'abc address, xyz city', CupertinoIcons.location),
              const SizedBox(height: 10),
              itemProfile('Email', 'ahadhashmideveloper@gmail.com', CupertinoIcons.mail),
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