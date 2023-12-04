
import 'dart:io';

import 'package:flutter/material.dart';

class ClaimModal extends ChangeNotifier {
  String? nameInsured;
  String? nameClaimant;
  String? postalAddress;
  String? postalCode;
  String? email;
  String? dateOfBirth;
  String? occupation;
  String? dateOfAccidentPremium;


  String? agencyName;
  String? PolicyNo;
  String? agencyPhone;
  String? emailAgency;


  String? dateOfAccident;
  String? locationOfAccident;
  String? accidentDescription;
  String? nameWitness;
  String? occupationWitness;
  String? telephone;
  String? addressWitness;
  File? medicalReport;
  File? sickSheet;
  File? policeAbstruct;
  List<File>? picturesOfAccident;

  String? claimantFullName;
  String? Occupation;
  File? medicalCert;
  File? proofOfEarning;
  File? deathCertificate;
  File? postMorterm;
  File? proofOfFuneralExpences;

  int activeIndex = 0;
  int totalIndex = 3;

  changeStep(int index) {
    activeIndex = index;
    notifyListeners();
  }
}