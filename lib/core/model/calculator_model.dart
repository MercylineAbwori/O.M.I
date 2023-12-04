
import 'package:flutter/foundation.dart';

class CalculatorModal extends ChangeNotifier {

  num? sumInsured;


  CalculatorModal({
    required this.sumInsured,
    
  });


 factory CalculatorModal.fromJson(Map<String, dynamic> json) {
    return CalculatorModal(
      sumInsured: json['sumInsured'],
    );
  }
}