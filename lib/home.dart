
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:one_million_app/components/notification/notification.dart';
import 'package:one_million_app/components/profile/profile.dart';
import 'package:one_million_app/shared/constants.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  final titles = ["List 1", "List 2", "List 3", "List 4", "List 5"];
  final subtitles = [
    "Here is list 1 subtitle",
    "Here is list 2 subtitle",
    "Here is list 3 subtitle",
    "Here is list 4 subtitle",
    "Here is list 5 subtitle",
  ];
   
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
              icon: Ink.image(
                  image:  AssetImage('assets/icons/profile_icons/profile.jpg'),
              ),
              // the method which is called
              // when button is pressed
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ProfileScreen();
                    },
                  ),
                );
                setState(
                  () {
                    count++;
                  },
                );
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
                  Icons.notifications, color: kPrimaryColor,
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
                setState(
                  () {
                    count++;
                  },
                );
              },
            ),
          ),

        ],
      ),
      body: SafeArea(
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
                      "Hello Name,",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Happy to see you back! ',
                      // style: GoogleFonts.bebasNeue(fontSize: 72),
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
        
              //Home title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: const Text(
                  "Home",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
              ),
        
              const SizedBox(height: 10),
        
              Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      CarouselSlider(
                        items: [
                          //1st Image of Slider
                          Card(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: kPrimaryWhiteColor,
                              ),
                              child: Image.asset(
                                'assets/images/adverts/slide_one.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Card(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: kPrimaryWhiteColor,
                              ),
                              child: Image.asset(
                                'assets/images/adverts/slide_two.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Card(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: kPrimaryWhiteColor,
                              ),
                              child: Image.asset(
                                'assets/images/adverts/slide_three.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Card(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: kPrimaryWhiteColor,
                              ),
                              child: Image.asset(
                                'assets/images/adverts/slide_four.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Card(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: kPrimaryWhiteColor,
                              ),
                              child: Image.asset(
                                'assets/images/adverts/slide_five.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Card(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: kPrimaryWhiteColor,
                              ),
                              child: Image.asset(
                                'assets/images/adverts/slide_six.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                        ],
        
                        //Slider Container properties
                        options: CarouselOptions(
                            height: 200,
                            enlargeCenterPage: true,
                            autoPlay: true,
                            aspectRatio: 16 / 9,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enableInfiniteScroll: true,
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            viewportFraction: 0.8,
                            onPageChanged: (index, reason) {}),
                      ),
                      // DotsIndicator(
                      //   dotsCount: contents.length,
                      //   position: _current.toInt(),
                      //   decorator: DotsDecorator(
                      //     shape: const Border(),
                      //     activeShape:
                      //         RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(35.0),),
                      //         color: kPrimaryColor,
                      //     size: Size(10, 10),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
        
              const SizedBox(height: 10),
        
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: const Text(
                  "Recent Activities",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
        
              const SizedBox(height: 10),
              (titles.isEmpty) ? 

              const Padding(
                padding: EdgeInsets.all(8.0),
                child:  Card(
                  elevation: 5,
                  shadowColor: Colors.black,
                  child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.info, size: 100, color: kPrimaryColor,),
                              SizedBox(height: 20),
                              Text(
                                'There are no recent activities', 
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black),
                                // style: GoogleFonts.bebasNeue(fontSize: 72),
                              ),
                          ],
                          
                        ),
                      ),
                  ),
                ),
              ) :
              Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(8),
                          itemCount: 5,
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
                
              )

              
                
            ],
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
