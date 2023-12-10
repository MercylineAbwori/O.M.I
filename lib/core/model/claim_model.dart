
// import 'dart:io';

// import 'package:flutter/material.dart';

// class ClaimModal extends ChangeNotifier {
//   String? nameInsured;
//   String? nameClaimant;
//   String? postalAddress;
//   String? postalCode;
//   String? email;
//   String? dateOfBirth;
//   String? occupation;
//   String? dateOfAccidentPremium;


//   String? agencyName;
//   String? PolicyNo;
//   String? agencyPhone;
//   String? emailAgency;


//   String? dateOfAccident;
//   String? locationOfAccident;
//   String? accidentDescription;
//   String? nameWitness;
//   String? occupationWitness;
//   String? telephone;
//   String? addressWitness;
//   File? medicalReport;
//   File? sickSheet;
//   File? policeAbstruct;
//   List<File>? picturesOfAccident;

//   String? claimantFullName;
//   String? Occupation;
//   File? medicalCert;
//   File? proofOfEarning;
//   File? deathCertificate;
//   File? postMorterm;
//   File? proofOfFuneralExpences;

//   int activeIndex = 0;
//   int totalIndex = 3;

//   changeStep(int index) {
//     activeIndex = index;
//     notifyListeners();
//   }
// }



import 'dart:io';

import 'package:flutter/foundation.dart';

class ClaimModal extends ChangeNotifier {

  num? userId;
  File? claimForm;
  File? accidentDetails;
  File? location;
  File? policeAbstract;

    int activeIndex = 0;
  int totalIndex = 3;

  changeStep(int index) {
    activeIndex = index;
    notifyListeners();
  }

  ClaimModal({
    required this.userId,
    required this.claimForm,
    required this.accidentDetails,
    required this.location,
    required this.policeAbstract
    
  });


 factory ClaimModal.fromJson(Map<String, dynamic> json) {
    return ClaimModal(
      userId: json['userId'],
      claimForm: json['claimForm'],
      accidentDetails: json['accidentDetails'],
      location: json['location'],
      policeAbstract: json['policeAbstract'],
    );
  }
}