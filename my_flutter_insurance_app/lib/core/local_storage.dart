import 'dart:convert';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {

  final secureStorage = FlutterSecureStorage();


  //=========================================================================
  //                            User Local Storage                            
  //=========================================================================



//User Reg No

  storeUserRegNo(int user_reg_no) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt('userId', user_reg_no);
  }
  
  getUserRegNo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt('userId') ?? 0;
  }

  updateUserRegNo(int user_reg_no) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt('userId', user_reg_no);
  }

  removeUserRegNo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.remove('userId');
  }


//User PhoneNo

  storePhoneNo(int phone_no) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt('phoneNo', phone_no);
  }
  
  getPhoneNo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt('phoneNo') ?? 0;
  }

  updatePhoneNo(int phone_no) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt('phoneNo', phone_no);
  }

  removePhoneNo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.remove('phoneNo');
  }

//User Name

  storeUserName(String user_name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString('userName', user_name);
  }
  
  getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('userName') ?? '';
  }

  updateUserName(String user_name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString('userName', user_name);
  }

  removeUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.remove('userName');
  }

//User Email

  storeEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString('email', email);
  }
  
  getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('email') ?? '';
  }

  updateEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString('email', email);
  }

  removeEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.remove('email');
  }


  //=========================================================================
  //                            Saved Status Code                            
  //=========================================================================

//Code

  storeSetPromoCode(int code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt('setPromoCode', code);
  }
  
  getSetPromoCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt('setPromoCode') ?? 0;
  }


//Code

  storeSetOTPCode(int code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt('setOTPCode', code);
  }
  
  getSetOTPCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt('setOTPCode') ?? 0;
  }

//Code

  storeVerifyCode(int code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt('verifyCode', code);
  }
  
  getVerifyCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt('verifyCode') ?? 0;
  }

//Code

  storeResetCode(int code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt('resetCode', code);
  }
  
  getResetCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt('resetCode') ?? 0;
  }

//Code

  storeRegistrationCode(int code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt('registrationCode', code);
  }
  
  getRegistrationCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt('registrationCode') ?? 0;
  }



//Code

  storeLoginCode(int code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt('loginCode', code);
  }
  
  getLoginCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt('loginCode') ?? 0;
  }






}