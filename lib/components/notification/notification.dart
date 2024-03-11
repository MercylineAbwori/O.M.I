import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:one_million_app/core/constant_service.dart';
import 'package:one_million_app/core/local_storage.dart';
import 'package:one_million_app/core/services/models/notification_model.dart';
import 'package:one_million_app/core/services/providers/notification_provider.dart';
import 'package:one_million_app/shared/constants.dart';

class NotificationList extends ConsumerStatefulWidget {
  const NotificationList({super.key});

  @override
  ConsumerState<NotificationList> createState() {
    return _NotificationListState();
  }
}

class _NotificationListState extends ConsumerState<NotificationList> {
  List<notificationListItem> _data = [];
  var _isLoading = true;
  String? error;

  num _selectedIndex = 0;

  num? userId;

  Future<void> loadUserData() async {
    // var _userId = await LocalStorage().getUserRegNo();
    var _userId = 1;
    if (_userId != null) {
      setState(() {
        userId = _userId;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // // Reload shops
    ref.read(notificationListListProvider.notifier).fetchNotificationList();

    // _selectedIndex = widget.selectedIndex!;
  }

  // This function is triggered when a checkbox is checked or unchecked
  Future<void> _itemChangeMarkAll() async {
    await ApiService().sendMarkAsAll(userId);
    setState(() {});
  }

  late List<String> message = [];
  late List<String> title = [];
  late List<String> readStatus = [];
  late List<num> notificationIdList = [];

  bool isChecked = false;

  late notificationListModel availableData;

  @override
  Widget build(BuildContext context) {
    availableData = ref.watch(notificationListListProvider);

    setState(() {
      _data = availableData.notification_list;
      _isLoading = availableData.isLoading;

      for (var i = 0; i < _data.length; i++) {
        readStatus.add(_data[i].readStatus);
      }
      ;
    });

    Widget content = const Center(
      child: Text('No data yet',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
    );

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      content = Center(
        child: Text(error!),
      );
    }

    if (_data.isEmpty) {
      content = Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5,
                    shadowColor: Colors.black,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
              ],
            ),
          ),
        ),
      );
    } else {
      content = Container(
        child: Column(
          children: [
            CheckboxListTile(
              title: Text("Mark All As Read"), //    <-- label
              value: (readStatus.contains('Unread'))
                  ? isChecked = false
                  : isChecked = true,
              onChanged: (newValue) {
                setState(() {
                  isChecked = newValue!;
                });
                _itemChangeMarkAll();
              },
            ),
            SizedBox(
              height: 10,
            ),
            ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: _data.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    color: Colors.white,
                    borderOnForeground: true,
                    elevation: 6,
                    child: ListTile(
                      leading: Icon(Icons.notifications),
                      title: Text(
                        _data[index].type,
                        style: (_data[index].readStatus == 'Unread')
                            ? TextStyle(
                                fontWeight: FontWeight.bold,
                              )
                            : TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                      ),
                      subtitle: Text(
                        _data[index].message,
                        style: (_data[index].readStatus == 'Unread')
                            ? TextStyle(
                                fontWeight: FontWeight.bold,
                              )
                            : TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                      ),
                      onTap: () async {
                        await ApiService()
                            .sendMarkAsRead(userId, _data[index].id);
                      },
                    ));
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          ],
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // welcome home
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
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

              content
            ],
          ),
        ));
  }
}

// Helper class
class Utils {
  static String getFormattedDateSimple(int time) {
    DateFormat newFormat = DateFormat("MMMM dd yyyy");
    return newFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
  }

  static String getFormattedDateSimpleMonthAddDate(int time) {
    DateFormat newFormat = DateFormat("MMMM dd");
    return newFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
  }

  static String getFormattedDateSimpleMonthAddDateLess(int time) {
    DateFormat newFormat = DateFormat("MMM dd");
    return newFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
  }

  static String getFormattedDateSimpleFilter(int time) {
    DateFormat newFormat = DateFormat("yyyy-MM-dd");
    return newFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
  }

  static String getFormattedDateSimpleToday(int time) {
    DateFormat newFormat = DateFormat("dd MMMM");
    return newFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
  }
}
