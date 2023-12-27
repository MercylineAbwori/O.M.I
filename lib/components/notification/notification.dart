import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:one_million_app/core/constant_service.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/model/notification_model.dart';
import 'package:http/http.dart' as http;
import 'package:one_million_app/shared/constants.dart';

class NotificationPage extends StatefulWidget {
  final num userId;
  final List<String> title;
  final List<String> message;
  final List<String> readStatus;
  const NotificationPage(
      {super.key,
      required this.userId,
      required this.title,
      required this.message,
      required this.readStatus});
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
// padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  int selectedPageIndex = 0;

  int _currentIndex = 0;
  final List _children = [];

  int count = 0;

  bool checkboxValue = true;
  bool checkedValue = false;

  // This function is triggered when a checkbox is checked or unchecked
  Future<void> _itemChange(num notificationId) async {
    await ApiService().sendMarkAsRead(widget.userId, notificationId);
    setState(() {});
  }

  // This function is triggered when a checkbox is checked or unchecked
  Future<void> _itemChangeMarkAll() async {
    await ApiService().sendMarkAsAll(widget.userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        leading: Container(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(
              iconSize: 100,
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 20,
              ),
              // the method which is called
              // when button is pressed
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // welcome home
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Notifications",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                //Divider

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Divider(
                    thickness: 1,
                    color: Color.fromARGB(255, 204, 204, 204),
                  ),
                ),

                const SizedBox(height: 20),

                const SizedBox(height: 10),

                Container(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          (widget.message.isEmpty)
                              ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Card(
                                    elevation: 5,
                                    shadowColor: Colors.black,
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(40.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.info,
                                              size: 100,
                                              color: kPrimaryColor,
                                            ),
                                            SizedBox(height: 20),
                                            Text(
                                              'You have no activities',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                              // style: GoogleFonts.bebasNeue(fontSize: 72),
                                            ),
                                            SizedBox(height: 20),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  child: Column(
                                    children: [
                                      CheckboxListTile(
                                        title: Text("Mark All"), //    <-- label
                                        value: (widget.readStatus
                                                .contains('Unread'))
                                            ? checkedValue = false
                                            : checkedValue = true,
                                        onChanged: (newValue) =>
                                            _itemChangeMarkAll(),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      ListView.separated(
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.all(8),
                                        itemCount: widget.message.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Card(
                                            color: Colors.white,
                                            borderOnForeground: true,
                                            elevation: 6,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                CheckboxListTile(
                                                  value: (widget.readStatus[
                                                              index] ==
                                                          'Read')
                                                      ? checkboxValue = true
                                                      : checkboxValue = false,
                                                  onChanged: (isChecked) {
                                                    // if (widget.readStatus[index] ==
                                                    //     'Read') {
                                                    //   // log('initial should be read');
                                                    //   checkboxValue = true;
                                                    //   checkboxValue = isChecked!;
                                                    // } else {
                                                    //   // log('initial should be unread');
                                                    //   checkboxValue = false;
                                                    //   checkboxValue = isChecked!;
                                                    // }
                                                  },
                                                  secondary: const Icon(
                                                      Icons.notifications),
                                                  title:
                                                      Text(widget.title[index]),
                                                  subtitle: Text(
                                                      widget.message[index]),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                const Divider(),
                                      ),
                                    ],
                                  ),
                                )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
