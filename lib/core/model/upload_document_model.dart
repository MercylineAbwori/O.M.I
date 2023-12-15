import 'dart:io';

import 'package:flutter/material.dart';

class UploadFileModal extends ChangeNotifier {

  num? userId;
  String? documentName;
  File? file;

  UploadFileModal({
    required this.userId,
    required this.documentName,
    required this.file,
    
  });


 factory UploadFileModal.fromJson(Map<String, dynamic> json) {
    return UploadFileModal(
      userId: json['userId'],
      documentName: json['documentName'],
      file: json['file'],
    );
  }
}