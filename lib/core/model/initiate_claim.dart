import 'dart:io';

import 'package:flutter/material.dart';

class InitiateClaimModal extends ChangeNotifier {
  num? userId;

  num? claimId;

  String? claimType;
  File? claimForm;

  File? medicalReport;
  File? sickSheet;
  File? policeAbstruct;
  List<File>? picturesOfAccident;

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
