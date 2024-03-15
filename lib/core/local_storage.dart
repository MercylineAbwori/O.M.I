import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {

  //=========================================================================
  //                            User Local Storage                            
  //=========================================================================

//Code

  storePolicyDetailsCode(int code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt('setPolicyDetailsCode', code);
  }
  
  getPolicyDetailsCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt('setPolicyDetailsCode') ?? 0;
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

//Code

  storePromoStatusCode(int code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt('promoStatusCode', code);
  }
  
  getPromoStatusCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt('promoStatusCode') ?? 0;
  }

//Code

  storeMakePaymentsCode(int code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt('makePaymentsCode', code);
  }
  
  getMakePaymentsCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt('makePaymentsCode') ?? 0;
  }


//OTP

  storeOTP(int otp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt('otp', otp);
  }
  
  getOTP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt('otp') ?? 0;
  }




  //User Reg No

  storeRecentActivityCount(int count) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt('count', count);
  }
  
  getRecentActivityCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt('count') ?? 0;
  }

  updateRecentActivityCount(int user_reg_no) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt('count', user_reg_no);
  }

  removeRecentActivityCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.remove('count');
  }


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

  //ProfilePicture

  storeProfilePicture(String profile_picture) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString('profilePicture', profile_picture);
  }
  
  getProfilePicture() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('profilePicture') ?? '';
  }

  updateProfilePicture(String profile_picture) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString('profilePicture', profile_picture);
  }

  removeProfilePicture() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.remove('profilePicture');
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

    return prefs.remove('Email');
  }

  //User Email

  storePhoneNo(String phone_no) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString('phoneNo', phone_no);
  }
  
  getPhoneNo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('phoneNo') ?? '';
  }

  updatePhoneNo(String phone_no) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString('phoneNo', phone_no);
  }

  removePhoneNo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.remove('phoneNo');
  }





}