import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:one_million_app/components/claims/claim_form/claim_form_review.dart';
import 'package:one_million_app/components/claims/claim_form/claim_home_form_screen.dart';
import 'package:one_million_app/components/notification/notification.dart';
import 'package:one_million_app/components/profile/profile.dart';
import 'package:one_million_app/shared/constants.dart';

class ClaimHomePage extends StatefulWidget {
  final num userId;
  final String userName;
  final String phone;
  final String email;
  final List<String> title;
  final List<String> message;
  final List<String> readStatus;
  final List<num> notificationIdList;

  final List<dynamic> claimListData;
  final String uptoDatePayment;
  final num paymentAmount;
  final String claimApplicationActive;
 final String qualifiesForCompensation;

  const ClaimHomePage(
      {Key? key,
      required this.userId,
      required this.userName,
      required this.phone,
      required this.email,
      required this.title,
      required this.message,
      required this.readStatus,
      required this.notificationIdList,
      required this.claimListData,
      required this.paymentAmount,
      required this.claimApplicationActive,
      required this.qualifiesForCompensation,
      required this.uptoDatePayment
      })
      : super(key: key);
  @override
  _ClaimHomePageState createState() => _ClaimHomePageState();
}

class _ClaimHomePageState extends State<ClaimHomePage>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> basicFormKey = GlobalKey<FormState>();

  List<File> selectedImages = [];
  // final picker = ImagePicker();

  // FilePickerResult? resultMedicalReport;

  // FilePickerResult? resultMedicalCertificate;
  // FilePickerResult? resultProofOfEarning;
  // FilePickerResult? resultDeathCertificate;

  // FilePickerResult? resultPostMortem;
  // FilePickerResult? resultProofOfFuneralExpences;

  // FilePickerResult? resultSickSheet;

  // FilePickerResult? resultPostMortem;
  // FilePickerResult? resultProofOfFuneralExpences;
  // FilePickerResult? resultMedicalReport;
  // FilePickerResult? resultSickSheet;
  // FilePickerResult? resultPoliceAbstruct;

  // FilePickerResult? resultMedicalCertificate;
  // FilePickerResult? resultProofOfEarning;
  // FilePickerResult? resultDeathCertificate;
  String initialCountry = 'KE';

  TextEditingController nameInsuredController = TextEditingController();
  TextEditingController nameClaimantController = TextEditingController();
  TextEditingController postalAddressController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  TextEditingController dateOfBirthInputController = TextEditingController();
  TextEditingController dateOfLastPremiumInputController =
      TextEditingController();
  TextEditingController agencyController = TextEditingController();
  TextEditingController policyNoController = TextEditingController();
  TextEditingController agencyPhoneNoController = TextEditingController();
  TextEditingController agencyEmailController = TextEditingController();

  TextEditingController textarea = TextEditingController();
  TextEditingController dateOfAccidentPremiumInputController =
      TextEditingController();
  TextEditingController locationOfAccidentController = TextEditingController();
  TextEditingController witnessOccupationController = TextEditingController();
  TextEditingController witnessTelephoneController = TextEditingController();
  TextEditingController witnessNameController = TextEditingController();
  TextEditingController witnessAddressController = TextEditingController();

  TextEditingController claimantFullNameController = TextEditingController();
  TextEditingController claimantOccupationController = TextEditingController();

  FocusNode claimantFullNameNode = FocusNode();
  FocusNode claimantOccupationNode = FocusNode();
  FocusNode nameInsuredNode = FocusNode();
  FocusNode nameClaimantNode = FocusNode();
  FocusNode postalAddressNode = FocusNode();
  FocusNode postalCodeNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode occupationNode = FocusNode();
  FocusNode dateOfBirthInputNode = FocusNode();
  FocusNode dateOfLastPremiumInputNode = FocusNode();
  FocusNode agencyNode = FocusNode();
  FocusNode policyNoNode = FocusNode();
  FocusNode agencyPhoneNoNode = FocusNode();
  FocusNode agencyEmailNode = FocusNode();
  FocusNode dateOfAccidentPremiumInputControllerNode = FocusNode();
  FocusNode locationOfAccidentNode = FocusNode();
  FocusNode witnessOccupationNode = FocusNode();
  FocusNode witnessTelephoneNode = FocusNode();
  FocusNode witnessNameNode = FocusNode();
  FocusNode witnessAddressNode = FocusNode();

  // final picker = ImagePicker();

  // padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  late final List<dynamic> _elements;

  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  // final List<dynamic> _elements = [
  //   {
  //     'title': 'Claim One',
  //     'status': 'Pending',
  //     'date': 'Set 10th 2023',
  //     'type': 'death'
  //   },
  //   {
  //     'title': 'Claim Two',
  //     'status': 'In Review',
  //     'date': 'Set 10th 2023',
  //     'type': 'medical expences'
  //   },
  //   {
  //     'title': 'Claim Three',
  //     'status': 'Completed',
  //     'date': 'Set 10th 2023',
  //     'type': 'temporary disability'
  //   },
  //   {
  //     'title': 'Claim Four',
  //     'status': 'Failed',
  //     'date': 'Set 10th 2023',
  //     'type': 'permanent disability'
  //   }
  // ];

  //Claim LISTS

  List<String> claimType = <String>[
    'Death',
    'Medical Expenses',
    'Temporary Diasability',
    'Permanent Disability',
  ];
  List<String> selectedClaimType = [];

  late List<String> message = [];

  String? claimApplicationActive;
  num? paymentAmount;
  String? qualifiesForCompensation;
  String? uptoDatePayment;

  @override
  void initState() {
    super.initState();

    claimApplicationActive = widget.claimApplicationActive;
    paymentAmount = widget.paymentAmount; 
    qualifiesForCompensation = widget.qualifiesForCompensation;
    uptoDatePayment = widget.uptoDatePayment;
  }

  @override
  Widget build(BuildContext context) {
    _elements = widget.claimListData;

    final List<dynamic> itemsTitles = _elements.map((e) {
      return e['claimType'];
    }).toList();
    final List<dynamic> itemsStatus = _elements.map((e) {
      return e['processingStatus'];
    }).toList();
    final List<dynamic> itemsDate = _elements.map((e) {
      return e['updatedAt'];
    }).toList();
    final List<dynamic> itemsType = _elements.map((e) {
      return ['claimType'];
    }).toList();

    //Claim List Container
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                      return NotificationPage(
                          userId: widget.userId,
                          readStatus: widget.readStatus,
                          title: widget.title,
                          message: widget.message);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Container(
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
                        padding:
                            EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: const Text(
                          "Claims",
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
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 5,
                            shadowColor: Colors.black,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(40.0),
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
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return ClaimForm(
                                                userId: widget.userId,
                                                claimApplicationActive: widget.claimApplicationActive,
                                                paymentAmount: widget.paymentAmount,
                                                qualifiesForCompensation: widget.qualifiesForCompensation,
                                                uptoDatePayment: widget.uptoDatePayment,
                                              );
                                            },
                                          ),
                                        );
                                        // _showDia// log();
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
                      : const SizedBox(height: 20),
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
                                      child: Icon(itemsType.toList()[index] ==
                                              'death'
                                          ? Icons.dangerous
                                          : itemsType.toList()[index] ==
                                                  'permanent disability'
                                              ? Icons.wheelchair_pickup_outlined
                                              : itemsType.toList()[index] ==
                                                      'temporary disability'
                                                  ? Icons.personal_injury
                                                  :itemsType.toList()[index] ==
                                                      'artificial appliances'
                                                  ? Icons.emoji_flags
                                                  :itemsType.toList()[index] ==
                                                      'funeral expences'
                                                  ? Icons.money_off
                                                  
                                                  : Icons
                                                      .medical_information_outlined),
                                    ),
                                    title: Text(itemsTitles.toList()[index]),
                                    subtitle: Text(formatter.format(DateTime.parse(itemsDate.toList()[index])),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        )),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          itemsStatus.toList()[index] ==
                                                  'pending'
                                              ? 'Pending'
                                              : itemsStatus.toList()[index] ==
                                                      'in review'
                                                  ? 'In Review'
                                                  : itemsStatus.toList()[
                                                              index] ==
                                                          'completed'
                                                      ? 'Completed'
                                                      : 'Failed',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: itemsStatus
                                                        .toList()[index] ==
                                                    'failed'
                                                ? Colors.red
                                                : itemsStatus.toList()[index] ==
                                                        'pending'
                                                    ? Colors.yellow
                                                    : itemsStatus.toList()[
                                                                index] ==
                                                            'in Review'
                                                        ? Colors.blue
                                                        : Colors.green,
                                          ),
                                        ),

                                        // IconButton(
                                        //   iconSize: 30,
                                        //   icon: const Icon(
                                        //     Icons.arrow_forward,
                                        //     color: kPrimaryColor,
                                        //   ),
                                        //   // the method which is called
                                        //   // when button is pressed
                                        //   onPressed: () {
                                        //     Navigator.push(
                                        //       context,
                                        //       MaterialPageRoute(
                                        //         builder: (context) {
                                        //           return ClaimReviewForm(
                                        //               userId: widget.userId);
                                        //         },
                                        //       ),
                                        //     );
                                        //   },
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                        ),
                      ),
                      const Padding(
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ClaimForm(
                  userId: widget.userId,
                  claimApplicationActive: widget.claimApplicationActive,
                  paymentAmount: widget.paymentAmount,
                  qualifiesForCompensation: widget.qualifiesForCompensation,
                  uptoDatePayment: widget.uptoDatePayment,
                );
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
