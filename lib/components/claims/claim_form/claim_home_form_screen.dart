import 'dart:io';

// import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:one_million_app/components/claims/claims_home_page_screen.dart';
import 'package:one_million_app/components/notification/notification.dart';
import 'package:one_million_app/core/model/claim_model.dart';
import 'package:one_million_app/shared/constants.dart';
// import 'package:one_million_insurance/components/claims/claims_home_page_screen.dart';
// import 'package:one_million_insurance/components/claims/generate_pdf.dart';
// import 'package:one_million_insurance/components/constants.dart';
// import 'package:one_million_insurance/components/notification/notification.dart';
// import 'package:one_million_insurance/components/onbording_screens/constent_model.dart';
// import 'package:one_million_insurance/models/claim.dart';
// import 'package:open_app_file/open_app_file.dart';
import 'package:provider/provider.dart';

class ClaimForm extends StatefulWidget {
  
 

  const ClaimForm({
    Key? key,
  }) : super(key: key);
  @override
  _ClaimFormState createState() => _ClaimFormState();
}

class _ClaimFormState extends State<ClaimForm> {
  int _currentStep = 0;
    StepperType stepperType = StepperType.horizontal;
    TextEditingController textarea = TextEditingController();

    //File upload variables
    // FilePickerResult? resultMedicalReport;
    // FilePickerResult? resultSickSheet;
    // FilePickerResult? resultPoliceAbstruct;

    // FilePickerResult? resultMedicalCertificate;
    // FilePickerResult? resultProofOfEarning;
    // FilePickerResult? resultDeathCertificate;

    // FilePickerResult? resultPostMortem;
    // FilePickerResult? resultProofOfFuneralExpences;

    
    //File upload images
    List<File> selectedImages = [];
    // final picker = ImagePicker();
    
    
    @override
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Container(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(
              iconSize: 30,
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              // the method which is called
              // when button is pressed
              onPressed: () {
                Navigator.pop(context);
                setState(
                  () {},
                );
              },
            ),
          ),
        ),
        actions: <Widget>[
          // notification icon
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              iconSize: 30,
              icon: const Icon(
                Icons.notifications,
                color: kPrimaryColor,
              ),
              // the method which is called
              // when button is pressed
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return NotificationPage();
                    },
                  ),
                );
                setState(
                  () {},
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ChangeNotifierProvider<ClaimModal>(
          create: (context) => ClaimModal(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Consumer<ClaimModal>(
              builder: (context, modal, child) {
                switch (modal.activeIndex) {
                  case 0:
                    return const BasicDetails();
                  case 1:
                    return const AccidentDetails();
                  case 2:
                    return const MedicalDetails(
                      
                    );
          
                  default:
                    return const BasicDetails();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget for Basic details
class BasicDetails extends StatefulWidget {
  const BasicDetails({Key? key}) : super(key: key);

  @override
  _BasicDetailsState createState() => _BasicDetailsState();
}

class _BasicDetailsState extends State<BasicDetails> {
  GlobalKey<FormState> basicFormKey = GlobalKey<FormState>();

  // FilePickerResult? resultMedicalCertificate;
  // FilePickerResult? resultProofOfEarning;
  // FilePickerResult? resultDeathCertificate;

  TextEditingController nameInsuredController = TextEditingController();
  TextEditingController nameClaimantController = TextEditingController();
  TextEditingController postalAddressController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  TextEditingController dateOfBirthInputController = TextEditingController();
  TextEditingController dateOfLastPremiumInputController = TextEditingController();
  TextEditingController agencyController = TextEditingController();
  TextEditingController policyNoController = TextEditingController();
  TextEditingController agencyPhoneNoController = TextEditingController();
  TextEditingController agencyEmailController = TextEditingController();

  String initialCountry = 'KE';

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
  

  @override
  Widget build(BuildContext context) {
    return Consumer<ClaimModal>(builder: (context, modal, child) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: basicFormKey,
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
                              fontWeight: FontWeight.bold,
                              fontSize: 17
                              
                            ),
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
                              decoration:  InputDecoration(
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
                              
                              decoration:  InputDecoration(
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
                                    decoration:  InputDecoration(
                                      labelText: "Postal Address",
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
                            ),
                            const SizedBox(width: 20.0,),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextFormField(
                                    decoration:InputDecoration(
                                      labelText: "Postal Code",
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
                            ),
                            
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                              decoration:  InputDecoration(
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
                                    decoration:  InputDecoration(
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
                                        dateOfBirthInputController.text = pickedDate.toString();
                                      }
                                    },
                                  ),
                                // TextFormField(
                                //     decoration: InputDecoration(
                                //       labelText: "Date of Birth",
                                //       labelStyle: TextStyle(color: Colors.grey),
                                //       border: myinputborder(),
                                //       enabledBorder: myinputborder(),
                                //       focusedBorder: myfocusborder(),
                                //     ),
                                //     validator: RequiredValidator(
                                //       errorText: "Required *",
                                //     ),
                                //   ),
                              ),
                            ),
                            const SizedBox(width: 20.0,),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextFormField(
                                    decoration:  InputDecoration(
                                      labelText: "Occupation",
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
                            ),
                            
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            decoration:  InputDecoration(
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
                                dateOfLastPremiumInputController.text =pickedDate.toString();
                              }
                            },
                          ),
                          // TextFormField(
                          //     decoration:  InputDecoration(
                          //       labelText: "Date of last premium",
                          //       labelStyle: TextStyle(color: Colors.grey),
                          //         border: myinputborder(),
                          //         enabledBorder: myinputborder(),
                          //         focusedBorder: myfocusborder(),
                          //     ),
                          //     validator: RequiredValidator(
                          //       errorText: "Required *",
                          //     ),
                          //   ),
                        ),
                        const SizedBox(
                          width: 100,
                          height: 20,
                        ),
                      ],
                    ),
                  ),
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
                              fontWeight: FontWeight.bold,
                              fontSize: 17
                              
                            ),
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
                              decoration:  InputDecoration(
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
                                    decoration:  InputDecoration(
                                      labelText: "Policy Number",
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
                            ),
                            const SizedBox(width: 20.0,),
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
                                      labelStyle: TextStyle(
                                        // color:  phoneNode.hasFocus ? kPrimaryColor : Colors.grey   
                                      ),
                                      prefixIcon: const Padding(
                                      padding: EdgeInsets.all(defaultPadding),
                                      child: Icon(Icons.phone, color: kPrimaryColor),
                                    ),
                                      border: myinputborder(),
                                      enabledBorder: myinputborder(),
                                      focusedBorder: myfocusborder(),
                                  ),
                                  initialCountryCode: 'KE',
                                  onChanged: (phone) {
                                    // print(phoneController);
                                  },
                                  validator: (value){
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
                              decoration:  InputDecoration(
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
                      if (basicFormKey.currentState?.validate() ?? false) {
                        // next
                        modal.changeStep(1);
                      }
                    },
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 20.0,
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
          ),
        ),
      );
    });
  }
  OutlineInputBorder myinputborder(){ //return type is OutlineInputBorder
    return const OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.black, width: 0),
            borderRadius: BorderRadius.all(
            Radius.circular(8),
          )
        );
  }

  OutlineInputBorder myfocusborder(){
    return const OutlineInputBorder(
        borderSide: BorderSide(
            color: kPrimaryColor, width: 0),
            borderRadius: BorderRadius.all(
            Radius.circular(8),
          )
        );
  }
}

/// Widget for Basic details
class AccidentDetails extends StatefulWidget {
  const AccidentDetails({Key? key}) : super(key: key);

  @override
  _AccidentDetailsState createState() => _AccidentDetailsState();
}

class _AccidentDetailsState extends State<AccidentDetails> {
  GlobalKey<FormState> basicFormKey = GlobalKey<FormState>();

  // FilePickerResult? resultPostMortem;
  // FilePickerResult? resultProofOfFuneralExpences;
  // FilePickerResult? resultMedicalReport;
  // FilePickerResult? resultSickSheet;
  // FilePickerResult? resultPoliceAbstruct;

  TextEditingController textarea = TextEditingController();
  TextEditingController dateOfAccidentPremiumInputController = TextEditingController();
  TextEditingController locationOfAccidentController = TextEditingController();
  TextEditingController witnessOccupationController = TextEditingController();
  TextEditingController witnessTelephoneController = TextEditingController();
  TextEditingController witnessNameController = TextEditingController();
  TextEditingController witnessAddressController = TextEditingController();

  String initialCountry = 'KE';
  

  FocusNode nameInsuredNode = FocusNode();
  FocusNode dateOfAccidentPremiumInputControllerNode = FocusNode();
  FocusNode locationOfAccidentNode = FocusNode();
  FocusNode witnessOccupationNode = FocusNode();
  FocusNode witnessTelephoneNode = FocusNode();
  FocusNode witnessNameNode = FocusNode();
  FocusNode witnessAddressNode = FocusNode();

  List<File> selectedImages = [];
  // final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Consumer<ClaimModal>(builder: (context, modal, child) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: basicFormKey,
            child: Column(
              children: [

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
                              fontWeight: FontWeight.bold,
                              fontSize: 17
                              
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
                                    decoration:  InputDecoration(
                                      labelText: 'Date of Accident',
                                      border: myinputborder(),
                                      enabledBorder: myinputborder(),
                                      focusedBorder: myfocusborder(),
                                    ),
                                    controller: dateOfAccidentPremiumInputController,
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1950),
                                          lastDate: DateTime(2050));

                                      if (pickedDate != null) {
                                        dateOfAccidentPremiumInputController.text =pickedDate.toString();
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
                            const SizedBox(width: 20.0,),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextFormField(
                                    decoration:  InputDecoration(
                                      labelText: "Location of Accident",
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
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17
                                    
                                  ),
                                ),
                              ),
                            const SizedBox(width: 10.0,),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextField(
                                  controller: textarea,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 5,
                                  decoration: InputDecoration( 
                                    hintText: "Describe the accident",
                                      labelStyle: const TextStyle(color: Colors.grey),
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
                                      fontSize: 17
                                      
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: TextFormField(
                                      decoration:  InputDecoration(
                                        labelText: "Name",
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
                                            decoration:  InputDecoration(
                                              labelText: "Occupation",
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
                                    ),
                                    const SizedBox(width: 20.0,),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: TextFormField(
                                            decoration: InputDecoration(
                                              labelText: "Telephone Number",
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
                                    ),
                                    
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: TextFormField(
                                      decoration:  InputDecoration(
                                        labelText: "Address",
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
                                    fontSize: 17
                                    
                                  ),
                                ),
                              ),
                            const SizedBox(width: 10.0,),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: DottedBorder(
                                  color: Colors.black,
                                  strokeWidth: 1,
                                  radius: const Radius.circular(30),
                                  
                                  child: const Center(
                                    child: Column(
                                      children: [
                                        // if(resultMedicalReport != null) ... [
                                        //   ElevatedButton(
                                        //   child: Center(
                                        //     child: Column(
                                        //       children: [
                                        //         ListView.separated(
                                        //           shrinkWrap: true,
                                        //           itemCount: resultMedicalReport?.files.length ?? 0,
                                        //           itemBuilder: (context, index) {
                                        //             return ListTile(
                                        //               // onTap: () => OpenAppFile.open(result?.files[index].path.toString()),
                                                      
                                        //               title: Row(
                                        //                 children: [
                                        //                   SizedBox(height: 10,),
                                        //                   Icon(Icons.file_open,size: 50,),
                                        //                   SizedBox(width: 10,),
                                        //                   Text(resultMedicalReport?.files[index].name ?? '',
                                        //                     style: const TextStyle(
                                        //                         fontSize: 16, fontWeight: FontWeight.bold,)),
                                        //                   SizedBox(height: 10,),
                                        //                 ],
                                        //               ),
                                        //             );
                                                    
                                        //           }, separatorBuilder: (BuildContext context, int index) { 
                                        //             return const SizedBox(height: 5,);
                                        //           },
                                        //       )
                                                
                                        //       ],
                                        //     ),
                                        //   ),
                                        //   style: ElevatedButton.styleFrom(
                                        //   backgroundColor: kPrimaryLightColor,
                                        //   foregroundColor: Colors.black,
                                        //   elevation: 0,
                                        //   ),
                                        //   // OpenAppFile.open(file[index].path.toString()),
                                        //   onPressed: () async {
                                        //         resultMedicalReport =
                                        //             await FilePicker.platform.pickFiles(allowMultiple: true);
                                        //         if (resultMedicalReport == null) {
                                        //           print("No file selected");
                                        //         } else {
                                        //           setState(() {});
                                        //           for (var element in resultMedicalReport!.files) {
                                        //             print(element.name);
                                        //           }
                                        //         }
                                        //       },
                                        //   )

                                        // ]else ...[
                                        //   ElevatedButton(
                                        //   child: Center(
                                        //     child: Column(
                                        //       children: [
                                        //         Icon(Icons.file_upload_sharp, size: 40),
                                        //         SizedBox(height: 10,),
                                        //         Text('Attach medical report'),
                                        //         SizedBox(height: 10,),
                                                
                                        //       ],
                                        //     ),
                                        //   ),
                                        //   style: ElevatedButton.styleFrom(
                                        //   backgroundColor: kPrimaryLightColor,
                                        //   foregroundColor: Colors.black,
                                        //   elevation: 0,
                                        //   ),
                                        //   onPressed: () async {
                                        //         resultMedicalReport =
                                        //             await FilePicker.platform.pickFiles(allowMultiple: true);
                                        //         if (resultMedicalReport == null) {
                                        //           print("No file selected");
                                        //         } else {
                                        //           setState(() {});
                                        //           for (var element in resultMedicalReport!.files) {
                                        //             print(element.name);
                                        //           }
                                        //         }
                                        //       },
                                        //   )

                                        // ],
                                      ],
                                    ),
                                  ),
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
                                    fontSize: 17
                                    
                                  ),
                                ),
                              ),
                            const SizedBox(width: 10.0,),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: DottedBorder(
                                  color: Colors.black,
                                  strokeWidth: 1,
                                  radius: const Radius.circular(30),
                                  
                                  child: const Center(
                                    child: Column(
                                      children: [
                                        // if(resultSickSheet != null) ... [
                                        //   ElevatedButton(
                                        //   child: Center(
                                        //     child: Column(
                                        //       children: [
                                        //         ListView.separated(
                                        //           shrinkWrap: true,
                                        //           itemCount: resultSickSheet?.files.length ?? 0,
                                        //           itemBuilder: (context, index) {
                                        //             return ListTile(
                                        //               // onTap: () => OpenAppFile.open(result?.files[index].path.toString()),
                                                      
                                        //               title: Row(
                                        //                 children: [
                                        //                   SizedBox(height: 10,),
                                        //                   Icon(Icons.file_open,size: 50,),
                                        //                   SizedBox(width: 10,),
                                        //                   Text(resultSickSheet?.files[index].name ?? '',
                                        //                     style: const TextStyle(
                                        //                         fontSize: 16, fontWeight: FontWeight.bold,)),
                                        //                   SizedBox(height: 10,),
                                        //                 ],
                                        //               ),
                                        //             );
                                                    
                                        //           }, separatorBuilder: (BuildContext context, int index) { 
                                        //             return const SizedBox(height: 5,);
                                        //           },
                                        //       )
                                                
                                        //       ],
                                        //     ),
                                        //   ),
                                        //   style: ElevatedButton.styleFrom(
                                        //   backgroundColor: kPrimaryLightColor,
                                        //   foregroundColor: Colors.black,
                                        //   elevation: 0,
                                        //   ),
                                        //   // OpenAppFile.open(file[index].path.toString()),
                                        //   onPressed: () async {
                                        //         resultSickSheet =
                                        //             await FilePicker.platform.pickFiles(allowMultiple: true);
                                        //         if (resultSickSheet == null) {
                                        //           print("No file selected");
                                        //         } else {
                                        //           setState(() {});
                                        //           for (var element in resultSickSheet!.files) {
                                        //             print(element.name);
                                        //           }
                                        //         }
                                        //       },
                                        //   )

                                        // ]else ...[
                                        //   ElevatedButton(
                                        //   child: Center(
                                        //     child: Column(
                                        //       children: [
                                        //         Icon(Icons.file_upload_sharp, size: 40),
                                        //         SizedBox(height: 10,),
                                        //         Text('Attach sick sheet'),
                                        //         SizedBox(height: 10,),
                                                
                                        //       ],
                                        //     ),
                                        //   ),
                                        //   style: ElevatedButton.styleFrom(
                                        //   backgroundColor: kPrimaryLightColor,
                                        //   foregroundColor: Colors.black,
                                        //   elevation: 0,
                                        //   ),
                                        //   onPressed: () async {
                                        //         resultSickSheet =
                                        //             await FilePicker.platform.pickFiles(allowMultiple: true);
                                        //         if (resultSickSheet == null) {
                                        //           print("No file selected");
                                        //         } else {
                                        //           setState(() {});
                                        //           for (var element in resultSickSheet!.files) {
                                        //             print(element.name);
                                        //           }
                                        //         }
                                        //       },
                                        //   )

                                        // ],
                                      ],
                                    ),
                                  ),
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
                                    fontSize: 17
                                    
                                  ),
                                ),
                              ),
                            const SizedBox(width: 10.0,),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: DottedBorder(
                                  color: Colors.black,
                                  strokeWidth: 1,
                                  radius: const Radius.circular(30),
                                  
                                  child: const Center(
                                    child: Column(
                                      children: [
                                        // if(resultPoliceAbstruct != null) ... [
                                        //   ElevatedButton(
                                        //   child: Center(
                                        //     child: Column(
                                        //       children: [
                                        //         ListView.separated(
                                        //           shrinkWrap: true,
                                        //           itemCount: resultPoliceAbstruct?.files.length ?? 0,
                                        //           itemBuilder: (context, index) {
                                        //             return ListTile(
                                        //               // onTap: () => OpenAppFile.open(result?.files[index].path.toString()),
                                                      
                                        //               title: Row(
                                        //                 children: [
                                        //                   SizedBox(height: 10,),
                                        //                   Icon(Icons.file_open,size: 50,),
                                        //                   SizedBox(width: 10,),
                                        //                   Text(resultPoliceAbstruct?.files[index].name ?? '',
                                        //                     style: const TextStyle(
                                        //                         fontSize: 16, fontWeight: FontWeight.bold,)),
                                        //                   SizedBox(height: 10,),
                                        //                 ],
                                        //               ),
                                        //             );
                                                    
                                        //           }, separatorBuilder: (BuildContext context, int index) { 
                                        //             return const SizedBox(height: 5,);
                                        //           },
                                        //       )
                                                
                                        //       ],
                                        //     ),
                                        //   ),
                                        //   style: ElevatedButton.styleFrom(
                                        //   backgroundColor: kPrimaryLightColor,
                                        //   foregroundColor: Colors.black,
                                        //   elevation: 0,
                                        //   ),
                                        //   // OpenAppFile.open(file[index].path.toString()),
                                        //   onPressed: () async {
                                        //         resultPoliceAbstruct =
                                        //             await FilePicker.platform.pickFiles(allowMultiple: true);
                                        //         if (resultPoliceAbstruct == null) {
                                        //           print("No file selected");
                                        //         } else {
                                        //           setState(() {});
                                        //           for (var element in resultPoliceAbstruct!.files) {
                                        //             print(element.name);
                                        //           }
                                        //         }
                                        //       },
                                        //   )

                                        // ]else ...[
                                        //   ElevatedButton(
                                        //   child: Center(
                                        //     child: Column(
                                        //       children: [
                                        //         Icon(Icons.file_upload_sharp, size: 40),
                                        //         SizedBox(height: 10,),
                                        //         Text('Attach police abstruct'),
                                        //         SizedBox(height: 10,),
                                                
                                        //       ],
                                        //     ),
                                        //   ),
                                        //   style: ElevatedButton.styleFrom(
                                        //   backgroundColor: kPrimaryLightColor,
                                        //   foregroundColor: Colors.black,
                                        //   elevation: 0,
                                        //   ),
                                        //   onPressed: () async {
                                        //         resultPoliceAbstruct =
                                        //             await FilePicker.platform.pickFiles(allowMultiple: true);
                                        //         if (resultPoliceAbstruct == null) {
                                        //           print("No file selected");
                                        //         } else {
                                        //           setState(() {});
                                        //           for (var element in resultPoliceAbstruct!.files) {
                                        //             print(element.name);
                                        //           }
                                        //         }
                                        //       },
                                        //   )

                                        // ],
                                      ],
                                    ),
                                  ),
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
                                    fontSize: 17
                                    
                                  ),
                                ),
                              ),
                            const SizedBox(width: 10.0,),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: DottedBorder(
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
                                                Container(
                                                  width: 800.0,
                                                  height: 400.0,
                                                  child: selectedImages.isEmpty
                                                  ? const Center(
                                                    child: Padding(
                                                      padding: EdgeInsets.all(8.0),
                                                      child: Text('Sorry nothing selected!!'),
                                                    ))
                                                  : GridView.builder(
                                                    itemCount: selectedImages.length,
                                                    gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 3),
                                                    itemBuilder: (BuildContext context, int index) {
                                                    return Row(
                                                      children: [
                                                        Center(
                                                          child: kIsWeb
                                                            ? Image.network(selectedImages[index].path)
                                                            : Image.file(selectedImages[index])),
                                                        
                                                      ],
                                                    );
                                                    },
                                                  ),
                                                ),
                                                Icon(Icons.file_upload_sharp, size: 40),
                                                SizedBox(height: 10,),
                                                Text('Pictures of the accident'),
                                                SizedBox(height: 10,),
                                                
                                              ],
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                          backgroundColor: kPrimaryLightColor,
                                          foregroundColor: Colors.black,
                                          elevation: 0,
                                          ),
                                          onPressed: () {
                                          // getImages();
                                        },
                                        ),
                                        // if(resultPoliceAbstruct != null) ... [
                                          

                                        // ]else ...[
                                          

                                        // ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            
                          ],
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
                      if (basicFormKey.currentState?.validate() ?? false) {
                        // next
                        modal.changeStep(2);
                      }
                    },
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 20.0,
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
          ),
        ),
      );
    });
  }
  OutlineInputBorder myinputborder(){ //return type is OutlineInputBorder
    return const OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.black, width: 0),
            borderRadius: BorderRadius.all(
            Radius.circular(8),
          )
        );
  }

  OutlineInputBorder myfocusborder(){
    return const OutlineInputBorder(
        borderSide: BorderSide(
            color: kPrimaryColor, width: 0),
            borderRadius: BorderRadius.all(
            Radius.circular(8),
          )
        );
  }

  // Future getImages() async {
  //     final pickedFile = await picker.pickMultiImage(
  //       imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
  //     List<XFile> xfilePick = pickedFile;

  //     setState(
  //     () {
  //       if (xfilePick.isNotEmpty) {
  //       for (var i = 0; i < xfilePick.length; i++) {
  //         selectedImages.add(File(xfilePick[i].path));
  //       }
  //       } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Nothing is selected')));
  //       }
  //     },
  //     );
  // }
}

/// Widget for Basic details
class MedicalDetails extends StatefulWidget {
  const MedicalDetails({Key? key}) : super(key: key);

  @override
  _MedicalDetailsState createState() => _MedicalDetailsState();
}

class _MedicalDetailsState extends State<MedicalDetails> {
  GlobalKey<FormState> basicFormKey = GlobalKey<FormState>();

  List<File> selectedImages = [];
    // final picker = ImagePicker();

    // FilePickerResult? resultMedicalReport;

    // FilePickerResult? resultMedicalCertificate;
    // FilePickerResult? resultProofOfEarning;
    // FilePickerResult? resultDeathCertificate;

    // FilePickerResult? resultPostMortem;
    // FilePickerResult? resultProofOfFuneralExpences;

    // FilePickerResult? resultSickSheet;

  
  TextEditingController claimantFullNameController = TextEditingController();
  TextEditingController claimantOccupationController = TextEditingController();

  String initialCountry = 'KE';
  
  FocusNode claimantFullNameNode = FocusNode();
  FocusNode claimantOccupationNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Consumer<ClaimModal>(builder: (context, modal, child) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: basicFormKey,
            child: Column(
              children: [

                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            'Medical Details',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17
                              
                            ),
                          ),
                        ),
                        //Claimant Full Name
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextFormField(
                                    decoration: InputDecoration(
                                      labelText: "Claimant Full Name",
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
                            ),
                            const SizedBox(width: 20.0,),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextFormField(
                                    decoration:  InputDecoration(
                                      labelText: "Occupation",
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
                                  'Medical Certificate for disbility claims',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17
                                    
                                  ),
                                ),
                              ),
                            const SizedBox(width: 10.0,),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: DottedBorder(
                                  color: Colors.black,
                                  strokeWidth: 1,
                                  radius: const Radius.circular(30),
                                  
                                  child: const Center(
                                    child: Column(
                                      children: [
                                        // if(resultMedicalReport != null) ... [
                                        //   ElevatedButton(
                                        //   child: Center(
                                        //     child: Column(
                                        //       children: [
                                        //         ListView.separated(
                                        //           shrinkWrap: true,
                                        //           itemCount: resultMedicalReport?.files.length ?? 0,
                                        //           itemBuilder: (context, index) {
                                        //             return ListTile(
                                        //               // onTap: () => OpenAppFile.open(result?.files[index].path.toString()),
                                                      
                                        //               title: Row(
                                        //                 children: [
                                        //                   SizedBox(height: 10,),
                                        //                   Icon(Icons.file_open,size: 50,),
                                        //                   SizedBox(width: 10,),
                                        //                   Text(resultMedicalReport?.files[index].name ?? '',
                                        //                     style: const TextStyle(
                                        //                         fontSize: 16, fontWeight: FontWeight.bold,)),
                                        //                   SizedBox(height: 10,),
                                        //                 ],
                                        //               ),
                                        //             );
                                                    
                                        //           }, separatorBuilder: (BuildContext context, int index) { 
                                        //             return const SizedBox(height: 5,);
                                        //           },
                                        //       )
                                                
                                        //       ],
                                        //     ),
                                        //   ),
                                        //   style: ElevatedButton.styleFrom(
                                        //   backgroundColor: kPrimaryLightColor,
                                        //   foregroundColor: Colors.black,
                                        //   elevation: 0,
                                        //   ),
                                        //   // OpenAppFile.open(file[index].path.toString()),
                                        //   onPressed: () async {
                                        //         resultMedicalReport =
                                        //             await FilePicker.platform.pickFiles(allowMultiple: true);
                                        //         if (resultMedicalReport == null) {
                                        //           print("No file selected");
                                        //         } else {
                                        //           setState(() {});
                                        //           for (var element in resultMedicalReport!.files) {
                                        //             print(element.name);
                                        //           }
                                        //         }
                                        //       },
                                        //   )

                                        // ]else ...[
                                        //   ElevatedButton(
                                        //   child: Center(
                                        //     child: Column(
                                        //       children: [
                                        //         Icon(Icons.file_upload_sharp, size: 40),
                                        //         SizedBox(height: 10,),
                                        //         Text('Attach medical certificate for disbility claims'),
                                        //         SizedBox(height: 10,),
                                                
                                        //       ],
                                        //     ),
                                        //   ),
                                        //   style: ElevatedButton.styleFrom(
                                        //   backgroundColor: kPrimaryLightColor,
                                        //   foregroundColor: Colors.black,
                                        //   elevation: 0,
                                        //   ),
                                        //   onPressed: () async {
                                        //         resultMedicalReport =
                                        //             await FilePicker.platform.pickFiles(allowMultiple: true);
                                        //         if (resultSickSheet == null) {
                                        //           print("No file selected");
                                        //         } else {
                                        //           setState(() {});
                                        //           for (var element in resultMedicalReport!.files) {
                                        //             print(element.name);
                                        //           }
                                        //         }
                                        //       },
                                        //   )

                                        // ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        //Attach Proof of Earnings
                        Column(
                          children: [
                            const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'Proof of Earnings',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17
                                    
                                  ),
                                ),
                              ),
                            const SizedBox(width: 10.0,),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: DottedBorder(
                                  color: Colors.black,
                                  strokeWidth: 1,
                                  radius: const Radius.circular(30),
                                  
                                  child: const Center(
                                    child: Column(
                                      children: [
                                        // if(resultProofOfEarning != null) ... [
                                        //   ElevatedButton(
                                        //   child: Center(
                                        //     child: Column(
                                        //       children: [
                                        //         ListView.separated(
                                        //           shrinkWrap: true,
                                        //           itemCount: resultProofOfEarning?.files.length ?? 0,
                                        //           itemBuilder: (context, index) {
                                        //             return ListTile(
                                        //               // onTap: () => OpenAppFile.open(result?.files[index].path.toString()),
                                                      
                                        //               title: Row(
                                        //                 children: [
                                        //                   SizedBox(height: 10,),
                                        //                   Icon(Icons.file_open,size: 50,),
                                        //                   SizedBox(width: 10,),
                                        //                   Text(resultProofOfEarning?.files[index].name ?? '',
                                        //                     style: const TextStyle(
                                        //                         fontSize: 16, fontWeight: FontWeight.bold,)),
                                        //                   SizedBox(height: 10,),
                                        //                 ],
                                        //               ),
                                        //             );
                                                    
                                        //           }, separatorBuilder: (BuildContext context, int index) { 
                                        //             return const SizedBox(height: 5,);
                                        //           },
                                        //       )
                                                
                                        //       ],
                                        //     ),
                                        //   ),
                                        //   style: ElevatedButton.styleFrom(
                                        //   backgroundColor: kPrimaryLightColor,
                                        //   foregroundColor: Colors.black,
                                        //   elevation: 0,
                                        //   ),
                                        //   // OpenAppFile.open(file[index].path.toString()),
                                        //   onPressed: () async {
                                        //         resultProofOfEarning =
                                        //             await FilePicker.platform.pickFiles(allowMultiple: true);
                                        //         if (resultProofOfEarning == null) {
                                        //           print("No file selected");
                                        //         } else {
                                        //           setState(() {});
                                        //           for (var element in resultProofOfEarning!.files) {
                                        //             print(element.name);
                                        //           }
                                        //         }
                                        //       },
                                        //   )

                                        // ]else ...[
                                        //   ElevatedButton(
                                        //   child: Center(
                                        //     child: Column(
                                        //       children: [
                                        //         Icon(Icons.file_upload_sharp, size: 40),
                                        //         SizedBox(height: 10,),
                                        //         Text('Attach Proof of Earnings'),
                                        //         SizedBox(height: 10,),
                                                
                                        //       ],
                                        //     ),
                                        //   ),
                                        //   style: ElevatedButton.styleFrom(
                                        //   backgroundColor: kPrimaryLightColor,
                                        //   foregroundColor: Colors.black,
                                        //   elevation: 0,
                                        //   ),
                                        //   onPressed: () async {
                                        //         resultProofOfEarning =
                                        //             await FilePicker.platform.pickFiles(allowMultiple: true);
                                        //         if (resultProofOfEarning == null) {
                                        //           print("No file selected");
                                        //         } else {
                                        //           setState(() {});
                                        //           for (var element in resultProofOfEarning!.files) {
                                        //             print(element.name);
                                        //           }
                                        //         }
                                        //       },
                                        //   )

                                        // ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            
                          ],
                        ),
                        const SizedBox(
                          width: 10,
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
                                    fontSize: 17
                                    
                                  ),
                                ),
                              ),
                            const SizedBox(width: 10.0,),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: DottedBorder(
                                  color: Colors.black,
                                  strokeWidth: 1,
                                  radius: const Radius.circular(30),
                                  
                                  child: const Center(
                                    child: Column(
                                      children: [
                                        // if(resultDeathCertificate != null) ... [
                                        //   ElevatedButton(
                                        //   child: Center(
                                        //     child: Column(
                                        //       children: [
                                        //         ListView.separated(
                                        //           shrinkWrap: true,
                                        //           itemCount: resultDeathCertificate?.files.length ?? 0,
                                        //           itemBuilder: (context, index) {
                                        //             return ListTile(
                                        //               // onTap: () => OpenAppFile.open(result?.files[index].path.toString()),
                                                      
                                        //               title: Row(
                                        //                 children: [
                                        //                   SizedBox(height: 10,),
                                        //                   Icon(Icons.file_open,size: 50,),
                                        //                   SizedBox(width: 10,),
                                        //                   Text(resultDeathCertificate?.files[index].name ?? '',
                                        //                     style: const TextStyle(
                                        //                         fontSize: 16, fontWeight: FontWeight.bold,)),
                                        //                   SizedBox(height: 10,),
                                        //                 ],
                                        //               ),
                                        //             );
                                                    
                                        //           }, separatorBuilder: (BuildContext context, int index) { 
                                        //             return const SizedBox(height: 5,);
                                        //           },
                                        //       )
                                                
                                        //       ],
                                        //     ),
                                        //   ),
                                        //   style: ElevatedButton.styleFrom(
                                        //   backgroundColor: kPrimaryLightColor,
                                        //   foregroundColor: Colors.black,
                                        //   elevation: 0,
                                        //   ),
                                        //   // OpenAppFile.open(file[index].path.toString()),
                                        //   onPressed: () async {
                                        //         resultDeathCertificate =
                                        //             await FilePicker.platform.pickFiles(allowMultiple: true);
                                        //         if (resultDeathCertificate == null) {
                                        //           print("No file selected");
                                        //         } else {
                                        //           setState(() {});
                                        //           for (var element in resultDeathCertificate!.files) {
                                        //             print(element.name);
                                        //           }
                                        //         }
                                        //       },
                                        //   )

                                        // ]else ...[
                                        //   ElevatedButton(
                                        //   child: Center(
                                        //     child: Column(
                                        //       children: [
                                        //         Icon(Icons.file_upload_sharp, size: 40),
                                        //         SizedBox(height: 10,),
                                        //         Text('Attach Death Certificate(In case Death)'),
                                        //         SizedBox(height: 10,),
                                                
                                        //       ],
                                        //     ),
                                        //   ),
                                        //   style: ElevatedButton.styleFrom(
                                        //   backgroundColor: kPrimaryLightColor,
                                        //   foregroundColor: Colors.black,
                                        //   elevation: 0,
                                        //   ),
                                        //   onPressed: () async {
                                        //         resultDeathCertificate =
                                        //             await FilePicker.platform.pickFiles(allowMultiple: true);
                                        //         if (resultDeathCertificate == null) {
                                        //           print("No file selected");
                                        //         } else {
                                        //           setState(() {});
                                        //           for (var element in resultDeathCertificate!.files) {
                                        //             print(element.name);
                                        //           }
                                        //         }
                                        //       },
                                        //   )

                                        // ],
                                      ],
                                    ),
                                  ),
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
                                    fontSize: 17
                                    
                                  ),
                                ),
                              ),
                            const SizedBox(width: 10.0,),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: DottedBorder(
                                  color: Colors.black,
                                  strokeWidth: 1,
                                  radius: const Radius.circular(30),
                                  
                                  child: const Center(
                                    child: Column(
                                      children: [
                                        // if(resultPostMortem != null) ... [
                                        //   ElevatedButton(
                                        //   child: Center(
                                        //     child: Column(
                                        //       children: [
                                        //         ListView.separated(
                                        //           shrinkWrap: true,
                                        //           itemCount: resultPostMortem?.files.length ?? 0,
                                        //           itemBuilder: (context, index) {
                                        //             return ListTile(
                                        //               // onTap: () => OpenAppFile.open(result?.files[index].path.toString()),
                                                      
                                        //               title: Row(
                                        //                 children: [
                                        //                   SizedBox(height: 10,),
                                        //                   Icon(Icons.file_open,size: 50,),
                                        //                   SizedBox(width: 10,),
                                        //                   Text(resultPostMortem?.files[index].name ?? '',
                                        //                     style: const TextStyle(
                                        //                         fontSize: 16, fontWeight: FontWeight.bold,)),
                                        //                   SizedBox(height: 10,),
                                        //                 ],
                                        //               ),
                                        //             );
                                                    
                                        //           }, separatorBuilder: (BuildContext context, int index) { 
                                        //             return const SizedBox(height: 5,);
                                        //           },
                                        //       )
                                                
                                        //       ],
                                        //     ),
                                        //   ),
                                        //   style: ElevatedButton.styleFrom(
                                        //   backgroundColor: kPrimaryLightColor,
                                        //   foregroundColor: Colors.black,
                                        //   elevation: 0,
                                        //   ),
                                        //   // OpenAppFile.open(file[index].path.toString()),
                                        //   onPressed: () async {
                                        //         resultPostMortem =
                                        //             await FilePicker.platform.pickFiles(allowMultiple: true);
                                        //         if (resultPostMortem == null) {
                                        //           print("No file selected");
                                        //         } else {
                                        //           setState(() {});
                                        //           for (var element in resultPostMortem!.files) {
                                        //             print(element.name);
                                        //           }
                                        //         }
                                        //       },
                                        //   )

                                        // ]else ...[
                                        //   ElevatedButton(
                                        //   child: Center(
                                        //     child: Column(
                                        //       children: [
                                        //         Icon(Icons.file_upload_sharp, size: 40),
                                        //         SizedBox(height: 10,),
                                        //         Text('Attach Post Mortem (In case Death)'),
                                        //         SizedBox(height: 10,),
                                                
                                        //       ],
                                        //     ),
                                        //   ),
                                        //   style: ElevatedButton.styleFrom(
                                        //   backgroundColor: kPrimaryLightColor,
                                        //   foregroundColor: Colors.black,
                                        //   elevation: 0,
                                        //   ),
                                        //   onPressed: () async {
                                        //         resultPostMortem =
                                        //             await FilePicker.platform.pickFiles(allowMultiple: true);
                                        //         if (resultPostMortem == null) {
                                        //           print("No file selected");
                                        //         } else {
                                        //           setState(() {});
                                        //           for (var element in resultPostMortem!.files) {
                                        //             print(element.name);
                                        //           }
                                        //         }
                                        //       },
                                        //   )

                                        // ],
                                      ],
                                    ),
                                  ),
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
                                    fontSize: 17
                                    
                                  ),
                                ),
                              ),
                            const SizedBox(width: 10.0,),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: DottedBorder(
                                  color: Colors.black,
                                  strokeWidth: 1,
                                  radius: const Radius.circular(30),
                                  
                                  child: const Center(
                                    child: Column(
                                      children: [
                                        // if(resultProofOfFuneralExpences != null) ... [
                                        //   ElevatedButton(
                                        //   child: Center(
                                        //     child: Column(
                                        //       children: [
                                        //         ListView.separated(
                                        //           shrinkWrap: true,
                                        //           itemCount: resultProofOfFuneralExpences?.files.length ?? 0,
                                        //           itemBuilder: (context, index) {
                                        //             return ListTile(
                                        //               // onTap: () => OpenAppFile.open(result?.files[index].path.toString()),
                                                      
                                        //               title: Row(
                                        //                 children: [
                                        //                   SizedBox(height: 10,),
                                        //                   Icon(Icons.file_open,size: 50,),
                                        //                   SizedBox(width: 10,),
                                        //                   Text(resultProofOfFuneralExpences?.files[index].name ?? '',
                                        //                     style: const TextStyle(
                                        //                         fontSize: 16, fontWeight: FontWeight.bold,)),
                                        //                   SizedBox(height: 10,),
                                        //                 ],
                                        //               ),
                                        //             );
                                                    
                                        //           }, separatorBuilder: (BuildContext context, int index) { 
                                        //             return const SizedBox(height: 5,);
                                        //           },
                                        //       )
                                                
                                        //       ],
                                        //     ),
                                        //   ),
                                        //   style: ElevatedButton.styleFrom(
                                        //   backgroundColor: kPrimaryLightColor,
                                        //   foregroundColor: Colors.black,
                                        //   elevation: 0,
                                        //   ),
                                        //   // OpenAppFile.open(file[index].path.toString()),
                                        //   onPressed: () async {
                                        //         resultProofOfFuneralExpences =
                                        //             await FilePicker.platform.pickFiles(allowMultiple: true);
                                        //         if (resultProofOfFuneralExpences == null) {
                                        //           print("No file selected");
                                        //         } else {
                                        //           setState(() {});
                                        //           for (var element in resultProofOfFuneralExpences!.files) {
                                        //             print(element.name);
                                        //           }
                                        //         }
                                        //       },
                                        //   )

                                        // ]else ...[
                                        //   ElevatedButton(
                                        //   child: Center(
                                        //     child: Column(
                                        //       children: [
                                        //         Icon(Icons.file_upload_sharp, size: 40),
                                        //         SizedBox(height: 10,),
                                        //         Text('Attach Proof of funeral expences(If covered under the policy)'),
                                        //         SizedBox(height: 10,),
                                                
                                        //       ],
                                        //     ),
                                        //   ),
                                        //   style: ElevatedButton.styleFrom(
                                        //   backgroundColor: kPrimaryLightColor,
                                        //   foregroundColor: Colors.black,
                                        //   elevation: 0,
                                        //   ),
                                        //   onPressed: () async {
                                        //         resultProofOfFuneralExpences =
                                        //             await FilePicker.platform.pickFiles(allowMultiple: true);
                                        //         if (resultProofOfFuneralExpences == null) {
                                        //           print("No file selected");
                                        //         } else {
                                        //           setState(() {});
                                        //           for (var element in resultProofOfFuneralExpences!.files) {
                                        //             print(element.name);
                                        //           }
                                        //         }
                                        //       },
                                        //   )

                                        // ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            
                          ],
                        ),
                        
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(
                  height: 20,
                ),


                const SizedBox(
                  height: defaultPadding / 2,
                ),
                SizedBox(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          fixedSize: const Size(200, 40)),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) {
                      //       return ClaimHomePage(
                      //         userName: widget.name, 
                      //         userId: widget.userId,
                      //         phone: widget.msisdn, 
                      //         email: widget.email,
                      //       );
                      //     },
                      //   ),
                      // );
                    },
                    child: Text("Sign Up".toUpperCase()),
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
          ),
        ),
      );
    });
  }
  OutlineInputBorder myinputborder(){ //return type is OutlineInputBorder
    return const OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.black, width: 0),
            borderRadius: BorderRadius.all(
            Radius.circular(8),
          )
        );
  }

  OutlineInputBorder myfocusborder(){
    return const OutlineInputBorder(
        borderSide: BorderSide(
            color: kPrimaryColor, width: 0),
            borderRadius: BorderRadius.all(
            Radius.circular(8),
          )
        );
  }

  // Future getImages() async {
  //     final pickedFile = await picker.pickMultiImage(
  //       imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
  //     List<XFile> xfilePick = pickedFile;

  //     setState(
  //     () {
  //       if (xfilePick.isNotEmpty) {
  //       for (var i = 0; i < xfilePick.length; i++) {
  //         selectedImages.add(File(xfilePick[i].path));
  //       }
  //       } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Nothing is selected')));
  //       }
  //     },
  //     );
  // }
}
