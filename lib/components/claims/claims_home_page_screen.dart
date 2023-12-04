import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_million_app/components/claims/claim_form/claim_home_form_screen.dart';
import 'package:one_million_app/components/claims/claim_select_page.dart';
import 'package:one_million_app/components/notification/notification.dart';
import 'package:one_million_app/components/profile/profile.dart';
import 'package:one_million_app/shared/constants.dart';


class ClaimHomePage extends StatefulWidget {
  @override
  _ClaimHomePageState createState() => _ClaimHomePageState();
}

class _ClaimHomePageState extends State<ClaimHomePage> with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _formState = GlobalKey<FormState>();

    // padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

    final List<dynamic> _elements = 
       [
        {
          'title': 'Claim One',
          'status': 'Pending',
          'date': 'Set 10th 2023',
          'type': 'death'
        }, 
        {
          'title': 'Claim Two',
          'status': 'In Review',
          'date': 'Set 10th 2023',
          'type': 'medical expences'
        }, 
        {
          'title': 'Claim Three',
          'status': 'Completed',
          'date': 'Set 10th 2023',
          'type': 'temporary disability'
        },
        {
          'title': 'Claim Four',
          'status': 'Failed',
          'date': 'Set 10th 2023',
          'type': 'permanent disability'
        }
      ];

      // list of smart devices
  List serviceBox = [
    ["Coverage", "assets/icons/home_icons/coverage.png", false],
    ["Payment", "assets/icons/home_icons/payment.png", false],
    ["Claims", "assets/icons/home_icons/reporting.png", false],
    ["Claims", "assets/icons/home_icons/claims.png", false],
  ];


    //Claim LISTS
  
     List<String>  claimType = <String>[
      'Death',
      'Medical Expenses',
      'Temporary Diasability',
      'Permanent Disability',
    ];
     List<String> selectedClaimType = [];

    

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final List<dynamic> itemsTitles = _elements.map((e){
        return e['title'];
    }).toList();
    final List<dynamic> itemsStatus = _elements.map((e){
        return e['status'];
    }).toList();
    final List<dynamic> itemsDate = _elements.map((e){
      return e['date'];
    }).toList();
    final List<dynamic> itemsType = _elements.map((e){
      return e['type'];
    }).toList();

    //Claim List Container
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
                    
                  },
                );
              },
            ),
          ),

        ],
      ),
      body:  Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 25),
              // welcome home
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Text(
                      "Claim",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
        
              const SizedBox(height: 5),
        
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Divider(
                  thickness: 1,
                  color: Color.fromARGB(255, 204, 204, 204),
                ),
              ),
        
        (_elements.isEmpty)
                  ? Padding(
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
                                const Icon(
                                  Icons.info,
                                  size: 100,
                                  color: kPrimaryColor,
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'You have no claim',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                  // style: GoogleFonts.bebasNeue(fontSize: 72),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Use the CREATE A CLAIM button to create a new form',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black),
                                  // style: GoogleFonts.bebasNeue(fontSize: 72),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: kPrimaryColor,
                                      fixedSize: const Size(200, 40)),
                                  onPressed: () {
                                   //  Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) {
                                    //       return ClaimForm();
                                    //     },
                                    //   ),
                                    // );
                                    // _showDialog();
                                  },
                                  child: Text(
                                    "Create a new Claim".toUpperCase(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  :
              const SizedBox(height: 20),
                  Column(
                    children: [
                      Container(
                        child: ListView.separated(
                            
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8),
                            itemCount: _elements.length,
                            itemBuilder: (BuildContext context, int index) {

                              
                              return Card(
                                color: Colors.white,
                                borderOnForeground: true,
                                elevation: 6,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      leading: CircleAvatar(
                                          
                                        // child: Icon(icons[index])
                                        child: Icon(itemsType.toList()[index] == 'death' ? Icons.dangerous : 
                                        itemsType.toList()[index] == 'permanent disability' ? Icons.wheelchair_pickup_outlined : 
                                        itemsType.toList()[index] == 'temporary disability' ? Icons.personal_injury : Icons.medical_information_outlined),
                                      ),
                                      title: Text(itemsTitles[index]),
                                      subtitle: Text(
                                        itemsDate[index], 
                                        style: TextStyle(
                                              fontSize: 12, 
                                              fontWeight: FontWeight.w400,)),
                                      trailing:Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            itemsStatus.toList()[index] == 'Pending' ? 'Pending': 
                                            itemsStatus.toList()[index] == 'In Review'?  'In Review' : 
                                            itemsStatus.toList()[index] == 'Completed'?  'Completed': 'Failed',
                                            style: TextStyle(
                                              fontSize: 12, fontWeight: FontWeight.w400,
                                              
                                              color: itemsStatus.toList()[index] == 'Failed'? Colors.red 
                                              : itemsStatus.toList()[index] == 'Pending'? Colors.yellow  
                                              : itemsStatus.toList()[index] == 'In Review'?  Colors.blue : Colors.green,
                                            ),
                                        ),
                                      ),
                                    ),
                                    
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) => const Divider(),
                          ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Divider(
                          thickness: 1,
                          color: Color.fromARGB(255, 204, 204, 204),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
                
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
             Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ClaimForm();
                },
              ),
            );
            // _showDialog();

            
            
          },
          child: const Icon(Icons.add),
      ), 

    );
   
  }
  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return  ClaimTypeSelect(
          itemSelected: claimType);

      },

    );

    

    

  }

  
  

}
