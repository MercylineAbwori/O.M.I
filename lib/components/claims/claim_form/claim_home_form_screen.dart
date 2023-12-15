import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:one_million_app/components/claims/generate_pdf.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/model/upload_document_model.dart';
import 'package:one_million_app/shared/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ClaimForm extends StatefulWidget {
  final num userId;

  const ClaimForm({
    Key? key,
    required this.userId,
  }) : super(key: key);
  @override
  _ClaimFormState createState() => _ClaimFormState();
}

class _ClaimFormState extends State<ClaimForm>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> basicFormKey = GlobalKey<FormState>();

  List<File> selectedImages = [];

  List<File> selectedfiles = [];
  final picker = ImagePicker();

  FilePickerResult? resultMedicalReport;

  // FilePickerResult? resultMedicalCertificate;
  // FilePickerResult? resultProofOfEarning;
  FilePickerResult? resultDeathCertificate;

  FilePickerResult? resultPostMortem;
  FilePickerResult? resultProofOfFuneralExpences;

  FilePickerResult? resultSickSheet;

  FilePickerResult? resultPoliceAbstruct;


  String initialCountry = 'KE';

  TextEditingController nameInsuredController = TextEditingController();
  TextEditingController nameClaimantController = TextEditingController();
  TextEditingController postalAddressController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  TextEditingController dateOfBirthInputController = TextEditingController();
  TextEditingController dateOfLastPremiumInputController =
      TextEditingController();
  TextEditingController agencyController = TextEditingController();
  TextEditingController policyNoController = TextEditingController();
  TextEditingController agencyPhoneNoController = TextEditingController();
  TextEditingController agencyEmailController = TextEditingController();

  TextEditingController textarea = TextEditingController();
  TextEditingController dateOfAccidentPremiumInputController =
      TextEditingController();
  TextEditingController locationOfAccidentController = TextEditingController();
  TextEditingController witnessOccupationController = TextEditingController();
  TextEditingController witnessTelephoneController = TextEditingController();
  TextEditingController witnessNameController = TextEditingController();
  TextEditingController witnessAddressController = TextEditingController();

  TextEditingController claimantFullNameController = TextEditingController();
  TextEditingController claimantOccupationController = TextEditingController();


  FocusNode claimantFullNameNode = FocusNode();
  FocusNode claimantOccupationNode = FocusNode();
  FocusNode nameInsuredNode = FocusNode();
  FocusNode nameClaimantNode = FocusNode();
  FocusNode postalAddressNode = FocusNode();
  FocusNode postalCodeNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode occupationNode = FocusNode();
  FocusNode dateOfBirthInputNode = FocusNode();
  FocusNode dateOfLastPremiumInputNode = FocusNode();
  FocusNode agencyNode = FocusNode();
  FocusNode policyNoNode = FocusNode();
  FocusNode agencyPhoneNoNode = FocusNode();
  FocusNode agencyEmailNode = FocusNode();
  FocusNode dateOfAccidentPremiumInputControllerNode = FocusNode();
  FocusNode locationOfAccidentNode = FocusNode();
  FocusNode witnessOccupationNode = FocusNode();
  FocusNode witnessTelephoneNode = FocusNode();
  FocusNode witnessNameNode = FocusNode();
  FocusNode witnessAddressNode = FocusNode();

  //All File boolean
  bool? _isButtonDisabledResultMedicalReport;
  bool? _isButtonDisabledResultMedicalCertificate;
  bool? _isButtonDisabledResultProofOfEarning;
  bool? _isButtonDisabledResultDeathCertificate;
  bool? _isButtonDisabledResultPostMortem;
  bool? _isButtonDisabledResultProofOfFuneralExpences;
  bool? _isButtonDisabledResultSickSheet;
  bool? _isButtonDisabledResultPoliceAbstruct;
  bool? _isButtonDisabledClaimForm;

  //All file responce messages
  String? messageResultMedicalReport;
  String? messageResultMedicalCertificate;
  String? messageResultProofOfEarning;
  String? messageResultDeathCertificate;
  String? messageResultPostMortem;
  String? messageResultProofOfFuneralExpences;
  String? messageResultSickSheet;
  String? messageResultPoliceAbstruct;
  String? messageResultClaimForm;


  late TabController _tabController;

  final _selectedColor = kPrimaryColor;

  final _tabs = [
    const Tab(text: 'Claim Form'),
    const Tab(text: 'Upload Documents'),
  ];

  Future getImages() async {
    final pickedFile = await picker.pickMultiImage(
      imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;

    setState(
    () {
      if (xfilePick.isNotEmpty) {
      for (var i = 0; i < xfilePick.length; i++) {
        selectedImages.add(File(xfilePick[i].path));
      }
      } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nothing is selected')));
      }
    },
    );
    
    Future<List<UploadFileModal>?> pickerFiles(userId, documentName, file) async {
    try {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              ApiConstants.baseUrl + ApiConstants.uploadDocumentEndpoint));

      request.files.add(http.MultipartFile(documentName,
          File(file).readAsBytes().asStream(), File(file).lengthSync()));

      var response = await request.send();
      var responced = await http.Response.fromStream(response);

      final responseData = json.decode(responced.body);

      if (response.statusCode == 200) {
        if (file == resultMedicalReport) {
          messageResultMedicalReport = responseData["result"]["message"];
        } else if (file == resultDeathCertificate) {
          messageResultDeathCertificate = responseData["result"]["message"];
        } else if (file == resultPostMortem) {
          messageResultPostMortem = responseData["result"]["message"];
        } else if (file == resultProofOfFuneralExpences) {
          messageResultProofOfFuneralExpences = responseData["result"]["message"];
        }else if (file == resultSickSheet) {
          messageResultSickSheet = responseData["result"]["message"];
        } else if (file == resultPoliceAbstruct) {
          messageResultPoliceAbstruct = responseData["result"]["message"];
        } 
        // else if (file == claimForm) {
        //   messageResultClaimForm = responseData["result"]["message"];
        // }
      } else {
        throw Exception('Unexpected Calculator error occured!');
      }
    } on PlatformException catch (e) {
      log('Unsupported operation' + e.toString());
    } catch (e) {
      log(e.toString());
    }
    setState(() {
      _isButtonDisabledResultMedicalReport = true;
    });
  }

   
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
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: <Widget>[
              Container(
                constraints: BoxConstraints.expand(height: 80),
                padding: EdgeInsets.all(10),
                child: Container(
                  height: kToolbarHeight - 8.0,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: _selectedColor),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    tabs: _tabs,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: TabBarView(children: [
                    Container(
                      child: SingleChildScrollView(
                        child: Card(
                          child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Form(
                                child: Column(
                                  children: [
                                    //Insured Details
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(15),
                                              child: Text(
                                                'Insured Details',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold, fontSize: 17),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: TextFormField(
                                                // focusNode: focusNode,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  labelText: "Name of Insured",
                                                  // labelStyle: labelStyle,,
                                                  labelStyle: const TextStyle(color: Colors.grey),
                                                  border: myinputborder(),
                                                  enabledBorder: myinputborder(),
                                                  focusedBorder: myfocusborder(),
                                                ),
                                                validator: RequiredValidator(
                                                  errorText: "Required *",
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: TextFormField(
                                                decoration: InputDecoration(
                                                  labelText: "Name of Claimant",
                                                  labelStyle: const TextStyle(color: Colors.grey),
                                                  border: myinputborder(),
                                                  enabledBorder: myinputborder(),
                                                  focusedBorder: myfocusborder(),
                                                ),
                                                validator: RequiredValidator(
                                                  errorText: "Required *",
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10.0),
                                                    child: TextFormField(
                                                      decoration: InputDecoration(
                                                        labelText: "Postal Address",
                                                        labelStyle:
                                                            const TextStyle(color: Colors.grey),
                                                        border: myinputborder(),
                                                        enabledBorder: myinputborder(),
                                                        focusedBorder: myfocusborder(),
                                                      ),
                                                      validator: RequiredValidator(
                                                        errorText: "Required *",
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20.0,
                                                ),
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10.0),
                                                    child: TextFormField(
                                                      decoration: InputDecoration(
                                                        labelText: "Postal Code",
                                                        labelStyle:
                                                            const TextStyle(color: Colors.grey),
                                                        border: myinputborder(),
                                                        enabledBorder: myinputborder(),
                                                        focusedBorder: myfocusborder(),
                                                      ),
                                                      validator: RequiredValidator(
                                                        errorText: "Required *",
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: TextFormField(
                                                decoration: InputDecoration(
                                                  labelText: "Email",
                                                  labelStyle: const TextStyle(color: Colors.grey),
                                                  border: myinputborder(),
                                                  enabledBorder: myinputborder(),
                                                  focusedBorder: myfocusborder(),
                                                ),
                                                validator: RequiredValidator(
                                                  errorText: "Required *",
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10.0),
                                                    child: TextFormField(
                                                      decoration: InputDecoration(
                                                        labelText: 'Date of Birth',
                                                        border: myinputborder(),
                                                        enabledBorder: myinputborder(),
                                                        focusedBorder: myfocusborder(),
                                                      ),
                                                      controller: dateOfBirthInputController,
                                                      readOnly: true,
                                                      onTap: () async {
                                                        DateTime? pickedDate = await showDatePicker(
                                                            context: context,
                                                            initialDate: DateTime.now(),
                                                            firstDate: DateTime(1950),
                                                            lastDate: DateTime(2050));

                                                        if (pickedDate != null) {
                                                          dateOfBirthInputController.text =
                                                              pickedDate.toString();
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20.0,
                                                ),
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10.0),
                                                    child: TextFormField(
                                                      decoration: InputDecoration(
                                                        labelText: "Occupation",
                                                        labelStyle:
                                                            const TextStyle(color: Colors.grey),
                                                        border: myinputborder(),
                                                        enabledBorder: myinputborder(),
                                                        focusedBorder: myfocusborder(),
                                                      ),
                                                      validator: RequiredValidator(
                                                        errorText: "Required *",
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: TextFormField(
                                                decoration: InputDecoration(
                                                  labelText: 'Date of last premium',
                                                  border: myinputborder(),
                                                  enabledBorder: myinputborder(),
                                                  focusedBorder: myfocusborder(),
                                                ),
                                                controller: dateOfLastPremiumInputController,
                                                readOnly: true,
                                                onTap: () async {
                                                  DateTime? pickedDate = await showDatePicker(
                                                      context: context,
                                                      initialDate: DateTime.now(),
                                                      firstDate: DateTime(1950),
                                                      lastDate: DateTime(2050));

                                                  if (pickedDate != null) {
                                                    dateOfLastPremiumInputController.text =
                                                        pickedDate.toString();
                                                  }
                                                },
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 100,
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    //Agency Details
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(15),
                                              child: Text(
                                                'Agency Details',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold, fontSize: 17),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: TextFormField(
                                                decoration: InputDecoration(
                                                  labelText: "Agency",
                                                  labelStyle: const TextStyle(color: Colors.grey),
                                                  border: myinputborder(),
                                                  enabledBorder: myinputborder(),
                                                  focusedBorder: myfocusborder(),
                                                ),
                                                validator: RequiredValidator(
                                                  errorText: "Required *",
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10.0),
                                                    child: TextFormField(
                                                      decoration: InputDecoration(
                                                        labelText: "Policy Number",
                                                        labelStyle:
                                                            const TextStyle(color: Colors.grey),
                                                        border: myinputborder(),
                                                        enabledBorder: myinputborder(),
                                                        focusedBorder: myfocusborder(),
                                                      ),
                                                      validator: RequiredValidator(
                                                        errorText: "Required *",
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20.0,
                                                ),
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10.0),
                                                    child: IntlPhoneField(
                                                      keyboardType: TextInputType.phone,
                                                      textInputAction: TextInputAction.next,
                                                      cursorColor: kPrimaryColor,
                                                      onSaved: (phone) {},
                                                      decoration: InputDecoration(
                                                        labelText: 'Phone Number',
                                                        labelStyle: const TextStyle(
                                                            // color:  phoneNode.hasFocus ? kPrimaryColor : Colors.grey
                                                            ),
                                                        prefixIcon: const Padding(
                                                          padding: EdgeInsets.all(defaultPadding),
                                                          child: Icon(Icons.phone,
                                                              color: kPrimaryColor),
                                                        ),
                                                        border: myinputborder(),
                                                        enabledBorder: myinputborder(),
                                                        focusedBorder: myfocusborder(),
                                                      ),
                                                      initialCountryCode: 'KE',
                                                      onChanged: (phone) {
                                                        // print(phoneController);
                                                      },
                                                      validator: (value) {
                                                        //allow upper and lower case alphabets and space
                                                        return "Enter your phone number should not start with a 0";
                                                      },
                                                    ),
                                                    // TextFormField(
                                                    //     decoration:  InputDecoration(
                                                    //       labelText: "Telephone",
                                                    //       labelStyle: TextStyle(color: Colors.grey),
                                                    //   border: myinputborder(),
                                                    //   enabledBorder: myinputborder(),
                                                    //   focusedBorder: myfocusborder(),
                                                    //     ),
                                                    //     validator: RequiredValidator(
                                                    //       errorText: "Required *",
                                                    //     ),
                                                    //   ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: TextFormField(
                                                decoration: InputDecoration(
                                                  labelText: "Email",
                                                  labelStyle: const TextStyle(color: Colors.grey),
                                                  border: myinputborder(),
                                                  enabledBorder: myinputborder(),
                                                  focusedBorder: myfocusborder(),
                                                ),
                                                validator: RequiredValidator(
                                                  errorText: "Required *",
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 100,
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    //Accident Details
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(15),
                                              child: Text(
                                                'Accident Details',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold, fontSize: 17),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10.0),
                                                    child: TextFormField(
                                                      decoration: InputDecoration(
                                                        labelText: 'Date of Accident',
                                                        border: myinputborder(),
                                                        enabledBorder: myinputborder(),
                                                        focusedBorder: myfocusborder(),
                                                      ),
                                                      controller:
                                                          dateOfAccidentPremiumInputController,
                                                      readOnly: true,
                                                      onTap: () async {
                                                        DateTime? pickedDate = await showDatePicker(
                                                            context: context,
                                                            initialDate: DateTime.now(),
                                                            firstDate: DateTime(1950),
                                                            lastDate: DateTime(2050));

                                                        if (pickedDate != null) {
                                                          dateOfAccidentPremiumInputController
                                                              .text = pickedDate.toString();
                                                        }
                                                      },
                                                    ),
                                                    // TextFormField(
                                                    //     decoration:  InputDecoration(
                                                    //       labelText: "Date of Accident",
                                                    //       labelStyle: TextStyle(color: Colors.grey),
                                                    // border: myinputborder(),
                                                    // enabledBorder: myinputborder(),
                                                    // focusedBorder: myfocusborder(),
                                                    //     ),
                                                    //     validator: RequiredValidator(
                                                    //       errorText: "Required *",
                                                    //     ),
                                                    //   ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20.0,
                                                ),
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10.0),
                                                    child: TextFormField(
                                                      decoration: InputDecoration(
                                                        labelText: "Location of Accident",
                                                        labelStyle:
                                                            const TextStyle(color: Colors.grey),
                                                        border: myinputborder(),
                                                        enabledBorder: myinputborder(),
                                                        focusedBorder: myfocusborder(),
                                                      ),
                                                      validator: RequiredValidator(
                                                        errorText: "Required *",
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Text(
                                                    'Describe the accident',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold, fontSize: 17),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10.0,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: TextField(
                                                    controller: textarea,
                                                    keyboardType: TextInputType.multiline,
                                                    maxLines: 5,
                                                    decoration: InputDecoration(
                                                      hintText: "Describe the accident",
                                                      labelStyle:
                                                          const TextStyle(color: Colors.grey),
                                                      border: myinputborder(),
                                                      enabledBorder: myinputborder(),
                                                      focusedBorder: myfocusborder(),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            //Agency Details
                                            Container(
                                              child: Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Column(
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.all(15),
                                                      child: Text(
                                                        'Witness Details',
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 17),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: TextFormField(
                                                        decoration: InputDecoration(
                                                          labelText: "Name",
                                                          labelStyle:
                                                              const TextStyle(color: Colors.grey),
                                                          border: myinputborder(),
                                                          enabledBorder: myinputborder(),
                                                          focusedBorder: myfocusborder(),
                                                        ),
                                                        validator: RequiredValidator(
                                                          errorText: "Required *",
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.spaceBetween,
                                                      children: <Widget>[
                                                        Flexible(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(10.0),
                                                            child: TextFormField(
                                                              decoration: InputDecoration(
                                                                labelText: "Occupation",
                                                                labelStyle: const TextStyle(
                                                                    color: Colors.grey),
                                                                border: myinputborder(),
                                                                enabledBorder: myinputborder(),
                                                                focusedBorder: myfocusborder(),
                                                              ),
                                                              validator: RequiredValidator(
                                                                errorText: "Required *",
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 20.0,
                                                        ),
                                                        Flexible(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(10.0),
                                                            child: TextFormField(
                                                              decoration: InputDecoration(
                                                                labelText: "Telephone Number",
                                                                labelStyle: const TextStyle(
                                                                    color: Colors.grey),
                                                                border: myinputborder(),
                                                                enabledBorder: myinputborder(),
                                                                focusedBorder: myfocusborder(),
                                                              ),
                                                              validator: RequiredValidator(
                                                                errorText: "Required *",
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: TextFormField(
                                                        decoration: InputDecoration(
                                                          labelText: "Address",
                                                          labelStyle:
                                                              const TextStyle(color: Colors.grey),
                                                          border: myinputborder(),
                                                          enabledBorder: myinputborder(),
                                                          focusedBorder: myfocusborder(),
                                                        ),
                                                        validator: RequiredValidator(
                                                          errorText: "Required *",
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 100,
                                                      height: 20,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                      height: defaultPadding / 2,
                                    ),
                                    SizedBox(
                                      height: 40.0,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: kPrimaryColor,
                                            fixedSize: const Size(200, 40)),
                                        onPressed: () {

                                        },
                                        child: const Text(
                                          "SUBMIT",
                                          style: TextStyle(
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: defaultPadding / 2,
                                    ),
                                    SizedBox(
                                      height: 40.0,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: kPrimaryColor,
                                            fixedSize: const Size(200, 40)),
                                        onPressed: () async {
                                          await generatePDF(
                                            nameInsuredController.text,
                                            nameClaimantController.text,
                                            postalAddressController.text,
                                            postalCodeController.text,
                                            emailController.text,
                                            occupationController.text,
                                            dateOfBirthInputController.text,
                                            dateOfLastPremiumInputController.text,
                                            agencyController.text,
                                            policyNoController.text,
                                            agencyPhoneNoController.text,
                                            agencyEmailController.text,
                                            textarea.text,
                                            dateOfAccidentPremiumInputController.text,
                                            locationOfAccidentController.text,
                                            witnessOccupationController.text,
                                            witnessTelephoneController.text,
                                            witnessNameController.text,
                                            witnessAddressController.text,
                                            claimantFullNameController.text,
                                            claimantOccupationController.text,
                                          );
                                        },
                                        child: const Text(
                                          "DOWNLOAD",
                                          style: TextStyle(
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: defaultPadding / 2,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ),
                    Container(
                      child: SingleChildScrollView(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              child: Column(
                                children: [
                                  //Attach medical report
                                  Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          'Attach medical report',
                                          textAlign: TextAlign.start,
                                          style:
                                              TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            
                                            DottedBorder(
                                              color: Colors.black,
                                              strokeWidth: 1,
                                              radius: const Radius.circular(30),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    if(resultMedicalReport != null) ... [
                                                      ElevatedButton(
                                                      child: Center(
                                                        child: Column(
                                                          children: [
                                                            ListView.separated(
                                                              shrinkWrap: true,
                                                              itemCount: resultMedicalReport?.files.length ?? 0,
                                                              itemBuilder: (context, index) {
                                                                return ListTile(
                                                                  // onTap: () => OpenAppFile.open(result?.files[index].path.toString()),

                                                                  title: Column(
                                                                    children: [
                                                                      SizedBox(height: 10,),
                                                                      Icon(Icons.file_open,size: 50,),
                                                                      SizedBox(width: 10,),
                                                                      Text(resultMedicalReport?.files[index].name ?? '',
                                                                        style: const TextStyle(
                                                                            fontSize: 16, fontWeight: FontWeight.bold,)),
                                                                      SizedBox(height: 10,),
                                                                    ],
                                                                  ),
                                                                );

                                                              }, separatorBuilder: (BuildContext context, int index) {
                                                                return const SizedBox(height: 5,);
                                                              },
                                                          )

                                                          ],
                                                        ),
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                      backgroundColor: kPrimaryLightColor,
                                                      foregroundColor: Colors.black,
                                                      elevation: 0,
                                                      ),
                                                      // OpenAppFile.open(file[index].path.toString()),
                                                      onPressed: () async {
                                                            resultMedicalReport =
                                                                await FilePicker.platform.pickFiles(allowMultiple: true);
                                                            if (resultMedicalReport == null) {
                                                              print("No file selected");
                                                            } else {
                                                              setState(() {});
                                                              for (var element in resultMedicalReport!.files) {
                                                                print(element.name);
                                                              }
                                                            }
                                                          },
                                                      )

                                                    ]else ...[
                                                      ElevatedButton(
                                                      child: Center(
                                                        child: Column(
                                                          children: [
                                                            Icon(Icons.file_upload_sharp, size: 40),
                                                            SizedBox(height: 10,),
                                                            Text('Attach medical report'),
                                                            SizedBox(height: 10,),

                                                          ],
                                                        ),
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                      backgroundColor: kPrimaryLightColor,
                                                      foregroundColor: Colors.black,
                                                      elevation: 0,
                                                      ),
                                                      onPressed: () async {
                                                            resultMedicalReport =
                                                                await FilePicker.platform.pickFiles(allowMultiple: true);
                                                            if (resultMedicalReport == null) {
                                                              print("No file selected");
                                                            } else {
                                                              setState(() {});
                                                              for (var element in resultMedicalReport!.files) {
                                                                print(element.name);
                                                              }
                                                            }
                                                          },
                                                      )

                                                    ],
                                                    
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            if(resultMedicalReport != null) ... [

                                              SizedBox(
                                              height: 40.0,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: kPrimaryColor,
                                                    fixedSize: const Size(200, 40)),
                                                onPressed: () {
                                                  
                                                },
                                                child: const Text(
                                                  "Submit Medical Report",
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: defaultPadding / 2,
                                            ),

                                            ]else ...[
                                              SizedBox(
                                              height: 40.0,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: kPrimaryColor,
                                                    fixedSize: const Size(200, 40)),
                                                onPressed: null,
                                                child: const Text(
                                                  "Submit Medical Report",
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: defaultPadding / 2,
                                            ),

                                            ],
                                            // SizedBox(
                                            //   height: 40.0,
                                            //   child: ElevatedButton(
                                            //     style: ElevatedButton.styleFrom(
                                            //         backgroundColor: kPrimaryColor,
                                            //         fixedSize: const Size(200, 40)),
                                            //     onPressed: () {
                                                  
                                            //     },
                                            //     child: const Text(
                                            //       "Submit Medical Report",
                                            //       style: TextStyle(
                                            //         fontSize: 12.0,
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                            // const SizedBox(
                                            //   height: defaultPadding / 2,
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  //Attach sick sheet
                                  Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          'Attach sick sheet',
                                          textAlign: TextAlign.start,
                                          style:
                                              TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            DottedBorder(
                                              color: Colors.black,
                                              strokeWidth: 1,
                                              radius: const Radius.circular(30),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    if(resultSickSheet != null) ... [
                                                      ElevatedButton(
                                                      child: Center(
                                                        child: Column(
                                                          children: [
                                                            ListView.separated(
                                                              shrinkWrap: true,
                                                              itemCount: resultSickSheet?.files.length ?? 0,
                                                              itemBuilder: (context, index) {
                                                                return ListTile(
                                                                  // onTap: () => OpenAppFile.open(result?.files[index].path.toString()),

                                                                  title: Column(
                                                                    children: [
                                                                      SizedBox(height: 10,),
                                                                      Icon(Icons.file_open,size: 50,),
                                                                      SizedBox(width: 10,),
                                                                      Text(resultSickSheet?.files[index].name ?? '',
                                                                        style: const TextStyle(
                                                                            fontSize: 16, fontWeight: FontWeight.bold,)),
                                                                      SizedBox(height: 10,),
                                                                    ],
                                                                  ),
                                                                );

                                                              }, separatorBuilder: (BuildContext context, int index) {
                                                                return const SizedBox(height: 5,);
                                                              },
                                                          )

                                                          ],
                                                        ),
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                      backgroundColor: kPrimaryLightColor,
                                                      foregroundColor: Colors.black,
                                                      elevation: 0,
                                                      ),
                                                      // OpenAppFile.open(file[index].path.toString()),
                                                      onPressed: () async {
                                                            resultSickSheet =
                                                                await FilePicker.platform.pickFiles(allowMultiple: true);
                                                            if (resultSickSheet == null) {
                                                              print("No file selected");
                                                            } else {
                                                              setState(() {});
                                                              for (var element in resultSickSheet!.files) {
                                                                print(element.name);
                                                              }
                                                            }
                                                          },
                                                      )

                                                    ]else ...[
                                                      ElevatedButton(
                                                      child: Center(
                                                        child: Column(
                                                          children: [
                                                            Icon(Icons.file_upload_sharp, size: 40),
                                                            SizedBox(height: 10,),
                                                            Text('Attach sick sheet'),
                                                            SizedBox(height: 10,),

                                                          ],
                                                        ),
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                      backgroundColor: kPrimaryLightColor,
                                                      foregroundColor: Colors.black,
                                                      elevation: 0,
                                                      ),
                                                      onPressed: () async {
                                                            resultSickSheet =
                                                                await FilePicker.platform.pickFiles(allowMultiple: true);
                                                            if (resultSickSheet == null) {
                                                              print("No file selected");
                                                            } else {
                                                              setState(() {});
                                                              for (var element in resultSickSheet!.files) {
                                                                print(element.name);
                                                              }
                                                            }
                                                          },
                                                      )

                                                    ],
                                                    
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              height: 40.0,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: kPrimaryColor,
                                                    fixedSize: const Size(200, 40)),
                                                onPressed: () {
                                                  
                                                },
                                                child: const Text(
                                                  "Submit sick sheet",
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: defaultPadding / 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  //Attach Police Abstruct
                                  Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          'Attach police abstruct',
                                          textAlign: TextAlign.start,
                                          style:
                                              TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            DottedBorder(
                                              color: Colors.black,
                                              strokeWidth: 1,
                                              radius: const Radius.circular(30),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    if(resultPoliceAbstruct != null) ... [
                                                      ElevatedButton(
                                                      child: Center(
                                                        child: Column(
                                                          children: [
                                                            ListView.separated(
                                                              shrinkWrap: true,
                                                              itemCount: resultPoliceAbstruct?.files.length ?? 0,
                                                              itemBuilder: (context, index) {
                                                                return ListTile(
                                                                  // onTap: () => OpenAppFile.open(result?.files[index].path.toString()),

                                                                  title: Column(
                                                                    children: [
                                                                      SizedBox(height: 10,),
                                                                      Icon(Icons.file_open,size: 50,),
                                                                      SizedBox(width: 10,),
                                                                      Text(resultPoliceAbstruct?.files[index].name ?? '',
                                                                        style: const TextStyle(
                                                                            fontSize: 16, fontWeight: FontWeight.bold,)),
                                                                      SizedBox(height: 10,),
                                                                    ],
                                                                  ),
                                                                );

                                                              }, separatorBuilder: (BuildContext context, int index) {
                                                                return const SizedBox(height: 5,);
                                                              },
                                                          )

                                                          ],
                                                        ),
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                      backgroundColor: kPrimaryLightColor,
                                                      foregroundColor: Colors.black,
                                                      elevation: 0,
                                                      ),
                                                      // OpenAppFile.open(file[index].path.toString()),
                                                      onPressed: () async {
                                                            resultPoliceAbstruct =
                                                                await FilePicker.platform.pickFiles(allowMultiple: true);
                                                            if (resultPoliceAbstruct == null) {
                                                              print("No file selected");
                                                            } else {
                                                              setState(() {});
                                                              for (var element in resultPoliceAbstruct!.files) {
                                                                print(element.name);
                                                              }
                                                            }
                                                          },
                                                      )

                                                    ]else ...[
                                                      ElevatedButton(
                                                      child: Center(
                                                        child: Column(
                                                          children: [
                                                            Icon(Icons.file_upload_sharp, size: 40),
                                                            SizedBox(height: 10,),
                                                            Text('Attach police abstruct'),
                                                            SizedBox(height: 10,),

                                                          ],
                                                        ),
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                      backgroundColor: kPrimaryLightColor,
                                                      foregroundColor: Colors.black,
                                                      elevation: 0,
                                                      ),
                                                      onPressed: () async {
                                                            resultPoliceAbstruct =
                                                                await FilePicker.platform.pickFiles(allowMultiple: true);
                                                            if (resultPoliceAbstruct == null) {
                                                              print("No file selected");
                                                            } else {
                                                              setState(() {});
                                                              for (var element in resultPoliceAbstruct!.files) {
                                                                print(element.name);
                                                              }
                                                            }
                                                          },
                                                      )

                                                    ],
                                                    
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                                height: 40.0,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor: kPrimaryColor,
                                                      fixedSize: const Size(200, 40)),
                                                  onPressed: () {
                                                    
                                                  },
                                                  child: const Text(
                                                    "Submit Police Abstract",
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: defaultPadding / 2,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  //Attach Police Abstruct
                                  Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          'Pictures of the accident',
                                          textAlign: TextAlign.start,
                                          style:
                                              TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            DottedBorder(
                                              color: Colors.black,
                                              strokeWidth: 1,
                                              radius: const Radius.circular(30),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    
                                                    ElevatedButton(
                                                      child: Center(
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              width: 800.0,
                                                              height: 400.0,
                                                              child: selectedImages.isEmpty
                                                                  ? const Center(
                                                                      child: Padding(
                                                                      padding: EdgeInsets.all(8.0),
                                                                      child: Text(
                                                                          'Sorry nothing selected!!'),
                                                                    ))
                                                                  : GridView.builder(
                                                                      itemCount: selectedImages.length,
                                                                      gridDelegate:
                                                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                                                              crossAxisCount: 3),
                                                                      itemBuilder: (BuildContext context,int index) {

                                                                        return Container(
                                                                          padding: const EdgeInsets.all(10),
                                                                          child: Stack(
                                                                            children: <Widget>[
                                                                              SizedBox(
                                                                                height: 100,
                                                                                width: 100,
                                                                                child: Image.file(File(selectedImages[index].path),fit: BoxFit.cover,),
                                                                              ),
                                                                              Positioned(
                                                                                  right: 1,
                                                                                  child: GestureDetector(
                                                                                    onTap: () {
                                                                                      setState(() {
                                                                                        dltImages(selectedImages[index]);
                                                                                      });
                                                                                    },
                                                                                    child: const Icon(Icons.cancel, color: Colors.red),
                                                                                  )
                                                                                )
                                                                            ],
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                            ),
                                                            Icon(Icons.file_upload_sharp, size: 40),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text('Pictures of the accident'),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: kPrimaryLightColor,
                                                        foregroundColor: Colors.black,
                                                        elevation: 0,
                                                      ),
                                                      onPressed: () {
                                                        getImages();
                                                      },
                                                    ),
                                                    // if(resultPoliceAbstruct != null) ... [

                                                    // ]else ...[

                                                    // ],
                                                  
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              height: 40.0,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: kPrimaryColor,
                                                    fixedSize: const Size(200, 40)),
                                                onPressed: () {
                                                  
                                                },
                                                child: const Text(
                                                  "Submit pictures of the accident",
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: defaultPadding / 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  //Attach Death Certificate
                                  Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          'Death Certificate(In case Death)',
                                          textAlign: TextAlign.start,
                                          style:
                                              TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            DottedBorder(
                                              color: Colors.black,
                                              strokeWidth: 1,
                                              radius: const Radius.circular(30),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    if(resultDeathCertificate != null) ... [
                                                      ElevatedButton(
                                                      child: Center(
                                                        child: Column(
                                                          children: [
                                                            ListView.separated(
                                                              shrinkWrap: true,
                                                              itemCount: resultDeathCertificate?.files.length ?? 0,
                                                              itemBuilder: (context, index) {
                                                                return ListTile(
                                                                  // onTap: () => OpenAppFile.open(result?.files[index].path.toString()),

                                                                  title: Column(
                                                                    children: [
                                                                      SizedBox(height: 10,),
                                                                      Icon(Icons.file_open,size: 50,),
                                                                      SizedBox(width: 10,),
                                                                      Text(resultDeathCertificate?.files[index].name ?? '',
                                                                        style: const TextStyle(
                                                                            fontSize: 16, fontWeight: FontWeight.bold,)),
                                                                      SizedBox(height: 10,),
                                                                    ],
                                                                  ),
                                                                );

                                                              }, separatorBuilder: (BuildContext context, int index) {
                                                                return const SizedBox(height: 5,);
                                                              },
                                                          )

                                                          ],
                                                        ),
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                      backgroundColor: kPrimaryLightColor,
                                                      foregroundColor: Colors.black,
                                                      elevation: 0,
                                                      ),
                                                      // OpenAppFile.open(file[index].path.toString()),
                                                      onPressed: () async {
                                                            resultDeathCertificate =
                                                                await FilePicker.platform.pickFiles(allowMultiple: true);
                                                            if (resultDeathCertificate == null) {
                                                              print("No file selected");
                                                            } else {
                                                              setState(() {});
                                                              for (var element in resultDeathCertificate!.files) {
                                                                print(element.name);
                                                              }
                                                            }
                                                          },
                                                      )

                                                    ]else ...[
                                                      ElevatedButton(
                                                      child: Center(
                                                        child: Column(
                                                          children: [
                                                            Icon(Icons.file_upload_sharp, size: 40),
                                                            SizedBox(height: 10,),
                                                            Text('Attach Death Certificate(In case Death)'),
                                                            SizedBox(height: 10,),

                                                          ],
                                                        ),
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                      backgroundColor: kPrimaryLightColor,
                                                      foregroundColor: Colors.black,
                                                      elevation: 0,
                                                      ),
                                                      onPressed: () async {
                                                            resultDeathCertificate =
                                                                await FilePicker.platform.pickFiles(allowMultiple: true);
                                                            if (resultDeathCertificate == null) {
                                                              print("No file selected");
                                                            } else {
                                                              setState(() {});
                                                              for (var element in resultDeathCertificate!.files) {
                                                                print(element.name);
                                                              }
                                                            }
                                                          },
                                                      )

                                                    ],
                                                    
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              height: 40.0,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: kPrimaryColor,
                                                    fixedSize: const Size(200, 40)),
                                                onPressed: () {
                                                  
                                                },
                                                child: const Text(
                                                  "Submit Death Certificate",
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: defaultPadding / 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  //Attach ost Morterm Report
                                  Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          'Attach Post Mortem (In case Death)',
                                          textAlign: TextAlign.start,
                                          style:
                                              TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            DottedBorder(
                                              color: Colors.black,
                                              strokeWidth: 1,
                                              radius: const Radius.circular(30),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    if(resultPostMortem != null) ... [
                                                      ElevatedButton(
                                                      child: Center(
                                                        child: Column(
                                                          children: [
                                                            ListView.separated(
                                                              shrinkWrap: true,
                                                              itemCount: resultPostMortem?.files.length ?? 0,
                                                              itemBuilder: (context, index) {
                                                                return ListTile(
                                                                  // onTap: () => OpenAppFile.open(result?.files[index].path.toString()),

                                                                  title: Column(
                                                                    children: [
                                                                      SizedBox(height: 10,),
                                                                      Icon(Icons.file_open,size: 50,),
                                                                      SizedBox(width: 10,),
                                                                      Text(resultPostMortem?.files[index].name ?? '',
                                                                        style: const TextStyle(
                                                                            fontSize: 16, fontWeight: FontWeight.bold,)),
                                                                      SizedBox(height: 10,),
                                                                    ],
                                                                  ),
                                                                );

                                                              }, separatorBuilder: (BuildContext context, int index) {
                                                                return const SizedBox(height: 5,);
                                                              },
                                                          )

                                                          ],
                                                        ),
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                      backgroundColor: kPrimaryLightColor,
                                                      foregroundColor: Colors.black,
                                                      elevation: 0,
                                                      ),
                                                      // OpenAppFile.open(file[index].path.toString()),
                                                      onPressed: () async {
                                                            resultPostMortem =
                                                                await FilePicker.platform.pickFiles(allowMultiple: true);
                                                            if (resultPostMortem == null) {
                                                              print("No file selected");
                                                            } else {
                                                              setState(() {});
                                                              for (var element in resultPostMortem!.files) {
                                                                print(element.name);
                                                              }
                                                            }
                                                          },
                                                      )

                                                    ]else ...[
                                                      ElevatedButton(
                                                      child: Center(
                                                        child: Column(
                                                          children: [
                                                            Icon(Icons.file_upload_sharp, size: 40),
                                                            SizedBox(height: 10,),
                                                            Text('Attach Post Mortem (In case Death)'),
                                                            SizedBox(height: 10,),

                                                          ],
                                                        ),
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                      backgroundColor: kPrimaryLightColor,
                                                      foregroundColor: Colors.black,
                                                      elevation: 0,
                                                      ),
                                                      onPressed: () async {
                                                            resultPostMortem =
                                                                await FilePicker.platform.pickFiles(allowMultiple: true);
                                                            if (resultPostMortem == null) {
                                                              print("No file selected");
                                                            } else {
                                                              setState(() {});
                                                              for (var element in resultPostMortem!.files) {
                                                                print(element.name);
                                                              }
                                                            }
                                                          },
                                                      )

                                                    ],
                                                    
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              height: 40.0,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: kPrimaryColor,
                                                    fixedSize: const Size(200, 40)),
                                                onPressed: () {
                                                  
                                                },
                                                child: const Text(
                                                  "Submit Post Morterm",
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: defaultPadding / 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  //Attach Proof of funeral expences
                                  Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          'Proof of funeral expences(If covered under the policy)',
                                          textAlign: TextAlign.start,
                                          style:
                                              TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            DottedBorder(
                                              color: Colors.black,
                                              strokeWidth: 1,
                                              radius: const Radius.circular(30),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    if(resultProofOfFuneralExpences != null) ... [
                                                      ElevatedButton(
                                                      child: Center(
                                                        child: Column(
                                                          children: [
                                                            ListView.separated(
                                                              shrinkWrap: true,
                                                              itemCount: resultProofOfFuneralExpences?.files.length ?? 0,
                                                              itemBuilder: (context, index) {
                                                                return ListTile(
                                                                  // onTap: () => OpenAppFile.open(result?.files[index].path.toString()),

                                                                  title: Column(
                                                                    children: [
                                                                      SizedBox(height: 10,),
                                                                      Icon(Icons.file_open,size: 50,),
                                                                      SizedBox(width: 10,),
                                                                      Text(resultProofOfFuneralExpences?.files[index].name ?? '',
                                                                        style: const TextStyle(
                                                                            fontSize: 16, fontWeight: FontWeight.bold,)),
                                                                      SizedBox(height: 10,),
                                                                    ],
                                                                  ),
                                                                );

                                                              }, separatorBuilder: (BuildContext context, int index) {
                                                                return const SizedBox(height: 5,);
                                                              },
                                                          )

                                                          ],
                                                        ),
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                      backgroundColor: kPrimaryLightColor,
                                                      foregroundColor: Colors.black,
                                                      elevation: 0,
                                                      ),
                                                      // OpenAppFile.open(file[index].path.toString()),
                                                      onPressed: () async {
                                                            resultProofOfFuneralExpences =
                                                                await FilePicker.platform.pickFiles(allowMultiple: true);
                                                            if (resultProofOfFuneralExpences == null) {
                                                              print("No file selected");
                                                            } else {
                                                              setState(() {});
                                                              for (var element in resultProofOfFuneralExpences!.files) {
                                                                print(element.name);
                                                              }
                                                            }
                                                          },
                                                      )

                                                    ]else ...[
                                                      ElevatedButton(
                                                      child: Center(
                                                        child: Column(
                                                          children: [
                                                            Icon(Icons.file_upload_sharp, size: 40),
                                                            SizedBox(height: 10,),
                                                            Text('Attach Proof of funeral expences(If covered under the policy)'),
                                                            SizedBox(height: 10,),

                                                          ],
                                                        ),
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                      backgroundColor: kPrimaryLightColor,
                                                      foregroundColor: Colors.black,
                                                      elevation: 0,
                                                      ),
                                                      onPressed: () async {
                                                            resultProofOfFuneralExpences =
                                                                await FilePicker.platform.pickFiles(allowMultiple: true);
                                                            if (resultProofOfFuneralExpences == null) {
                                                              print("No file selected");
                                                            } else {
                                                              setState(() {});
                                                              for (var element in resultProofOfFuneralExpences!.files) {
                                                                print(element.name);
                                                              }
                                                            }
                                                          },
                                                      )

                                                    ],
                                                    
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              height: 40.0,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: kPrimaryColor,
                                                    fixedSize: const Size(200, 40)),
                                                onPressed: () {
                                                  
                                                },
                                                child: const Text(
                                                  "Submit Proof of Funeral Expences",
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: defaultPadding / 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                    const SizedBox(
                                      height: defaultPadding / 2,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ),
                  ]),
                ),
              )
            ],
          ),
        ));
  }
  
   void dltImages(data) {
    selectedImages.remove(data);
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