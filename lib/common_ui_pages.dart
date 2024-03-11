import 'dart:developer';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_million_app/components/claim/claim_screen.dart';
import 'package:one_million_app/components/notification/notification.dart';
import 'package:one_million_app/components/profile/profile.dart';
import 'package:one_million_app/core/local_storage.dart';
import 'package:one_million_app/core/services/models/notifications_counts_model.dart';
import 'package:one_million_app/core/services/providers/notification_counts_providers.dart';
import 'package:one_million_app/home.dart';
import 'package:one_million_app/shared/default%20_without_providers.dart';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart' as badges;

class CommonUIPage extends ConsumerStatefulWidget {
  final num userId;
  final String name;
  final String email;
  final String phoneNo;
  const CommonUIPage({super.key,
  required this.userId,
      required this.name,
      required this.email,
      required this.phoneNo,
  });

  @override
  ConsumerState<CommonUIPage> createState() {
    return _CommonUIPageState();
  }
}

class _CommonUIPageState extends ConsumerState<CommonUIPage> {
  num count = 0;

  var _isLoading = true;
  String? error;

  Widget? bodywidgets;

  int index = 0;

  @override
  void initState() {
    super.initState();
    bodywidgets = DefaultList(userId: widget.userId,
                    name: widget.name,
                    email: widget.email,
                    phoneNo: widget.phoneNo,);

    // // Reload
    ref.read(notificationCountListProvider.notifier).fetchNotificationCount();

    
  }

  late notificationCountModel availableData;

  @override
  Widget build(BuildContext context) {
    availableData = ref.watch(notificationCountListProvider);

    setState(() {
      count = availableData.notification_count;
      _isLoading = availableData.isLoading;

      log("Count : $count");


      
    });

    return Scaffold(
      appBar: AppBar(),
      body: bodywidgets,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                widget.name,
                style: TextStyle(color: Colors.white),
              ),
              accountEmail: Text(
               widget.email,
                style: TextStyle(color: Colors.white),
              ),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/profile.jpeg',
                    fit: BoxFit.cover,
                    width: 90,
                    height: 90,
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image:
                      ExactAssetImage('assets/images/profile_background.jpeg'),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_max),
              title: const Text('Home '),
              onTap: () {
                setState(() {
                  bodywidgets = DefaultList(userId: widget.userId,
                    name: widget.name,
                    email: widget.email,
                    phoneNo: widget.phoneNo,);
                  Navigator.pop(context); 
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notification'),
              trailing: (count != 0)
                  ? badges.Badge(
                      position: BadgePosition.topEnd(top: 0, end: 3),
                      badgeContent: Text(
                        (count).toString(),
                        style: TextStyle(color: Colors.white),
                      ))
                  : null,
              onTap: () {
                setState(() {
                  bodywidgets = NotificationList();
                  Navigator.pop(context); 
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Claims'),
              trailing: (count != 0)
                  ? badges.Badge(
                      position: BadgePosition.topEnd(top: 0, end: 3),
                      badgeContent: Text(
                        (count).toString(),
                        style: TextStyle(color: Colors.white),
                      ))
                  : null,
              onTap: () {
                setState(() {
                  bodywidgets = ClaimList();
                  Navigator.pop(context); 
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.business),
              title: const Text('Covarage'),
              trailing: (count != 0)
                  ? badges.Badge(
                      position: BadgePosition.topEnd(top: 0, end: 3),
                      badgeContent: Text(
                        (count).toString(),
                        style: TextStyle(color: Colors.white),
                      ))
                  : null,
              onTap: () {
                setState(() {
                  // bodywidgets = CoveragePage();
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Profile'),
              trailing: (count != 0)
                  ? badges.Badge(
                      position: BadgePosition.topEnd(top: 0, end: 3),
                      badgeContent: Text(
                        (count).toString(),
                        style: TextStyle(color: Colors.white),
                      ))
                  : null,
              onTap: () {
                setState(() {
                  bodywidgets = ProfileScreen(
                    userId: widget.userId,
                    name: widget.name,
                    email: widget.email,
                    phoneNo: widget.phoneNo,
                  );
                  Navigator.pop(context); 
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
