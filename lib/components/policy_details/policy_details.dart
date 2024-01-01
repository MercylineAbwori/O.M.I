import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/model/policy_details.dart';
import 'package:one_million_app/shared/constants.dart';
import 'package:http/http.dart' as http;

//constants
const buttonTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w900,
);

class PolicyDetailsScreen extends StatefulWidget {
  final num userId;
  const PolicyDetailsScreen({super.key,
      required this.userId});

  @override
  _PolicyDetailsScreenState createState() => _PolicyDetailsScreenState();
}

class _PolicyDetailsScreenState extends State<PolicyDetailsScreen> {
  // padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  late String paymentAmount = '';
  late String paymentPeriod;
  late String policyNumber;
  late num sumInsured;

  //policy Details Modal
  Future<List<PolicyDetailsModal>?> getPolicyDetails(userId) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.policyDetailsEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        // "userId": userId,
        "userId": userId
      });

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);

      var _statusCodePolicyDetails;

      obj.forEach((key, value) {
        _statusCodePolicyDetails = obj["result"]["code"];

        paymentAmount = obj["result"]["data"]["paymentAmount"];
        paymentPeriod = obj["result"]["data"]["paymentPeriod"];
        policyNumber = obj["result"]["data"]["policyNumber"];
        sumInsured = obj["result"]["data"]["sumInsured"];
      });

      if (_statusCodePolicyDetails == 5000) {
        throw Exception('Policy Details Displayed successfully');
      } else {
        throw Exception(
            'Unexpected Policy Details Displayed  error occured! Status code ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      // log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      getPolicyDetails(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Container(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(
              iconSize: 100,
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 20,
              ),
              // the method which is called
              // when button is pressed
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // welcome home
              Row(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Add Beneficiary",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),

              const SizedBox(height: 10),

              //Divider

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Divider(
                  thickness: 1,
                  color: Color.fromARGB(255, 204, 204, 204),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  OutlineInputBorder myinputborder() {
    //return type is OutlineInputBorder
    return const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 0),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ));
  }

  OutlineInputBorder myfocusborder() {
    return const OutlineInputBorder(
        borderSide: BorderSide(color: kPrimaryColor, width: 0),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ));
  }
}

Widget CustomButton(
    {required String title,
    required IconData icon,
    required VoidCallback onClick}) {
  return Container(
    width: 200,
    child: ElevatedButton(
      onPressed: onClick,
      child: Row(
        children: [
          Icon(icon),
          SizedBox(
            width: 10,
          ),
          Text(title)
        ],
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryLightColor,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
    ),
  );
}
