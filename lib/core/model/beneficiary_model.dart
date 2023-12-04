

import 'package:flutter/foundation.dart';

class BeneficiaryModal extends ChangeNotifier {

  String? beneficiaryName;
  num? memeberId;
  String? gender;
  String? dateOfBirth;

  
  BeneficiaryModal({
    required this.beneficiaryName,
    required this.memeberId,
    required this.gender,
    required this.dateOfBirth,
    
  });


 factory BeneficiaryModal.fromJson(Map<String, dynamic> json) {
    return BeneficiaryModal(
      beneficiaryName: json['beneficiaryName'],
      memeberId: json['memeberId'],
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'],
    );
  }
}