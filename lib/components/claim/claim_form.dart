import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_million_app/components/claim/generate_pdf.dart';
import 'package:one_million_app/core/model/upload_document_model.dart';
import 'package:one_million_app/core/services/models/uptodate_model.dart';
import 'package:one_million_app/core/services/providers/uptodate_providers.dart';
import 'package:path/path.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/shared/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:path_provider/path_provider.dart';

class ClaimForm extends ConsumerStatefulWidget {

  final num userId;
  final num shopId;
  ClaimForm({super.key,
    required this.userId,
    required this.shopId,
  });

  @override
  ConsumerState<ClaimForm> createState() {
    return _ClaimFormState();
  }
}

class _ClaimFormState extends ConsumerState<ClaimForm> with SingleTickerProviderStateMixin {

  GlobalKey<FormState> basicFormKey = GlobalKey<FormState>();

  // List<File> selectedImages = [];

  // List<File> selectedfiles = [];
  final picker = ImagePicker();

  File? selectedImages;
  FilePickerResult? resultClaimForm;
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
  String? _isResultClaimFormUploaded;
  String? _isResultMedicalReportUploaded;
  String? _isResultDeathCertificateUploaded;
  String? _isResultPostMortemUploaded;
  String? _isResultProofOfFuneralExpencesUploaded;
  String? _isResultSickSheetUploaded;
  String? _isResultPoliceAbstructUploaded;
  String? _isPicturesOfAccidentUploaded;

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
  String? messageResultPicturesOfAccident;

  late TabController _tabController;

  String? dropdownValue;

  num? claimFormId;

  final _selectedColor = kPrimaryColor;

  num? _statusCode;

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
            // selectedImages.add(File(xfilePick[i].path));
            selectedImages = File(xfilePick[i].path);
          }
        } else {
          // ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }

  
  Future<List<UploadFileModal>?> pickerFiles(userId, documentName, file) async {
    try {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              ApiConstants.baseUrl + ApiConstants.uploadDocumentEndpoint));

      // open a bytestream
      var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
      // get file length
      var length = await file.length();

      // multipart that takes file
      var multipartFile = http.MultipartFile('file', stream, length,
          filename: basename(file.path));

      request.fields.addAll(
          {"userId": json.encode(userId), "documentName": documentName});
      // request.fields["documentName"] = documentName;
      // request.fields["userId"] = userId.toString();

      // add file to multipart
      request.files.add(multipartFile);

      var response = await request.send();
      var responced = await http.Response.fromStream(response);

      final responseData = json.decode(responced.body);

      print('rESPONCE bODY : $responseData');

      var obj = jsonDecode(responseData);

      

      obj.forEach((key, value) {
        _statusCode = obj["result"]["code"];
      });

      File pdfFile = await generatePDF(
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


      if (response.statusCode == 5000) {
        if (_statusCode == 5000) {
          if (file == resultMedicalReport) {
            messageResultMedicalReport = responseData["result"]["message"];
          } else if (file == resultDeathCertificate) {
            messageResultDeathCertificate = responseData["result"]["message"];
          } else if (file == resultPostMortem) {
            messageResultPostMortem = responseData["result"]["message"];
          } else if (file == resultProofOfFuneralExpences) {
            messageResultProofOfFuneralExpences =
                responseData["result"]["message"];
          } else if (file == resultSickSheet) {
            messageResultSickSheet = responseData["result"]["message"];
          } else if (file == resultPoliceAbstruct) {
            messageResultPoliceAbstruct = responseData["result"]["message"];
          } else if (file == selectedImages) {
            messageResultPicturesOfAccident = responseData["result"]["message"];
          } else if (file == pdfFile) {
            messageResultClaimForm = responseData["result"]["message"];
          }

          claimFormId = responseData["result"]["data"]["claimId"];

            throw Exception('posted successfully');
          } else {
            // log('failed the code is ${_statusCode}');
          }
        } else {
          throw Exception(
              'Unexpected posted error occured! Status code ${response.statusCode}');
        }
      
      // log('The Request Payload : ${request.files}');
    } on PlatformException catch (e) {
      // log('Unsupported operation' + e.toString());
    } catch (e) {
      // log(e.toString());
    }

    // setState(() {
    //   _isButtonDisabledFID = true;
    // });
  }

  initiateClaimForm(
      userId,
      claimFormId,
      dropdownValue,
      claimForm,
      medicalReport,
      sickSheet,
      policeAbstruct,
      picturesOfAccident,
      deathCertificate,
      postMorterm,
      proofOfFuneralExpences) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.claimEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        // "userId": userId,
        "userId": userId,
        "claimType": dropdownValue,
        "claimForm": claimForm,

        "medicalReport": medicalReport,
        "sickSheet": sickSheet,
        "policeAbstruct": policeAbstruct,
        "picturesOfAccident": picturesOfAccident,

        "deathCertificate": deathCertificate,
        "postMorterm": postMorterm,
        "proofOfFuneralExpences": proofOfFuneralExpences,
      });

      final response = await http.post(url, headers: headers, body: body);

      // print('Responce Policy Details Body: ${response.body}');

      var obj = jsonDecode(response.body);

      var _statusCode;

      obj.forEach((key, value) {
        _statusCode = obj["result"]["code"];
      });

      if (response.statusCode == 5000) {
        throw Exception('Claim Form Displayed successfully');
      } else {
        throw Exception(
            'Unexpected Claim Form Displayed error occured! Status code ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      // log(e.toString());
    }
  }

  String? selectedImagesName = 'pictures of accident';
  String? resultClaimFormName = 'claim form';
  String? resultMedicalReportName = 'medical report';

  String? resultDeathCertificateName = 'death certificate';

  String? resultPostMortemName = 'post morterm';
  String? resultProofOfFuneralExpencesName = 'funeral expenses';

  String? resultSickSheetName = 'sick sheet';

  String? resultPoliceAbstructName = 'police abstruct';

  late upToDateListModel availableUpToDate;

  List<upToDateListItem> _dataUpToDate = [];
  var _isLoadingUpToDate = true;
  String? errorUpToDate;

  String? claimApplicationActive;
  num? paymentAmountUptoDate;
  String? qualifiesForCompensation;
  String? uptoDatePayment;

  @override
  void initState() {
    super.initState();

    // // Reload shops
    ref.read(upToDateListProvider.notifier).fetchUpToDate();

    // _selectedIndex = widget.selectedIndex!;
  }

  @override
  Widget build(BuildContext context) {

    availableUpToDate = ref.watch(upToDateListProvider);

    setState(() {
      _dataUpToDate = availableUpToDate.uptodate_data;
      _isLoadingUpToDate = availableUpToDate.isLoading;

      for (var i = 0; i < _dataUpToDate.length; i++) {
        claimApplicationActive = _dataUpToDate[i].claimApplicationActive;
        paymentAmountUptoDate = _dataUpToDate[i].paymentAmount;
        qualifiesForCompensation = _dataUpToDate[i].qualifiesForCompensation;
        uptoDatePayment = _dataUpToDate[i].uptoDatePayment;
      }
    });
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Container(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: IconButton(
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
        body: (claimApplicationActive !=
                    "You will be eligiable to apply for claims after 60 days of registartion") &&
                (qualifiesForCompensation ==
                    "Your payment is not upto date ,you are not eligiable for claim application")
            ? DefaultTabController(
                length: 2,
                child: Column(
                  children: <Widget>[
                    Container(
                      constraints: BoxConstraints.expand(height: 70),
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
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.all(15),
                                                    child: Text(
                                                      'Insured Details',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: TextFormField(
                                                      // focusNode: focusNode,
                                                      decoration:
                                                          InputDecoration(
                                                        filled: true,
                                                        labelText:
                                                            "Name of Insured",
                                                        // labelStyle: labelStyle,,
                                                        labelStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                        border: myinputborder(),
                                                        enabledBorder:
                                                            myinputborder(),
                                                        focusedBorder:
                                                            myfocusborder(),
                                                      ),
                                                      validator:
                                                          RequiredValidator(
                                                        errorText: "Required *",
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: TextFormField(
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            "Name of Claimant",
                                                        labelStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                        border: myinputborder(),
                                                        enabledBorder:
                                                            myinputborder(),
                                                        focusedBorder:
                                                            myfocusborder(),
                                                      ),
                                                      validator:
                                                          RequiredValidator(
                                                        errorText: "Required *",
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Flexible(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: TextFormField(
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  "Postal Address",
                                                              labelStyle:
                                                                  const TextStyle(
                                                                      color: Colors
                                                                          .grey),
                                                              border:
                                                                  myinputborder(),
                                                              enabledBorder:
                                                                  myinputborder(),
                                                              focusedBorder:
                                                                  myfocusborder(),
                                                            ),
                                                            validator:
                                                                RequiredValidator(
                                                              errorText:
                                                                  "Required *",
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 20.0,
                                                      ),
                                                      Flexible(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: TextFormField(
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  "Postal Code",
                                                              labelStyle:
                                                                  const TextStyle(
                                                                      color: Colors
                                                                          .grey),
                                                              border:
                                                                  myinputborder(),
                                                              enabledBorder:
                                                                  myinputborder(),
                                                              focusedBorder:
                                                                  myfocusborder(),
                                                            ),
                                                            validator:
                                                                RequiredValidator(
                                                              errorText:
                                                                  "Required *",
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
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: TextFormField(
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: "Email",
                                                        labelStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                        border: myinputborder(),
                                                        enabledBorder:
                                                            myinputborder(),
                                                        focusedBorder:
                                                            myfocusborder(),
                                                      ),
                                                      validator:
                                                          RequiredValidator(
                                                        errorText: "Required *",
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Flexible(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: TextFormField(
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Date of Birth',
                                                              border:
                                                                  myinputborder(),
                                                              enabledBorder:
                                                                  myinputborder(),
                                                              focusedBorder:
                                                                  myfocusborder(),
                                                            ),
                                                            controller:
                                                                dateOfBirthInputController,
                                                            readOnly: true,
                                                            onTap: () async {
                                                              DateTime? pickedDate = await showDatePicker(
                                                                  context:
                                                                      context,
                                                                  initialDate:
                                                                      DateTime
                                                                          .now(),
                                                                  firstDate:
                                                                      DateTime(
                                                                          1950),
                                                                  lastDate:
                                                                      DateTime(
                                                                          2050));

                                                              if (pickedDate !=
                                                                  null) {
                                                                dateOfBirthInputController
                                                                        .text =
                                                                    pickedDate
                                                                        .toString();
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
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: TextFormField(
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  "Occupation",
                                                              labelStyle:
                                                                  const TextStyle(
                                                                      color: Colors
                                                                          .grey),
                                                              border:
                                                                  myinputborder(),
                                                              enabledBorder:
                                                                  myinputborder(),
                                                              focusedBorder:
                                                                  myfocusborder(),
                                                            ),
                                                            validator:
                                                                RequiredValidator(
                                                              errorText:
                                                                  "Required *",
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
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: TextFormField(
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            'Date of last premium',
                                                        border: myinputborder(),
                                                        enabledBorder:
                                                            myinputborder(),
                                                        focusedBorder:
                                                            myfocusborder(),
                                                      ),
                                                      controller:
                                                          dateOfLastPremiumInputController,
                                                      readOnly: true,
                                                      onTap: () async {
                                                        DateTime? pickedDate =
                                                            await showDatePicker(
                                                                context:
                                                                    context,
                                                                initialDate:
                                                                    DateTime
                                                                        .now(),
                                                                firstDate:
                                                                    DateTime(
                                                                        1950),
                                                                lastDate:
                                                                    DateTime(
                                                                        2050));

                                                        if (pickedDate !=
                                                            null) {
                                                          dateOfLastPremiumInputController
                                                                  .text =
                                                              pickedDate
                                                                  .toString();
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
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.all(15),
                                                    child: Text(
                                                      'Agency Details',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: TextFormField(
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: "Agency",
                                                        labelStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                        border: myinputborder(),
                                                        enabledBorder:
                                                            myinputborder(),
                                                        focusedBorder:
                                                            myfocusborder(),
                                                      ),
                                                      validator:
                                                          RequiredValidator(
                                                        errorText: "Required *",
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Flexible(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: TextFormField(
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  "Policy Number",
                                                              labelStyle:
                                                                  const TextStyle(
                                                                      color: Colors
                                                                          .grey),
                                                              border:
                                                                  myinputborder(),
                                                              enabledBorder:
                                                                  myinputborder(),
                                                              focusedBorder:
                                                                  myfocusborder(),
                                                            ),
                                                            validator:
                                                                RequiredValidator(
                                                              errorText:
                                                                  "Required *",
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 20.0,
                                                      ),
                                                      Flexible(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: IntlPhoneField(
                                                            disableLengthCheck: true,
                                                            keyboardType:
                                                                TextInputType
                                                                    .phone,
                                                            textInputAction:
                                                                TextInputAction
                                                                    .next,
                                                            cursorColor:
                                                                kPrimaryColor,
                                                            onSaved: (phone) {},
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Phone Number',
                                                              labelStyle:
                                                                  const TextStyle(
                                                                      // color:  phoneNode.hasFocus ? kPrimaryColor : Colors.grey
                                                                      ),
                                                              prefixIcon:
                                                                  const Padding(
                                                                padding:
                                                                    EdgeInsets.all(
                                                                        defaultPadding),
                                                                child: Icon(
                                                                    Icons.phone,
                                                                    color:
                                                                        kPrimaryColor),
                                                              ),
                                                              border:
                                                                  myinputborder(),
                                                              enabledBorder:
                                                                  myinputborder(),
                                                              focusedBorder:
                                                                  myfocusborder(),
                                                            ),
                                                            initialCountryCode:
                                                                'KE',
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
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: TextFormField(
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: "Email",
                                                        labelStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                        border: myinputborder(),
                                                        enabledBorder:
                                                            myinputborder(),
                                                        focusedBorder:
                                                            myfocusborder(),
                                                      ),
                                                      validator:
                                                          RequiredValidator(
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
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.all(15),
                                                    child: Text(
                                                      'Accident Details',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Flexible(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: TextFormField(
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Date of Accident',
                                                              border:
                                                                  myinputborder(),
                                                              enabledBorder:
                                                                  myinputborder(),
                                                              focusedBorder:
                                                                  myfocusborder(),
                                                            ),
                                                            controller:
                                                                dateOfAccidentPremiumInputController,
                                                            readOnly: true,
                                                            onTap: () async {
                                                              DateTime? pickedDate = await showDatePicker(
                                                                  context:
                                                                      context,
                                                                  initialDate:
                                                                      DateTime
                                                                          .now(),
                                                                  firstDate:
                                                                      DateTime(
                                                                          1950),
                                                                  lastDate:
                                                                      DateTime(
                                                                          2050));

                                                              if (pickedDate !=
                                                                  null) {
                                                                dateOfAccidentPremiumInputController
                                                                        .text =
                                                                    pickedDate
                                                                        .toString();
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
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: TextFormField(
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  "Location of Accident",
                                                              labelStyle:
                                                                  const TextStyle(
                                                                      color: Colors
                                                                          .grey),
                                                              border:
                                                                  myinputborder(),
                                                              enabledBorder:
                                                                  myinputborder(),
                                                              focusedBorder:
                                                                  myfocusborder(),
                                                            ),
                                                            validator:
                                                                RequiredValidator(
                                                              errorText:
                                                                  "Required *",
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
                                                        padding: EdgeInsets.all(
                                                            10.0),
                                                        child: Text(
                                                          'Describe the accident',
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 17),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10.0,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: TextField(
                                                          controller: textarea,
                                                          keyboardType:
                                                              TextInputType
                                                                  .multiline,
                                                          maxLines: 5,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                "Describe the accident",
                                                            labelStyle:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                            border:
                                                                myinputborder(),
                                                            enabledBorder:
                                                                myinputborder(),
                                                            focusedBorder:
                                                                myfocusborder(),
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
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Column(
                                                        children: [
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    15),
                                                            child: Text(
                                                              'Witness Details',
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 17),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child:
                                                                TextFormField(
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    "Name",
                                                                labelStyle:
                                                                    const TextStyle(
                                                                        color: Colors
                                                                            .grey),
                                                                border:
                                                                    myinputborder(),
                                                                enabledBorder:
                                                                    myinputborder(),
                                                                focusedBorder:
                                                                    myfocusborder(),
                                                              ),
                                                              validator:
                                                                  RequiredValidator(
                                                                errorText:
                                                                    "Required *",
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: <Widget>[
                                                              Flexible(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          10.0),
                                                                  child:
                                                                      TextFormField(
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelText:
                                                                          "Occupation",
                                                                      labelStyle:
                                                                          const TextStyle(
                                                                              color: Colors.grey),
                                                                      border:
                                                                          myinputborder(),
                                                                      enabledBorder:
                                                                          myinputborder(),
                                                                      focusedBorder:
                                                                          myfocusborder(),
                                                                    ),
                                                                    validator:
                                                                        RequiredValidator(
                                                                      errorText:
                                                                          "Required *",
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 20.0,
                                                              ),
                                                              Flexible(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          10.0),
                                                                  child:
                                                                      TextFormField(
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelText:
                                                                          "Telephone Number",
                                                                      labelStyle:
                                                                          const TextStyle(
                                                                              color: Colors.grey),
                                                                      border:
                                                                          myinputborder(),
                                                                      enabledBorder:
                                                                          myinputborder(),
                                                                      focusedBorder:
                                                                          myfocusborder(),
                                                                    ),
                                                                    validator:
                                                                        RequiredValidator(
                                                                      errorText:
                                                                          "Required *",
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
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child:
                                                                TextFormField(
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    "Address",
                                                                labelStyle:
                                                                    const TextStyle(
                                                                        color: Colors
                                                                            .grey),
                                                                border:
                                                                    myinputborder(),
                                                                enabledBorder:
                                                                    myinputborder(),
                                                                focusedBorder:
                                                                    myfocusborder(),
                                                              ),
                                                              validator:
                                                                  RequiredValidator(
                                                                errorText:
                                                                    "Required *",
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
                                          const SizedBox(
                                            height: 10,
                                          ),

                                          const SizedBox(
                                            height: defaultPadding / 2,
                                          ),
                                          SizedBox(
                                            height: 40.0,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      kPrimaryColor,
                                                  fixedSize:
                                                      const Size(200, 40)),
                                              onPressed: () async {
                                                await generatePDF(
                                                  nameInsuredController.text,
                                                  nameClaimantController.text,
                                                  postalAddressController.text,
                                                  postalCodeController.text,
                                                  emailController.text,
                                                  occupationController.text,
                                                  dateOfBirthInputController
                                                      .text,
                                                  dateOfLastPremiumInputController
                                                      .text,
                                                  agencyController.text,
                                                  policyNoController.text,
                                                  agencyPhoneNoController.text,
                                                  agencyEmailController.text,
                                                  textarea.text,
                                                  dateOfAccidentPremiumInputController
                                                      .text,
                                                  locationOfAccidentController
                                                      .text,
                                                  witnessOccupationController
                                                      .text,
                                                  witnessTelephoneController
                                                      .text,
                                                  witnessNameController.text,
                                                  witnessAddressController.text,
                                                  claimantFullNameController
                                                      .text,
                                                  claimantOccupationController
                                                      .text,
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
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: defaultPadding),
                                        child: DropdownButtonFormField<String>(
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                            ),
                                            hint: const Text(
                                              'Please select Claim Type',
                                              style: TextStyle(fontSize: 17),
                                            ),
                                            value: dropdownValue,
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                // if(newValue == 'Medical Expenses'){
                                                //       dropdownValue = 'medicalExpenses';
                                                // }else if(newValue == 'Temporary Disability'){
                                                //       dropdownValue = 'temporaryDisability';
                                                // }else if(newValue == 'Permanant Disability'){
                                                //       dropdownValue = 'permanentDisability';
                                                // }else if(newValue == 'Death'){
                                                //       dropdownValue = 'death';
                                                // }
                                                dropdownValue = newValue!;
                                              });
                                            },
                                            validator: (value) => value == null
                                                ? 'field required'
                                                : null,
                                            items: <String>[
                                              'Medical Expenses',
                                              'Temporary Disability',
                                              'Permanant Disability',
                                              'Death'
                                            ].map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      value,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList()),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      //Attach Claim Form report
                                      Column(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Text(
                                              'Attach Claim Form',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17),
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
                                                  radius:
                                                      const Radius.circular(30),
                                                  child: Center(
                                                    child: Column(
                                                      children: [
                                                        if (resultClaimForm !=
                                                            null) ...[
                                                          ElevatedButton(
                                                            child: Center(
                                                              child: Column(
                                                                children: [
                                                                  ListView
                                                                      .separated(
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemCount: resultClaimForm
                                                                            ?.files
                                                                            .length ??
                                                                        0,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return ListTile(
                                                                        // onTap: () => OpenAppFile.open(result?.files[index].path.toString()),

                                                                        title:
                                                                            Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Icon(
                                                                              Icons.file_open,
                                                                              size: 50,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Text(resultClaimForm?.files[index].name ?? '',
                                                                                style: const TextStyle(
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight.bold,
                                                                                )),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    },
                                                                    separatorBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      return const SizedBox(
                                                                        height:
                                                                            5,
                                                                      );
                                                                    },
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  kPrimaryLightColor,
                                                              foregroundColor:
                                                                  Colors.black,
                                                              elevation: 0,
                                                            ),
                                                            // OpenAppFile.open(file[index].path.toString()),
                                                            onPressed:
                                                                () async {
                                                              resultClaimForm =
                                                                  await FilePicker
                                                                      .platform
                                                                      .pickFiles(
                                                                          allowMultiple:
                                                                              true);
                                                              if (resultClaimForm ==
                                                                  null) {
                                                                print(
                                                                    "No file selected");
                                                              } else {
                                                                setState(() {});
                                                                for (var element
                                                                    in resultClaimForm!
                                                                        .files) {
                                                                  print(element
                                                                      .name);
                                                                }
                                                              }
                                                            },
                                                          )
                                                        ] else ...[
                                                          ElevatedButton(
                                                            child: Center(
                                                              child: Column(
                                                                children: [
                                                                  Icon(
                                                                      Icons
                                                                          .file_upload_sharp,
                                                                      size: 40),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Text(
                                                                      'Attach claim form'),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  kPrimaryLightColor,
                                                              foregroundColor:
                                                                  Colors.black,
                                                              elevation: 0,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              resultClaimForm =
                                                                  await FilePicker
                                                                      .platform
                                                                      .pickFiles(
                                                                          allowMultiple:
                                                                              true);
                                                              if (resultClaimForm ==
                                                                  null) {
                                                                print(
                                                                    "No file selected");
                                                              } else {
                                                                setState(() {});
                                                                for (var element
                                                                    in resultClaimForm!
                                                                        .files) {
                                                                  print(element
                                                                      .name);
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
                                                // (resultClaimForm !=
                                                //     null)?
                                                SizedBox(
                                                    height: 40.0,
                                                    child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    kPrimaryColor,
                                                                fixedSize:
                                                                    const Size(
                                                                        200,
                                                                        40)),
                                                        onPressed: () async {
                                                          await pickerFiles(
                                                              widget.userId,
                                                              'claim form',
                                                              resultClaimForm?.files);
                                                          log('Picker endpoint Clicked : ${_statusCode}');
                                                        },
                                                        // setState(() {
                                                        //   if (messageResultClaimForm ==
                                                        //       'Request processed Successfully') {
                                                        //     _isResultClaimFormUploaded =
                                                        //         'Uploaded';
                                                        //   } else {
                                                        //     _isResultClaimFormUploaded =
                                                        //         'Not Uploaded';
                                                        //   }
                                                        // });
                                                        // },
                                                        child: const Text(
                                                          "Submit Claim Form",
                                                          style: TextStyle(
                                                            fontSize: 12.0,
                                                          ),
                                                        ))),
                                                // :

                                                // SizedBox(
                                                //   height: 40.0,
                                                //   child: ElevatedButton(
                                                //     style: ElevatedButton
                                                //         .styleFrom(
                                                //             backgroundColor:
                                                //                 kPrimaryColor,
                                                //             fixedSize:
                                                //                 const Size(
                                                //                     200, 40)),
                                                //     onPressed: null,
                                                //     child: const Text(
                                                //       "Submit Claim Form",
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
                                      //Attach medical report
                                      Column(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Text(
                                              'Attach medical report',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17),
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
                                                  radius:
                                                      const Radius.circular(30),
                                                  child: Center(
                                                    child: Column(
                                                      children: [
                                                        if (resultMedicalReport !=
                                                            null) ...[
                                                          ElevatedButton(
                                                            child: Center(
                                                              child: Column(
                                                                children: [
                                                                  ListView
                                                                      .separated(
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemCount: resultMedicalReport
                                                                            ?.files
                                                                            .length ??
                                                                        0,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return ListTile(
                                                                        // onTap: () => OpenAppFile.open(result?.files[index].path.toString()),

                                                                        title:
                                                                            Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Icon(
                                                                              Icons.file_open,
                                                                              size: 50,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Text(resultMedicalReport?.files[index].name ?? '',
                                                                                style: const TextStyle(
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight.bold,
                                                                                )),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    },
                                                                    separatorBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      return const SizedBox(
                                                                        height:
                                                                            5,
                                                                      );
                                                                    },
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  kPrimaryLightColor,
                                                              foregroundColor:
                                                                  Colors.black,
                                                              elevation: 0,
                                                            ),
                                                            // OpenAppFile.open(file[index].path.toString()),
                                                            onPressed:
                                                                () async {
                                                              resultMedicalReport =
                                                                  await FilePicker
                                                                      .platform
                                                                      .pickFiles(
                                                                          allowMultiple:
                                                                              true);
                                                              if (resultMedicalReport ==
                                                                  null) {
                                                                print(
                                                                    "No file selected");
                                                              } else {
                                                                setState(() {});
                                                                for (var element
                                                                    in resultMedicalReport!
                                                                        .files) {
                                                                  print(element
                                                                      .name);
                                                                }
                                                              }
                                                            },
                                                          )
                                                        ] else ...[
                                                          ElevatedButton(
                                                            child: Center(
                                                              child: Column(
                                                                children: [
                                                                  Icon(
                                                                      Icons
                                                                          .file_upload_sharp,
                                                                      size: 40),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Text(
                                                                      'Attach medical report'),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  kPrimaryLightColor,
                                                              foregroundColor:
                                                                  Colors.black,
                                                              elevation: 0,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              resultMedicalReport =
                                                                  await FilePicker
                                                                      .platform
                                                                      .pickFiles(
                                                                          allowMultiple:
                                                                              true);
                                                              if (resultMedicalReport ==
                                                                  null) {
                                                                print(
                                                                    "No file selected");
                                                              } else {
                                                                setState(() {});
                                                                for (var element
                                                                    in resultMedicalReport!
                                                                        .files) {
                                                                  print(element
                                                                      .name);
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
                                                if (resultMedicalReport !=
                                                    null) ...[
                                                  SizedBox(
                                                    height: 40.0,
                                                    child: (messageResultClaimForm !=
                                                            null)
                                                        ? ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                                backgroundColor:
                                                                    kPrimaryColor,
                                                                fixedSize:
                                                                    const Size(
                                                                        200,
                                                                        40)),
                                                            onPressed:
                                                                () async {
                                                              await pickerFiles(
                                                                  widget.userId,
                                                                  'medical report',
                                                                  resultMedicalReport
                                                                      ?.files);
                                                              setState(() {
                                                                setState(() {
                                                                  if (messageResultMedicalReport ==
                                                                      'Request processed Successfully') {
                                                                    _isResultMedicalReportUploaded =
                                                                        'Uploaded';
                                                                  } else {
                                                                    _isResultMedicalReportUploaded =
                                                                        'Not Uploaded';
                                                                  }
                                                                });
                                                              });
                                                            },
                                                            child: const Text(
                                                              "Submit Medical Report",
                                                              style: TextStyle(
                                                                fontSize: 12.0,
                                                              ),
                                                            ))
                                                        : ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                                backgroundColor:
                                                                    kPrimaryColor,
                                                                fixedSize:
                                                                    const Size(
                                                                        200,
                                                                        40)),
                                                            onPressed: null,
                                                            child: const Text(
                                                              "Submit Medical Report",
                                                              style: TextStyle(
                                                                fontSize: 12.0,
                                                              ),
                                                            )),
                                                  ),
                                                  const SizedBox(
                                                    height: defaultPadding / 2,
                                                  ),
                                                ] else ...[
                                                  SizedBox(
                                                    height: 40.0,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  kPrimaryColor,
                                                              fixedSize:
                                                                  const Size(
                                                                      200, 40)),
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
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17),
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
                                                  radius:
                                                      const Radius.circular(30),
                                                  child: Center(
                                                    child: Column(
                                                      children: [
                                                        if (resultSickSheet !=
                                                            null) ...[
                                                          ElevatedButton(
                                                            child: Center(
                                                              child: Column(
                                                                children: [
                                                                  ListView
                                                                      .separated(
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemCount: resultSickSheet
                                                                            ?.files
                                                                            .length ??
                                                                        0,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return ListTile(
                                                                        // onTap: () => OpenAppFile.open(result?.files[index].path.toString()),

                                                                        title:
                                                                            Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Icon(
                                                                              Icons.file_open,
                                                                              size: 50,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Text(resultSickSheet?.files[index].name ?? '',
                                                                                style: const TextStyle(
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight.bold,
                                                                                )),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    },
                                                                    separatorBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      return const SizedBox(
                                                                        height:
                                                                            5,
                                                                      );
                                                                    },
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  kPrimaryLightColor,
                                                              foregroundColor:
                                                                  Colors.black,
                                                              elevation: 0,
                                                            ),
                                                            // OpenAppFile.open(file[index].path.toString()),
                                                            onPressed:
                                                                () async {
                                                              resultSickSheet =
                                                                  await FilePicker
                                                                      .platform
                                                                      .pickFiles(
                                                                          allowMultiple:
                                                                              true);
                                                              if (resultSickSheet ==
                                                                  null) {
                                                                print(
                                                                    "No file selected");
                                                              } else {
                                                                setState(() {});
                                                                for (var element
                                                                    in resultSickSheet!
                                                                        .files) {
                                                                  print(element
                                                                      .name);
                                                                }
                                                              }
                                                            },
                                                          )
                                                        ] else ...[
                                                          ElevatedButton(
                                                            child: Center(
                                                              child: Column(
                                                                children: [
                                                                  Icon(
                                                                      Icons
                                                                          .file_upload_sharp,
                                                                      size: 40),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Text(
                                                                      'Attach sick sheet'),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  kPrimaryLightColor,
                                                              foregroundColor:
                                                                  Colors.black,
                                                              elevation: 0,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              resultSickSheet =
                                                                  await FilePicker
                                                                      .platform
                                                                      .pickFiles(
                                                                          allowMultiple:
                                                                              true);
                                                              if (resultSickSheet ==
                                                                  null) {
                                                                print(
                                                                    "No file selected");
                                                              } else {
                                                                setState(() {});
                                                                for (var element
                                                                    in resultSickSheet!
                                                                        .files) {
                                                                  print(element
                                                                      .name);
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
                                                  child:
                                                      (messageResultMedicalReport !=
                                                              null)
                                                          ? ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      kPrimaryColor,
                                                                  fixedSize:
                                                                      const Size(
                                                                          200,
                                                                          40)),
                                                              onPressed:
                                                                  () async {
                                                                await pickerFiles(
                                                                    widget
                                                                        .userId,
                                                                    'sick sheet',
                                                                    resultSickSheet
                                                                        ?.files);
                                                                setState(() {
                                                                  if (messageResultSickSheet ==
                                                                      'Request processed Successfully') {
                                                                    _isResultSickSheetUploaded =
                                                                        'Uploaded';
                                                                  } else {
                                                                    _isResultSickSheetUploaded =
                                                                        'Not Uploaded';
                                                                  }
                                                                });
                                                              },
                                                              child: const Text(
                                                                "Submit sick sheet",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                ),
                                                              ),
                                                            )
                                                          : ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      kPrimaryColor,
                                                                  fixedSize:
                                                                      const Size(
                                                                          200,
                                                                          40)),
                                                              onPressed: null,
                                                              child: const Text(
                                                                "Submit sick sheet",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
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
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17),
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
                                                  radius:
                                                      const Radius.circular(30),
                                                  child: Center(
                                                    child: Column(
                                                      children: [
                                                        if (resultPoliceAbstruct !=
                                                            null) ...[
                                                          ElevatedButton(
                                                            child: Center(
                                                              child: Column(
                                                                children: [
                                                                  ListView
                                                                      .separated(
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemCount: resultPoliceAbstruct
                                                                            ?.files
                                                                            .length ??
                                                                        0,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return ListTile(
                                                                        // onTap: () => OpenAppFile.open(result?.files[index].path.toString()),

                                                                        title:
                                                                            Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Icon(
                                                                              Icons.file_open,
                                                                              size: 50,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Text(resultPoliceAbstruct?.files[index].name ?? '',
                                                                                style: const TextStyle(
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight.bold,
                                                                                )),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    },
                                                                    separatorBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      return const SizedBox(
                                                                        height:
                                                                            5,
                                                                      );
                                                                    },
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  kPrimaryLightColor,
                                                              foregroundColor:
                                                                  Colors.black,
                                                              elevation: 0,
                                                            ),
                                                            // OpenAppFile.open(file[index].path.toString()),
                                                            onPressed:
                                                                () async {
                                                              resultPoliceAbstruct =
                                                                  await FilePicker
                                                                      .platform
                                                                      .pickFiles(
                                                                          allowMultiple:
                                                                              true);
                                                              if (resultPoliceAbstruct ==
                                                                  null) {
                                                                print(
                                                                    "No file selected");
                                                              } else {
                                                                setState(() {});
                                                                for (var element
                                                                    in resultPoliceAbstruct!
                                                                        .files) {
                                                                  print(element
                                                                      .name);
                                                                }
                                                              }
                                                            },
                                                          )
                                                        ] else ...[
                                                          ElevatedButton(
                                                            child: Center(
                                                              child: Column(
                                                                children: [
                                                                  Icon(
                                                                      Icons
                                                                          .file_upload_sharp,
                                                                      size: 40),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Text(
                                                                      'Attach police abstruct'),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  kPrimaryLightColor,
                                                              foregroundColor:
                                                                  Colors.black,
                                                              elevation: 0,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              resultPoliceAbstruct =
                                                                  await FilePicker
                                                                      .platform
                                                                      .pickFiles(
                                                                          allowMultiple:
                                                                              true);
                                                              if (resultPoliceAbstruct ==
                                                                  null) {
                                                                print(
                                                                    "No file selected");
                                                              } else {
                                                                setState(() {});
                                                                for (var element
                                                                    in resultPoliceAbstruct!
                                                                        .files) {
                                                                  print(element
                                                                      .name);
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
                                                  child:
                                                      (messageResultSickSheet !=
                                                              null)
                                                          ? ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      kPrimaryColor,
                                                                  fixedSize:
                                                                      const Size(
                                                                          200,
                                                                          40)),
                                                              onPressed:
                                                                  () async {
                                                                await pickerFiles(
                                                                    widget
                                                                        .userId,
                                                                    'police abstruct',
                                                                    resultPoliceAbstruct
                                                                        ?.files);
                                                                setState(() {
                                                                  if (messageResultPoliceAbstruct ==
                                                                      'Request processed Successfully') {
                                                                    _isResultSickSheetUploaded =
                                                                        'Uploaded';
                                                                  } else {
                                                                    _isResultSickSheetUploaded =
                                                                        'Not Uploaded';
                                                                  }
                                                                });
                                                              },
                                                              child: const Text(
                                                                "Submit Police Abstract",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                ),
                                                              ),
                                                            )
                                                          : ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      kPrimaryColor,
                                                                  fixedSize:
                                                                      const Size(
                                                                          200,
                                                                          40)),
                                                              onPressed: null,
                                                              child: const Text(
                                                                "Submit Police Abstract",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
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
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: DottedBorder(
                                              color: Colors.black,
                                              strokeWidth: 1,
                                              radius: const Radius.circular(30),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20.0),
                                                      child: selectedImages !=
                                                              null
                                                          ? Image.file(
                                                              selectedImages!,
                                                              width: 300,
                                                              height: 250,
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Image.asset(
                                                              'assets/images/upload_logo.png',
                                                              width: 300,
                                                              height: 250,
                                                              fit: BoxFit.cover,
                                                            ),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Column(
                                                      children: [
                                                        CustomButton(
                                                          title:
                                                              'Pick from Gallery',
                                                          icon: Icons
                                                              .image_outlined,
                                                          onClick: () =>
                                                              getSelectedPicturesOfAccident(
                                                                  ImageSource
                                                                      .gallery),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        CustomButton(
                                                          title:
                                                              'Pick from Camera',
                                                          icon: Icons.camera,
                                                          onClick: () =>
                                                              getSelectedPicturesOfAccident(
                                                                  ImageSource
                                                                      .camera),
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          SizedBox(
                                            height: 40.0,
                                            child:
                                                (messageResultPoliceAbstruct !=
                                                        null)
                                                    ? ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    kPrimaryColor,
                                                                fixedSize:
                                                                    const Size(
                                                                        200,
                                                                        40)),
                                                        onPressed: () async {
                                                          await pickerFiles(
                                                              widget.userId,
                                                              'pictures of accident',
                                                              selectedImages);
                                                          setState(() {
                                                            if (messageResultPicturesOfAccident ==
                                                                'Request processed Successfully') {
                                                              _isPicturesOfAccidentUploaded =
                                                                  'Uploaded';
                                                            } else {
                                                              _isPicturesOfAccidentUploaded =
                                                                  'Not Uploaded';
                                                            }
                                                          });
                                                        },
                                                        child: const Text(
                                                          "Submit pictures of the accident",
                                                          style: TextStyle(
                                                            fontSize: 12.0,
                                                          ),
                                                        ),
                                                      )
                                                    : ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    kPrimaryColor,
                                                                fixedSize:
                                                                    const Size(
                                                                        200,
                                                                        40)),
                                                        onPressed: null,
                                                        child: const Text(
                                                          "Submit pictures of the accident",
                                                          style: TextStyle(
                                                            fontSize: 12.0,
                                                          ),
                                                        ),
                                                      ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(
                                        height: 10,
                                      ),
                                      //Attach Death Certificate
                                      Column(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Text(
                                              'Death Certificate(In case Death)',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17),
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
                                                  radius:
                                                      const Radius.circular(30),
                                                  child: Center(
                                                    child: Column(
                                                      children: [
                                                        if (resultDeathCertificate !=
                                                            null) ...[
                                                          ElevatedButton(
                                                            child: Center(
                                                              child: Column(
                                                                children: [
                                                                  ListView
                                                                      .separated(
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemCount: resultDeathCertificate
                                                                            ?.files
                                                                            .length ??
                                                                        0,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return ListTile(
                                                                        // onTap: () => OpenAppFile.open(result?.files[index].path.toString()),

                                                                        title:
                                                                            Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Icon(
                                                                              Icons.file_open,
                                                                              size: 50,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Text(resultDeathCertificate?.files[index].name ?? '',
                                                                                style: const TextStyle(
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight.bold,
                                                                                )),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    },
                                                                    separatorBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      return const SizedBox(
                                                                        height:
                                                                            5,
                                                                      );
                                                                    },
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  kPrimaryLightColor,
                                                              foregroundColor:
                                                                  Colors.black,
                                                              elevation: 0,
                                                            ),
                                                            // OpenAppFile.open(file[index].path.toString()),
                                                            onPressed:
                                                                () async {
                                                              resultDeathCertificate =
                                                                  await FilePicker
                                                                      .platform
                                                                      .pickFiles(
                                                                          allowMultiple:
                                                                              true);
                                                              if (resultDeathCertificate ==
                                                                  null) {
                                                                print(
                                                                    "No file selected");
                                                              } else {
                                                                setState(() {});
                                                                for (var element
                                                                    in resultDeathCertificate!
                                                                        .files) {
                                                                  print(element
                                                                      .name);
                                                                }
                                                              }
                                                            },
                                                          )
                                                        ] else ...[
                                                          ElevatedButton(
                                                            child: Center(
                                                              child: Column(
                                                                children: [
                                                                  Icon(
                                                                      Icons
                                                                          .file_upload_sharp,
                                                                      size: 40),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Text(
                                                                      'Attach Death Certificate(In case Death)'),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  kPrimaryLightColor,
                                                              foregroundColor:
                                                                  Colors.black,
                                                              elevation: 0,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              resultDeathCertificate =
                                                                  await FilePicker
                                                                      .platform
                                                                      .pickFiles(
                                                                          allowMultiple:
                                                                              true);
                                                              if (resultDeathCertificate ==
                                                                  null) {
                                                                print(
                                                                    "No file selected");
                                                              } else {
                                                                setState(() {});
                                                                for (var element
                                                                    in resultDeathCertificate!
                                                                        .files) {
                                                                  print(element
                                                                      .name);
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
                                                  child:
                                                      (messageResultPicturesOfAccident !=
                                                              null)
                                                          ? ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      kPrimaryColor,
                                                                  fixedSize:
                                                                      const Size(
                                                                          200,
                                                                          40)),
                                                              onPressed:
                                                                  () async {
                                                                await pickerFiles(
                                                                    widget
                                                                        .userId,
                                                                    'death certificate',
                                                                    resultDeathCertificate
                                                                        ?.files);
                                                                setState(() {
                                                                  if (messageResultDeathCertificate ==
                                                                      'Request processed Successfully') {
                                                                    _isResultDeathCertificateUploaded =
                                                                        'Uploaded';
                                                                  } else {
                                                                    _isResultDeathCertificateUploaded =
                                                                        'Not Uploaded';
                                                                  }
                                                                });
                                                              },
                                                              child: const Text(
                                                                "Submit Death Certificate",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                ),
                                                              ),
                                                            )
                                                          : ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      kPrimaryColor,
                                                                  fixedSize:
                                                                      const Size(
                                                                          200,
                                                                          40)),
                                                              onPressed: null,
                                                              child: const Text(
                                                                "Submit Death Certificate",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
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
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17),
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
                                                  radius:
                                                      const Radius.circular(30),
                                                  child: Center(
                                                    child: Column(
                                                      children: [
                                                        if (resultPostMortem !=
                                                            null) ...[
                                                          ElevatedButton(
                                                            child: Center(
                                                              child: Column(
                                                                children: [
                                                                  ListView
                                                                      .separated(
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemCount: resultPostMortem
                                                                            ?.files
                                                                            .length ??
                                                                        0,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return ListTile(
                                                                        // onTap: () => OpenAppFile.open(result?.files[index].path.toString()),

                                                                        title:
                                                                            Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Icon(
                                                                              Icons.file_open,
                                                                              size: 50,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Text(resultPostMortem?.files[index].name ?? '',
                                                                                style: const TextStyle(
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight.bold,
                                                                                )),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    },
                                                                    separatorBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      return const SizedBox(
                                                                        height:
                                                                            5,
                                                                      );
                                                                    },
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  kPrimaryLightColor,
                                                              foregroundColor:
                                                                  Colors.black,
                                                              elevation: 0,
                                                            ),
                                                            // OpenAppFile.open(file[index].path.toString()),
                                                            onPressed:
                                                                () async {
                                                              resultPostMortem =
                                                                  await FilePicker
                                                                      .platform
                                                                      .pickFiles(
                                                                          allowMultiple:
                                                                              true);
                                                              if (resultPostMortem ==
                                                                  null) {
                                                                print(
                                                                    "No file selected");
                                                              } else {
                                                                setState(() {});
                                                                for (var element
                                                                    in resultPostMortem!
                                                                        .files) {
                                                                  print(element
                                                                      .name);
                                                                }
                                                              }
                                                            },
                                                          )
                                                        ] else ...[
                                                          ElevatedButton(
                                                            child: Center(
                                                              child: Column(
                                                                children: [
                                                                  Icon(
                                                                      Icons
                                                                          .file_upload_sharp,
                                                                      size: 40),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Text(
                                                                      'Attach Post Mortem (In case Death)'),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  kPrimaryLightColor,
                                                              foregroundColor:
                                                                  Colors.black,
                                                              elevation: 0,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              resultPostMortem =
                                                                  await FilePicker
                                                                      .platform
                                                                      .pickFiles(
                                                                          allowMultiple:
                                                                              true);
                                                              if (resultPostMortem ==
                                                                  null) {
                                                                print(
                                                                    "No file selected");
                                                              } else {
                                                                setState(() {});
                                                                for (var element
                                                                    in resultPostMortem!
                                                                        .files) {
                                                                  print(element
                                                                      .name);
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
                                                  child:
                                                      (messageResultDeathCertificate !=
                                                              null)
                                                          ? ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      kPrimaryColor,
                                                                  fixedSize:
                                                                      const Size(
                                                                          200,
                                                                          40)),
                                                              onPressed:
                                                                  () async {
                                                                await pickerFiles(
                                                                    widget
                                                                        .userId,
                                                                    'post morterm',
                                                                    resultPostMortem
                                                                        ?.files);
                                                                setState(() {
                                                                  if (messageResultPostMortem ==
                                                                      'Request processed Successfully') {
                                                                    _isResultPostMortemUploaded =
                                                                        'Uploaded';
                                                                  } else {
                                                                    _isResultPostMortemUploaded =
                                                                        'Not Uploaded';
                                                                  }
                                                                });
                                                              },
                                                              child: const Text(
                                                                "Submit Post Morterm",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                ),
                                                              ),
                                                            )
                                                          : ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      kPrimaryColor,
                                                                  fixedSize:
                                                                      const Size(
                                                                          200,
                                                                          40)),
                                                              onPressed: null,
                                                              child: const Text(
                                                                "Submit Post Morterm",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
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
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17),
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
                                                  radius:
                                                      const Radius.circular(30),
                                                  child: Center(
                                                    child: Column(
                                                      children: [
                                                        if (resultProofOfFuneralExpences !=
                                                            null) ...[
                                                          ElevatedButton(
                                                            child: Center(
                                                              child: Column(
                                                                children: [
                                                                  ListView
                                                                      .separated(
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemCount: resultProofOfFuneralExpences
                                                                            ?.files
                                                                            .length ??
                                                                        0,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return ListTile(
                                                                        // onTap: () => OpenAppFile.open(result?.files[index].path.toString()),

                                                                        title:
                                                                            Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Icon(
                                                                              Icons.file_open,
                                                                              size: 50,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Text(resultProofOfFuneralExpences?.files[index].name ?? '',
                                                                                style: const TextStyle(
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight.bold,
                                                                                )),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    },
                                                                    separatorBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      return const SizedBox(
                                                                        height:
                                                                            5,
                                                                      );
                                                                    },
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  kPrimaryLightColor,
                                                              foregroundColor:
                                                                  Colors.black,
                                                              elevation: 0,
                                                            ),
                                                            // OpenAppFile.open(file[index].path.toString()),
                                                            onPressed:
                                                                () async {
                                                              resultProofOfFuneralExpences =
                                                                  await FilePicker
                                                                      .platform
                                                                      .pickFiles(
                                                                          allowMultiple:
                                                                              true);
                                                              if (resultProofOfFuneralExpences ==
                                                                  null) {
                                                                print(
                                                                    "No file selected");
                                                              } else {
                                                                setState(() {});
                                                                for (var element
                                                                    in resultProofOfFuneralExpences!
                                                                        .files) {
                                                                  print(element
                                                                      .name);
                                                                }
                                                              }
                                                            },
                                                          )
                                                        ] else ...[
                                                          ElevatedButton(
                                                            child: Center(
                                                              child: Column(
                                                                children: [
                                                                  Icon(
                                                                      Icons
                                                                          .file_upload_sharp,
                                                                      size: 40),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Text(
                                                                      'Attach Proof of funeral expences(If covered under the policy)'),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  kPrimaryLightColor,
                                                              foregroundColor:
                                                                  Colors.black,
                                                              elevation: 0,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              resultProofOfFuneralExpences =
                                                                  await FilePicker
                                                                      .platform
                                                                      .pickFiles(
                                                                          allowMultiple:
                                                                              true);
                                                              if (resultProofOfFuneralExpences ==
                                                                  null) {
                                                                print(
                                                                    "No file selected");
                                                              } else {
                                                                setState(() {});
                                                                for (var element
                                                                    in resultProofOfFuneralExpences!
                                                                        .files) {
                                                                  print(element
                                                                      .name);
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
                                                  child:
                                                      (messageResultPostMortem !=
                                                              null)
                                                          ? ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      kPrimaryColor,
                                                                  fixedSize:
                                                                      const Size(
                                                                          200,
                                                                          40)),
                                                              onPressed:
                                                                  () async {
                                                                await pickerFiles(
                                                                    widget
                                                                        .userId,
                                                                    'funeral expenses',
                                                                    resultProofOfFuneralExpences
                                                                        ?.files);
                                                                setState(() {
                                                                  if (messageResultProofOfFuneralExpences ==
                                                                      'Request processed Successfully') {
                                                                    _isResultProofOfFuneralExpencesUploaded =
                                                                        'Uploaded';
                                                                  } else {
                                                                    _isResultProofOfFuneralExpencesUploaded =
                                                                        'Not Uploaded';
                                                                  }
                                                                });
                                                              },
                                                              child: const Text(
                                                                "Submit Proof of Funeral Expences",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                ),
                                                              ),
                                                            )
                                                          : ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      kPrimaryColor,
                                                                  fixedSize:
                                                                      const Size(
                                                                          200,
                                                                          40)),
                                                              onPressed: null,
                                                              child: const Text(
                                                                "Submit Proof of Funeral Expences",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
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
                                        height: 10,
                                      ),
                                      SizedBox(
                                          height: 40.0,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: kPrimaryColor,
                                                fixedSize: const Size(200, 40)),
                                            onPressed: () async {
                                              await initiateClaimForm(
                                                widget.userId,
                                                claimFormId,
                                                dropdownValue,
                                                _isResultClaimFormUploaded,
                                                _isResultMedicalReportUploaded,
                                                _isResultSickSheetUploaded,
                                                _isResultPoliceAbstructUploaded,
                                                _isPicturesOfAccidentUploaded,
                                                _isResultDeathCertificateUploaded,
                                                _isResultPostMortemUploaded,
                                                _isResultProofOfFuneralExpencesUploaded,
                                              );
                                            },
                                            child: const Text(
                                              "Initiate Form",
                                              style: TextStyle(
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          )),

                                      const SizedBox(
                                        height: defaultPadding / 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )),
                        ]),
                      ),
                    )
                  ],
                ),
              )
            : Container(
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 5,
                      shadowColor: Colors.black,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.info,
                                size: 100,
                                color: kPrimaryColor,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                claimApplicationActive!,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                // style: GoogleFonts.bebasNeue(fontSize: 72),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                qualifiesForCompensation!,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                                // style: GoogleFonts.bebasNeue(fontSize: 72),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ]),
              ));
  }

  // void dltImages(data) {
  //   selectedImages.remove(data);
  // }

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

  Future getSelectedPicturesOfAccident(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);

      if (image == null) return;

      // final imageTemporary = File(image.path);
      final imagePermanent = await saveFilePermanently(image.path);

      setState(() {
        this.selectedImages = imagePermanent;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<File> saveFilePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File("${directory.path}/$name");

    return File(imagePath).copy(image.path);
  }
}
