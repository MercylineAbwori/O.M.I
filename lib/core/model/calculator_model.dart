
import 'package:flutter/foundation.dart';

class CalculatorModal extends ChangeNotifier {

  num? sumInsured;
  num? dependants;
  num? packages;


  CalculatorModal({
    required this.sumInsured,
    required this.dependants,
    required this.packages,
    
  });


 factory CalculatorModal.fromJson(Map<String, dynamic> json) {
    return CalculatorModal(
      sumInsured: json['sumInsured'],
      dependants: json['dependants'],
      packages: json['packages'],
    );
  }
}