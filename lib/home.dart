// import 'dart:convert';
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:one_million_app/components/auth/onbording_screens/already_have_an_account_acheck.dart';
// import 'package:one_million_app/components/beneficiary/beneficiary_form_add.dart';
// import 'package:one_million_app/components/coverage/coverage_make_payments.dart';
// import 'package:one_million_app/components/notification/notification.dart';
// import 'package:one_million_app/components/upload_documents/upload_documents.dart';
// import 'package:one_million_app/core/constant_service.dart';
// import 'package:one_million_app/core/constant_urls.dart';
// import 'package:one_million_app/core/local_storage.dart';
// import 'package:one_million_app/core/model/default_claim.dart';
// import 'package:one_million_app/core/services/models/notification_model.dart';
// import 'package:one_million_app/core/services/models/uptodate_model.dart';
// import 'package:one_million_app/core/services/providers/notification_provider.dart';
// import 'package:one_million_app/core/services/providers/uptodate_providers.dart';
// import 'package:one_million_app/shared/constants.dart';
// import 'package:http/http.dart' as http;

// class DefaultList extends ConsumerStatefulWidget {
//   const DefaultList({super.key});

//   @override
//   ConsumerState<DefaultList> createState() {
//     return _DefaultListState();
//   }
// }

// class _DefaultListState extends ConsumerState<DefaultList> {
//   List<notificationListItem> _data = [];
//   var _isLoading = true;
//   String? error;

//   List<upToDateListItem> _dataUpToDate = [];
//   var _isLoadingUpToDate = true;
//   String? errorUpToDate;

//   num _selectedIndex = 0;

//   late List<String> message = [];
//   late List<String> title = [];
//   late List<String> readStatus = [];
//   late List<num> notificationIdList = [];

//   late notificationListModel availableData;
//   late upToDateListModel availableUpToDate;

//   bool buttonStatus = true;

//   num? userId;
//   String? name;
//   String? email;
//   String? phone_no;

//   //default Claim
//   Future defaultClaim(userId, promotionCode) async {
//     try {
//       var url = Uri.parse(
//           ApiConstants.baseUrl + ApiConstants.defaultPolicyPayEndpoint);
//       final headers = {'Content-Type': 'application/json'};
//       final body =
//           jsonEncode({"userId": userId, "promotionCode": promotionCode});

//       final response = await http.post(url, headers: headers, body: body);

//       var obj = jsonDecode(response.body);

//       var _statusCodeDefaultClaim;
//       var _statusMessage;
//       var _buttonStatus;

//       obj.forEach((key, value) {
//         _statusCodeDefaultClaim = obj["result"]["code"];
//         _statusMessage = obj["statusMessage"];

//         _buttonStatus = obj["result"]["data"];
//       });

//       setState(() {
//         buttonStatus = _buttonStatus;
//       });

//       if (_statusCodeDefaultClaim == 5000) {
//         throw Exception('Promotion Code successfully');
//       } else {
//         throw Exception(
//             'Unexpected Promotion Code error occured! Status code ${response.statusCode}');
//       }
//     } catch (e) {
//       print("Error: $e");
//       if (e is http.ClientException) {
//         print("Response Body: ${e.message}");
//       }
//       // log(e.toString());
//     }
//   }

//   String promotionCode = "";

//   Future<void> loadUserData() async {
//     await ApiService().defaultClaim(userId, '');
//     var _userId = await LocalStorage().getUserRegNo();
//     var _name = await LocalStorage().getUserName();
//     var _email = await LocalStorage().getEmail();
//     var _phone_no = await LocalStorage().getPhoneNo();
//     if (_userId != null) {
//       setState(() {
//         userId = _userId;
//         name = _name;
//         email = _email;
//         phone_no = _phone_no;
//         log('Button Status: $buttonStatus');
//       });
//     }
//   }

//   String? claimApplicationActive;
//   num? paymentAmountUptoDate;
//   String? qualifiesForCompensation;
//   String? uptoDatePayment;

//   @override
//   void initState() {
//     super.initState();
//     // // Reload shops
//     ref.read(notificationListListProvider.notifier).fetchNotificationList();

//     // // Reload shops
//     ref.read(upToDateListProvider.notifier).fetchUpToDate();
//   }

//   // late productsListModel availableData;

//   @override
//   Widget build(BuildContext context) {
//     availableData = ref.watch(notificationListListProvider);
//     availableUpToDate = ref.watch(upToDateListProvider);

//     setState(() {
//       _data = availableData.notification_list;
//       _isLoading = availableData.isLoading;

//       _dataUpToDate = availableUpToDate.uptodate_data;
//       _isLoadingUpToDate = availableUpToDate.isLoading;

//       for (var i = 0; i < _dataUpToDate.length; i++) {
//         claimApplicationActive = _dataUpToDate[i].claimApplicationActive;
//         paymentAmountUptoDate = _dataUpToDate[i].paymentAmount;
//         qualifiesForCompensation = _dataUpToDate[i].qualifiesForCompensation;
//         uptoDatePayment = _dataUpToDate[i].uptoDatePayment;
//       }

//       for (var i = 0; i < _data.length; i++) {
//         readStatus.add(_data[i].readStatus);
//       }
//       ;
//     });

//     Widget content = const Center(
//       child: Text('No data yet',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
//     );
//     Widget contentUptoDate = const Center(
//       child: Text('No data yet',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
//     );

//     if (_isLoading) {
//       content = const Center(
//         child: CircularProgressIndicator(),
//       );
//     }

//     if (_isLoadingUpToDate) {
//       contentUptoDate = const Center(
//         child: CircularProgressIndicator(),
//       );
//     }

//     if (error != null) {
//       content = Center(
//         child: Text(error!),
//       );
//     }

//     if (error != null) {
//       contentUptoDate = Center(
//         child: Text(error!),
//       );
//     }

//     if (_data.isEmpty) {
//       content = const Padding(
//         padding: EdgeInsets.all(8.0),
//         child: Card(
//           elevation: 5,
//           shadowColor: Colors.black,
//           child: Center(
//             child: Padding(
//               padding: EdgeInsets.all(40.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.info,
//                     size: 100,
//                     color: kPrimaryColor,
//                   ),
//                   SizedBox(height: 20),
//                   Text(
//                     'You have no activities',
//                     style: TextStyle(
//                         fontSize: 20,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold),
//                     // style: GoogleFonts.bebasNeue(fontSize: 72),
//                   ),
//                   SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     } else {
//       var itemCount = _data.length > 5 ? 5 : _data.length;
//       content = Container(
//         child: Column(
//           children: [
//             SizedBox(
//               height: 10,
//             ),
            
//             ListView.separated(
//               shrinkWrap: true,
//               padding: const EdgeInsets.all(8),
//               itemCount: itemCount,
//               itemBuilder: (BuildContext context, int index) {
//                 return Card(
//                     color: Colors.white,
//                     borderOnForeground: true,
//                     elevation: 6,
//                     child: ListTile(
//                       leading: Icon(Icons.notifications),
//                       title: Text(
//                         _data[index].type,
//                         style: (_data[index].readStatus == 'Unread')
//                             ? TextStyle(
//                                 fontWeight: FontWeight.bold,
//                               )
//                             : TextStyle(
//                                 fontWeight: FontWeight.normal,
//                               ),
//                       ),
//                       subtitle: Text(
//                         _data[index].message,
//                         style: (_data[index].readStatus == 'Unread')
//                             ? TextStyle(
//                                 fontWeight: FontWeight.bold,
//                               )
//                             : TextStyle(
//                                 fontWeight: FontWeight.normal,
//                               ),
//                       ),
//                       onTap: () async {
//                         await ApiService()
//                             .sendMarkAsRead(userId, _data[index].id);
//                       },
//                     ));
//               },
//               separatorBuilder: (BuildContext context, int index) =>
//                   const Divider(),
//             ),
//           ],
//         ),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: kPrimaryColor,
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),

//               // welcome home
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20),
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Row(
//                     children: [
//                       Container(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Welcome, ",
//                               style: const TextStyle(
//                                   fontSize: 20,
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             const SizedBox(height: 5),
//                             Text(
//                               "name!",
//                               style: const TextStyle(
//                                 fontSize: 15,
//                               ),
//                               // style: GoogleFonts.bebasNeue(fontSize: 72),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(width: 20),
//                       Center(
//                         child: Container(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               (uptoDatePayment != null &&
//                                       uptoDatePayment!.trim() != "")
//                                   ? TextButton(
//                                       onPressed: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) {
//                                               return MakePayments(
//                                                 userId: userId!,
//                                                 premiumSelected:
//                                                     paymentAmountUptoDate!,
//                                               );
//                                             },
//                                           ),
//                                         );
//                                       },
//                                       child: Card(
//                                         elevation: 5,
//                                         shadowColor: Colors.black,
//                                         color: (uptoDatePayment ==
//                                                 'payment up to date')
//                                             ? Colors.green
//                                             : Colors.red,
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(10.0),
//                                           child: Center(
//                                             child: Text(uptoDatePayment!),
//                                           ),
//                                         ),
//                                       ),
//                                     )
//                                   : TextButton(
//                                       onPressed: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) {
//                                               return MakePayments(
//                                                 userId: userId!,
//                                                 premiumSelected: paymentAmountUptoDate!,
//                                               );
//                                             },
//                                           ),
//                                         );
//                                       },
//                                       child: Card(
//                                         elevation: 5,
//                                         shadowColor: Colors.black,
//                                         color: Colors.red,
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(10.0),
//                                           child: Center(
//                                             child: Text('Not Covered'),
//                                           ),
//                                         ),
//                                       ),
//                                     )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 10),

//               //Divider

//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 30.0),
//                 child: Divider(
//                   thickness: 1,
//                   color: Color.fromARGB(255, 204, 204, 204),
//                 ),
//               ),

//               const SizedBox(height: 20),

//               //Home title
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 10),
//                 child: const Text(
//                   "Quick Actions",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 17,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 10),

//               Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Card(
//                   elevation: 5,
//                   shadowColor: Colors.black,
//                   child: Center(
//                       child: GridView.count(
//                     scrollDirection: Axis.vertical,
//                     shrinkWrap: true,
//                     primary: false,
//                     padding: const EdgeInsets.all(20),
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 10,
//                     crossAxisCount: 3,
//                     childAspectRatio: (280 / 280),
//                     children: <Widget>[
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         child: TextButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) {
//                                   return MakePayments(
//                                     userId: userId!,
//                                     premiumSelected: paymentAmountUptoDate!,
//                                   );
//                                 },
//                               ),
//                             );
//                           },
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               CircleAvatar(
//                                 radius: 25,
//                                 backgroundColor: kPrimaryColor,
//                                 child: Icon(
//                                   Icons.payment,
//                                   color: Colors.white,
//                                   size: 30,
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 3,
//                               ),
//                               Center(
//                                 child: Text(
//                                   'Pay',
//                                   style: TextStyle(
//                                       fontSize: 10, color: Colors.black),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         child: TextButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) {
//                                   return BeneficiaryFormPage();
//                                 },
//                               ),
//                             );
//                           },
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               CircleAvatar(
//                                 radius: 25,
//                                 backgroundColor: kPrimaryColor,
//                                 child: Icon(
//                                   Icons.people,
//                                   color: Colors.white,
//                                   size: 35,
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 3,
//                               ),
//                               Center(
//                                 child: Text(
//                                   'Dependants',
//                                   style: TextStyle(
//                                       fontSize: 10, color: Colors.black),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         child: TextButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) {
//                                   return UploadFiles(userId: userId!);
//                                 },
//                               ),
//                             );
//                           },
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               CircleAvatar(
//                                 radius: 25,
//                                 backgroundColor: kPrimaryColor,
//                                 child: Icon(
//                                   Icons.file_download,
//                                   color: Colors.white,
//                                   size: 35,
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 3,
//                               ),
//                               Center(
//                                 child: Text(
//                                   'Documents',
//                                   style: TextStyle(
//                                       fontSize: 10, color: Colors.black),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         child: TextButton(
//                           onPressed: () async {
//                             await ApiService().generatePromo(userId);
//                           },
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               CircleAvatar(
//                                 radius: 25,
//                                 backgroundColor: kPrimaryColor,
//                                 child: Icon(
//                                   Icons.share,
//                                   color: Colors.white,
//                                   size: 35,
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 3,
//                               ),
//                               Center(
//                                 child: Text(
//                                   'Share',
//                                   style: TextStyle(
//                                       fontSize: 10, color: Colors.black),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         child: (buttonStatus == false)
//                             ? TextButton(
//                                 onPressed: null,
//                                 child: Column(
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.stretch,
//                                   children: [
//                                     CircleAvatar(
//                                       radius: 25,
//                                       backgroundColor: kPrimaryColor,
//                                       child: Icon(
//                                         Icons.folder,
//                                         color: Colors.white,
//                                         size: 35,
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 3,
//                                     ),
//                                     Center(
//                                       child: Text(
//                                         'Default Claims',
//                                         style: TextStyle(
//                                             fontSize: 10, color: Colors.black),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             : TextButton(
//                                 onPressed: () async {
//                                   await ApiService()
//                                       .claimDefault(userId, promotionCode);
//                                 },
//                                 child: Column(
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.stretch,
//                                   children: [
//                                     CircleAvatar(
//                                       radius: 25,
//                                       backgroundColor: kPrimaryColor,
//                                       child: Icon(
//                                         Icons.folder,
//                                         color: kPrimaryColor,
//                                         size: 35,
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 5,
//                                     ),
//                                     Center(
//                                       child: Text(
//                                         'Default Claims',
//                                         style: TextStyle(
//                                             fontSize: 10, color: Colors.black),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                       ),
//                     ],
//                   )),
//                 ),
//               ),

//               const SizedBox(height: 10),

//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       "Recent Activities",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 17,
//                         color: Colors.black,
//                       ),
//                     ),
//                     ViewAll(
//                       press: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) {
//                               return NotificationList();
//                             },
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 10),

//               Container(
//                 child: Center(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [content],
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Helper class
// class Utils {
//   static String getFormattedDateSimple(int time) {
//     DateFormat newFormat = DateFormat("MMMM dd yyyy");
//     return newFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
//   }

//   static String getFormattedDateSimpleMonthAddDate(int time) {
//     DateFormat newFormat = DateFormat("MMMM dd");
//     return newFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
//   }

//   static String getFormattedDateSimpleMonthAddDateLess(int time) {
//     DateFormat newFormat = DateFormat("MMM dd");
//     return newFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
//   }

//   static String getFormattedDateSimpleFilter(int time) {
//     DateFormat newFormat = DateFormat("yyyy-MM-dd");
//     return newFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
//   }

//   static String getFormattedDateSimpleToday(int time) {
//     DateFormat newFormat = DateFormat("dd MMMM");
//     return newFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
//   }
// }
