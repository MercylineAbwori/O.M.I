import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:one_million_app/components/pages/onbording_screens/constent_model.dart';

class Onbording extends StatefulWidget {
  @override
  _OnbordingState createState() => _OnbordingState();
}

class _OnbordingState extends State<Onbording> {
  int _current = 0;
  late PageController _controller;

  // Track the tapped item index and its corresponding color
  int tappedIndex = -1;

  List<bool> expanded = [false, false];

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            CarouselSlider(
              items: [
                //1st Image of Slider
                Card(
                  child: Container(
                    margin: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.all(8),
                      children: <Widget>[
                        const SizedBox(height: 20),
                        Container(
                          height: 200,
                          child: Image.asset(
                            contents[0].image,
                            height: 250,
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 120,
                          child: Text(
                            contents[0].title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 200,
                          child: Text(
                            contents[0].discription,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // //2nd Image of Slider
                Card(
                  child: Container(
                    margin: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.all(8),
                      children: <Widget>[
                        SizedBox(height: 20),
                        Container(
                          height: 200,
                          child: Image.asset(
                            contents[1].image,
                            height: 250,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 30,
                          child: Text(
                            contents[1].title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                            children: [
                              Text(
                                contents[1].discription,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                  height: 300,
                                  child: ListView.builder(
                                      itemCount: contents[1].accorditionList.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return ListTile(
                                          title: Text(
                                            contents[1].accorditionList[index],
                                            textAlign: TextAlign.justify,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          onTap: () {
                                            // Update the tapped item index
                                            setState(() {
                                              tappedIndex = index;
                                            });
                                          },
                                        );
                                      },
                                    ),
                              )
                            ],
                          ),
                        ),
                        // Container(
                        //   height: MediaQuery.of(context).size.height,
                        //   child: ListView.builder(
                        //       itemCount: contents[1].accorditionList.length,
                        //       itemBuilder: (BuildContext context, int index) {
                        //         return ListTile(
                        //           title: Text(
                        //             contents[1].accorditionList[index],
                        //             textAlign: TextAlign.justify,
                        //               style: const TextStyle(
                        //                 fontSize: 15,
                        //                 color: Colors.grey,
                        //               ),
                        //             ),
                        //           onTap: () {
                        //             // Update the tapped item index
                        //             setState(() {
                        //               tappedIndex = index;
                        //             });
                        //           },
                        //         );
                        //       },
                        //     ),

                        // ),
                      ],
                    ),
                  ),
                ),

                // //3rd Image of Slider

                Card(
                  child: Container(
                    margin: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.all(8),
                      children: <Widget>[
                        SizedBox(height: 20),
                        Container(
                          height: 200,
                          child: Image.asset(
                            contents[2].image,
                            height: 300,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 30,
                          child: Text(
                            contents[2].title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          child: Column(
                              children: [

                                Card(
                                  color: Colors.white,
                                  child:ExpansionTile(
                                  title: Text(contents[2].accorditionTitle[0],
                                  style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold
                                              ),
                                        ),
                                  
                                  children: [
                                        Container( 
                                            color: Colors.black12,
                                            padding:const EdgeInsets.all(20),
                                            width: double.infinity,
                                            child:  Text(contents[2].accorditionDescrition[0]),
                                        )
                                  ],
                                  )
                                ),
                                const SizedBox(height: 10),
                                Card(
                                  color: Colors.white,
                                  child:ExpansionTile(
                                  title: Text(contents[2].accorditionTitle[1],
                                  style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                  
                                  children: [
                                        Container( 
                                            color: Colors.black12,
                                            padding:const EdgeInsets.all(20),
                                            width: double.infinity,
                                            child:  Text(contents[2].accorditionDescrition[1]),
                                        )
                                  ],
                                  )
                                ),
                                const SizedBox(height: 10),
                                Card(
                                  color: Colors.white,
                                  child:ExpansionTile(
                                  title: Text(contents[2].accorditionTitle[2], 
                                  style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold
                                              ),),
                                  
                                  children: [
                                        Container( 
                                            color: Colors.black12,
                                            padding:const EdgeInsets.all(20),
                                            width: double.infinity,
                                            child:  Text(contents[2].accorditionDescrition[2]),
                                        )
                                  ],
                                  )
                                ),
                                const SizedBox(height: 10),
                                Card(
                                  color: Colors.white,
                                  child:ExpansionTile(
                                  title: Text(contents[2].accorditionTitle[3],
                                  style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold
                                              ),),
                                  
                                  children: [
                                        Container( 
                                            color: Colors.black12,
                                            padding:const EdgeInsets.all(20),
                                            width: double.infinity,
                                            child:  Text(contents[2].accorditionDescrition[3]),
                                        )
                                  ],
                                  )
                                ),
                                const SizedBox(height: 20),

                                ExpansionPanelList(
                                    expansionCallback: (panelIndex, isExpanded) {
                                        setState(() {
                                          expanded[panelIndex] = !isExpanded;
                                        });
                                    },
                                    animationDuration: const Duration(seconds: 2)
                                )
                              ],
                          ),
                        )
                        

                        
                      ],
                    ),
                  ),
                ),

                // //4th Image of Slider

                Card(
                  child: Container(
                    margin: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.all(8),
                      children: <Widget>[
                        const SizedBox(height: 20),
                        Container(
                          height: 200,
                          child: Image.asset(
                            contents[3].image,
                            height: 300,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 30,
                          child: Text(
                            contents[3].title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Container(
                        //   height: MediaQuery.of(context).size.height,
                        //   child: Text(
                        //     contents[3].discription,
                        //     textAlign: TextAlign.justify,
                        //     style: TextStyle(
                        //       fontSize: 15,
                        //       color: Colors.grey,
                        //     ),
                        //   ),
                        // ),
                        Container(
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                              itemCount: contents[1].accorditionList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  title: Text(
                                    contents[3].accorditionList[index],
                                    textAlign: TextAlign.justify,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  onTap: () {
                                    // Update the tapped item index
                                    setState(() {
                                      tappedIndex = index;
                                    });
                                  },
                                );
                              },
                            ),
                          )
                        
                      ],
                    ),
                  ),
                ),

                // //5th Image of Slider

                Card(
                  child: Container(
                    margin: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.all(8),
                      children: <Widget>[
                        const SizedBox(height: 20),
                        Container(
                          height: 200,
                          child: Image.asset(
                            contents[4].image,
                            height: 300,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 50,
                          child: Text(
                            contents[4].title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                              itemCount: contents[3].accorditionList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  title: Text(
                                    contents[3].accorditionList[index],
                                    textAlign: TextAlign.justify,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  onTap: () {
                                    // Update the tapped item index
                                    setState(() {
                                      tappedIndex = index;
                                    });
                                  },
                                );
                              },
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                // //6th Image of Slider

                Card(
                  child: Container(
                    margin: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.all(8),
                      children: <Widget>[
                        const SizedBox(height: 20),
                        Container(
                          height: 200,
                          child: Image.asset(
                            contents[5].image,
                            height: 300,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 30,
                          child: Text(
                            contents[5].title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Container(
                        //   height: MediaQuery.of(context).size.height,
                        //   child: ListView.builder(
                        //       itemCount: contents[5].accorditionList.length,
                        //       itemBuilder: (BuildContext context, int index) {
                        //         return ListTile(
                        //           title: Text(
                        //             contents[3].accorditionList[index],
                        //             textAlign: TextAlign.justify,
                        //               style: const TextStyle(
                        //                 fontSize: 15,
                        //                 color: Colors.black,
                        //               ),
                        //             ),
                        //           onTap: () {
                        //             // Update the tapped item index
                        //             setState(() {
                        //               tappedIndex = index;
                        //             });
                        //           },
                        //         );
                        //       },
                        //     ),
                        //   )
                        Container(
                          child: Column(
                              children: [

                                Card(
                                  color: Colors.white,
                                  child:ExpansionTile(
                                  title: Text(contents[5].accorditionTitle[0],
                                  style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold
                                              ),),
                                  
                                  children: [
                                        Container( 
                                            color: Colors.black12,
                                            padding:const EdgeInsets.all(20),
                                            width: double.infinity,
                                            child:  Text(contents[5].accorditionDescrition[0]),
                                        )
                                  ],
                                  )
                                ),
                                const SizedBox(height: 10),
                                Card(
                                  color: Colors.white,
                                  child:ExpansionTile(
                                  title: Text(contents[5].accorditionTitle[1],
                                  style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold
                                              ),),
                                  
                                  children: [
                                        Container( 
                                            color: Colors.black12,
                                            padding:const EdgeInsets.all(20),
                                            width: double.infinity,
                                            child:  Text(contents[5].accorditionDescrition[1]),
                                        )
                                  ],
                                  )
                                ),
                                const SizedBox(height: 10),
                                Card(
                                  color: Colors.white,
                                  child:ExpansionTile(
                                  title: Text(contents[5].accorditionTitle[2],
                                  style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold
                                              ),),
                                  
                                  children: [
                                        Container( 
                                            color: Colors.black12,
                                            padding:const EdgeInsets.all(20),
                                            width: double.infinity,
                                            child:  Text(contents[5].accorditionDescrition[2]),
                                        )
                                  ],
                                  )
                                ),
                                const SizedBox(height: 10),
                                Card(
                                  color: Colors.white,
                                  child:ExpansionTile(
                                  title: Text(contents[5].accorditionTitle[3],
                                  style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold
                                              ),),
                                  
                                  children: [
                                        Container( 
                                            color: Colors.black12,
                                            padding:const EdgeInsets.all(20),
                                            width: double.infinity,
                                            child:  Text(contents[5].accorditionDescrition[3]),
                                        )
                                  ],
                                  )
                                ),
                                const SizedBox(height: 10),
                                Card(
                                  color: Colors.white,
                                  child:ExpansionTile(
                                  title: Text(contents[5].accorditionTitle[4],
                                  style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold
                                              ),),
                                  
                                  children: [
                                        Container( 
                                            color: Colors.black12,
                                            padding:const EdgeInsets.all(20),
                                            width: double.infinity,
                                            child:  Text(contents[5].accorditionDescrition[4]),
                                        )
                                  ],
                                  )
                                ),
                                const SizedBox(height: 10),
                                Card(
                                  color: Colors.white,
                                  child:ExpansionTile(
                                  title: Text(contents[5].accorditionTitle[5],
                                  style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold
                                              ),),
                                  
                                  children: [
                                        Container( 
                                            color: Colors.black12,
                                            padding:const EdgeInsets.all(20),
                                            width: double.infinity,
                                            child:  Text(contents[5].accorditionDescrition[5]),
                                        )
                                  ],
                                  )
                                ),
                                const SizedBox(height: 10),
                                Card(
                                  color: Colors.white,
                                  child:ExpansionTile(
                                  title: Text(contents[5].accorditionTitle[6],
                                  style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold
                                              ),),
                                  
                                  children: [
                                        Container( 
                                            color: Colors.black12,
                                            padding:const EdgeInsets.all(20),
                                            width: double.infinity,
                                            child:  Text(contents[5].accorditionDescrition[6]),
                                        )
                                  ],
                                  )
                                ),
                                const SizedBox(height: 20),

                                ExpansionPanelList(
                                    expansionCallback: (panelIndex, isExpanded) {
                                        setState(() {
                                          expanded[panelIndex] = !isExpanded;
                                        });
                                    },
                                    animationDuration: const Duration(seconds: 2)
                                )
                              ],
                          ),
                        )
                        
                      ],
                    ),
                  ),
                ),
              ],

              //Slider Container properties
              options: CarouselOptions(
                  height: 600,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  viewportFraction: 0.8,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
            ),
            // DotsIndicator(
            //   dotsCount: contents.length,
            //   position: _current.toInt(),
            //   decorator: DotsDecorator(
            //     shape: const Border(),
            //     activeColor: kPrimaryColor,
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
    );
  }
}
