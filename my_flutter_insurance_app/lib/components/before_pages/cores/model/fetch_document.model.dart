import 'dart:io';

import 'package:flutter/material.dart';

class FetchFileModal extends ChangeNotifier {

  num? userId;
  String? documentName;

  FetchFileModal({
    required this.userId,
    required this.documentName
    
  });


 factory FetchFileModal.fromJson(Map<String, dynamic> json) {
    return FetchFileModal(
      userId: json['userId'],
      documentName: json['documentName'],
    );
  }
}