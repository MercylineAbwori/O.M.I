import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/model/upload_document_model.dart';
import 'package:one_million_app/shared/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';

//constants
const buttonTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w900,
);

// class SignUpForm extends StatelessWidget {
//   const SignUpForm({
//     Key? key,
//   }) : super(key: key);
class UploadFiles extends StatefulWidget {
  final num userId;
  const UploadFiles({Key? key, required this.userId}) : super(key: key);

  @override
  _UploadFilesState createState() => _UploadFilesState();
}

class _UploadFilesState extends State<UploadFiles>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _selectedColor = kPrimaryColor;

  final _tabs = [
    const Tab(text: 'ID Upload'),
    const Tab(text: 'Driving License'),
    const Tab(text: 'Logbook Upload'),
  ];

  final ImagePicker _picker = ImagePicker();

  File? _imageFrontId;
  File? _imageBackId;

  File? _imageDrivingLincencs;

  File? _imageLogbook;

  //All File boolean
  bool? _isButtonDisabledFID;
  bool? _isButtonDisabledEID;
  bool? _isButtonDisabledDL;
  bool? _isButtonDisabledLog;

  //All file responce messages
  String? messageFrontID;
  String? messageEndID;
  String? messageDrivingL;
  String? messageLogBook;

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

      if (response.statusCode == 5000) {
        if (file == _imageFrontId) {
          messageFrontID = responseData["statusMessage"];
        } else if (file == _imageBackId) {
          messageEndID = responseData["statusMessage"];
        } else if (file == _imageDrivingLincencs) {
          messageDrivingL = responseData["statusMessage"];
        } else if (file == _imageLogbook) {
          messageLogBook = responseData["statusMessage"];
        }
      } else {
        throw Exception('Unexpected Calculator error occured!');
      }
      log('The Request Payload : ${request.files}');
    } on PlatformException catch (e) {
      log('Unsupported operation' + e.toString());
    } catch (e) {
      log(e.toString());
    }

    setState(() {
      _isButtonDisabledFID = true;
    });
  }

  Future getImageDrivingLicence(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);

      if (image == null) return;

      // final imageTemporary = File(image.path);
      final imagePermanent = await saveFilePermanently(image.path);

      setState(() {
        this._imageDrivingLincencs = imagePermanent;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future getImageLogbook(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);

      if (image == null) return;

      // final imageTemporary = File(image.path);
      final imagePermanent = await saveFilePermanently(image.path);

      setState(() {
        this._imageLogbook = imagePermanent;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future getImageFrontID(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);

      if (image == null) return;

      // final imageTemporary = File(image.path);
      final imagePermanent = await saveFilePermanently(image.path);

      setState(() {
        this._imageFrontId = imagePermanent;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future getImageBackID(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);

      if (image == null) return;

      // final imageTemporary = File(image.path);
      final imagePermanent = await saveFilePermanently(image.path);

      setState(() {
        this._imageBackId = imagePermanent;
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
          length: 3,
          child: Column(
            children: <Widget>[
              Container(
                constraints: const BoxConstraints.expand(height: 80),
                padding: const EdgeInsets.all(10),
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
                                  // Capture Front ID upload
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          'Front ID photo',
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
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: _imageFrontId != null
                                                      ? Image.file(
                                                          _imageFrontId!,
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
                                                      icon:
                                                          Icons.image_outlined,
                                                      onClick: () =>
                                                          getImageFrontID(
                                                              ImageSource
                                                                  .gallery),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    CustomButton(
                                                      title: 'Pick from Camera',
                                                      icon: Icons.camera,
                                                      onClick: () =>
                                                          getImageFrontID(
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
                                      const SizedBox(height: 10),
                                      SizedBox(
                                          height: 40.0,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: kPrimaryColor,
                                                fixedSize: const Size(200, 40)),
                                            onPressed: () async {
                                              // await pickerFiles(widget.userId, 'Front National ID', _imageFrontId);
                                              await pickerFiles(
                                                  widget.userId,
                                                  // 'Front National ID',
                                                  'front national id',
                                                  _imageFrontId);

                                              // final snackBar = SnackBar(
                                              //   content: Text(messageFrontID!),
                                              //   action: SnackBarAction(
                                              //     label: 'Undo',
                                              //     onPressed: () {
                                              //       // Some code to undo the change.
                                              //     },
                                              //   ),
                                              // );

                                              // ScaffoldMessenger.of(context)
                                              //     .showSnackBar(snackBar);
                                            },
                                            child: const Text(
                                              "Submit Front ID",
                                              style: TextStyle(
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  //Capture End ID upload
                                  Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          'Back ID photo',
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
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: _imageBackId != null
                                                      ? Image.file(
                                                          _imageBackId!,
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
                                                      icon:
                                                          Icons.image_outlined,
                                                      onClick: () =>
                                                          getImageBackID(
                                                              ImageSource
                                                                  .gallery),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    CustomButton(
                                                      title: 'Pick from Camera',
                                                      icon: Icons.camera,
                                                      onClick: () =>
                                                          getImageBackID(
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
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        height: 40.0,
                                        child: (messageFrontID ==
                                                'Request processed Successfully')
                                            ? ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        kPrimaryColor,
                                                    fixedSize:
                                                        const Size(200, 40)),
                                                onPressed: () async {
                                                  await pickerFiles(
                                                      widget.userId,
                                                      // 'Back National ID',
                                                      'back national id',
                                                      _imageBackId);

                                                  // final snackBar = SnackBar(
                                                  //   content: Text(messageEndID!),
                                                  //   action: SnackBarAction(
                                                  //     label: 'Undo',
                                                  //     onPressed: () {
                                                  //       // Some code to undo the change.
                                                  //     },
                                                  //   ),
                                                  // );

                                                  // ScaffoldMessenger.of(context)
                                                  //     .showSnackBar(snackBar);
                                                },
                                                child: const Text(
                                                  "Submit Back ID",
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              )
                                            : ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        kPrimaryColor,
                                                    fixedSize:
                                                        const Size(200, 40)),
                                                onPressed: null,
                                                child: const Text(
                                                  "Submit Back ID",
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            )),
                      ),
                    )),
                    Container(
                        child: SingleChildScrollView(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            child: Column(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                //Driving Licence upload
                                Column(
                                  children: [
                                    const Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text(
                                            'Driving License photo',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17),
                                          ),
                                        ),
                                      ],
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
                                                    const EdgeInsets.all(20.0),
                                                child: _imageDrivingLincencs !=
                                                        null
                                                    ? Image.file(
                                                        _imageDrivingLincencs!,
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
                                                    title: 'Pick from Gallery',
                                                    icon: Icons.image_outlined,
                                                    onClick: () =>
                                                        getImageDrivingLicence(
                                                            ImageSource
                                                                .gallery),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  CustomButton(
                                                    title: 'Pick from Camera',
                                                    icon: Icons.camera,
                                                    onClick: () =>
                                                        getImageDrivingLicence(
                                                            ImageSource.camera),
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
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      height: 40.0,
                                      child: (messageEndID ==
                                              'Request processed Successfully')
                                          ? ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      kPrimaryColor,
                                                  fixedSize:
                                                      const Size(200, 40)),
                                              onPressed: () async {
                                                await pickerFiles(
                                                    widget.userId,
                                                    'driving licence',
                                                    _imageDrivingLincencs);

                                                // final snackBar = SnackBar(
                                                //   content: Text(messageDrivingL!),
                                                //   action: SnackBarAction(
                                                //     label: 'Undo',
                                                //     onPressed: () {
                                                //       // Some code to undo the change.
                                                //     },
                                                //   ),
                                                // );

                                                // ScaffoldMessenger.of(context)
                                                //     .showSnackBar(snackBar);
                                              },
                                              child: const Text(
                                                "Submit Driving License",
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            )
                                          : ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      kPrimaryColor,
                                                  fixedSize:
                                                      const Size(200, 40)),
                                              onPressed: null,
                                              child: const Text(
                                                "Submit Driving License",
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )),
                    Container(
                        child: SingleChildScrollView(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            child: Column(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                //Driving Licence upload
                                Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        'Log book attach',
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
                                                    const EdgeInsets.all(20.0),
                                                child: _imageLogbook != null
                                                    ? Image.file(
                                                        _imageLogbook!,
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
                                                    title: 'Pick from Gallery',
                                                    icon: Icons.image_outlined,
                                                    onClick: () =>
                                                        getImageLogbook(
                                                            ImageSource
                                                                .gallery),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  CustomButton(
                                                    title: 'Pick from Camera',
                                                    icon: Icons.camera,
                                                    onClick: () =>
                                                        getImageLogbook(
                                                            ImageSource.camera),
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
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      height: 40.0,
                                      child: (messageDrivingL ==
                                              'Request processed Successfully')
                                          ? ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      kPrimaryColor,
                                                  fixedSize:
                                                      const Size(200, 40)),
                                              onPressed: () async {
                                                await pickerFiles(widget.userId,
                                                    'logbook', _imageLogbook);

                                                // final snackBar = SnackBar(
                                                //   content: Text(messageLogBook!),
                                                //   action: SnackBarAction(
                                                //     label: 'Undo',
                                                //     onPressed: () {
                                                //       // Some code to undo the change.
                                                //     },
                                                //   ),
                                                // );

                                                // ScaffoldMessenger.of(context)
                                                //     .showSnackBar(snackBar);
                                              },
                                              child: const Text(
                                                "Submit Logbook",
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            )
                                          : ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      kPrimaryColor,
                                                  fixedSize:
                                                      const Size(200, 40)),
                                              onPressed: null,
                                              child: const Text(
                                                "Submit Logbook",
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
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
