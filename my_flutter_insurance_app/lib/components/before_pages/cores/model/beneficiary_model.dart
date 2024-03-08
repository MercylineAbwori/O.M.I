

import 'package:flutter/foundation.dart';

class BeneficiaryModal extends ChangeNotifier {

  String? beneficiaryName;
  String? memberId;
  String? gender;
  String? dateOfBirth;

  
  BeneficiaryModal({
    required this.beneficiaryName,
    required this.memberId,
    required this.gender,
    required this.dateOfBirth,
    
  });


 factory BeneficiaryModal.fromJson(Map<String, dynamic> json) {
    return BeneficiaryModal(
      beneficiaryName: json['beneficiaryName'],
      memberId: json['memberId'],
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'],
    );
  }
}