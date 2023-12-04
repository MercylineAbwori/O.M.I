import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  
// padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  final titles = ["List 1", "List 2", "List 3", "List 4", "List 5", "List 6",  "List 7", "List 8", "List 9", "List 10"];
  final subtitles = [
    "Here is list 1 subtitle",
    "Here is list 2 subtitle",
    "Here is list 3 subtitle",
    "Here is list 4 subtitle",
    "Here is list 5 subtitle",
    "Here is list 6 subtitle",
    "Here is list 7 subtitle",
    "Here is list 8 subtitle",
    "Here is list 9 subtitle",
    "Here is list 10 subtitle",
  ];
  final icons = [Icons.notifications, Icons.notifications, Icons.notifications, Icons.notifications, Icons.notifications, Icons.notifications,Icons.notifications,Icons.notifications,Icons.notifications,Icons.notifications];

   
  int selectedPageIndex = 0;

  int _currentIndex = 0;
  final List _children = [];

int count = 0;
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
                  child: Column(
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
                        Container(
                          child: ListView.separated(
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(8),
                              itemCount: titles.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  color: Colors.white,
                                  borderOnForeground: true,
                                  elevation: 6,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        leading: const Icon(Icons.notifications),
                                        title: Text(titles[index]),
                                        subtitle: Text(subtitles[index]),
                                      ),
                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.end,
                                      //   children: <Widget>[
                                      //     TextButton(
                                      //       child: const Text('Dail'),
                                      //       onPressed: () {/* ... */},
                                      //     ),
                                      //     const SizedBox(width: 8),
                                      //     TextButton(
                                      //       child: const Text('Call History'),
                                      //       onPressed: () {/* ... */},
                                      //     ),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) => const Divider(),
                            ),
                        ),
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
