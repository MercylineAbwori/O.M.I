import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;


Future<File> generatePDF(
  final String nameInsuredController,
  final String nameClaimantController,
  final String postalAddressController,
  final String postalCodeController,
  final String emailController,
  final String occupationController,
  final String dateOfBirthInputController,
  final String dateOfLastPremiumInputController,
  final String agencyController,
  final String policyNoController,
  final String agencyPhoneNoController,
  final String agencyEmailController,


  final String textarea,
  final String dateOfAccidentPremiumInputController,
  final String locationOfAccidentController,
  final String witnessOccupationController,
  final String witnessTelephoneController,
  final String witnessNameController,
  final String witnessAddressController,

  
  final String claimantFullNameController,
  final String claimantOccupationController
) async {
  final pdf = pw.Document();

  // final img = await rootBundle.load('assets/images.png');
  // final imageBytes = img.buffer.asUint8List();

  // final imgtitle = await rootBundle.load('assets/title.png');
  // final imagetitleBytes = imgtitle.buffer.asUint8List();

  // final imglogo = await rootBundle.load('assets/logo.png');
  // final imagelogoBytes = imglogo.buffer.asUint8List();

  // pw.Image image1 = pw.Image(pw.MemoryImage(imageBytes));
  // pw.Image image2 = pw.Image(pw.MemoryImage(imagetitleBytes));
  // pw.Image image3 = pw.Image(pw.MemoryImage(imagelogoBytes));
//Basic Details
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Container(
          child:  pw.Column(children: [
            pw.Container(
              child: pw.Column(
                children: [
                  pw.Row(children: [
                  pw.Text("{Date of today}", 
                  style: pw.TextStyle(  
                    fontWeight: pw.FontWeight.bold, // light
                    fontStyle: pw.FontStyle.italic,)
                   ),
                  ]
                ),
              ])
            ),

            pw.SizedBox(width: 20),
            pw.Row(children: [
              // pw.Align(
              //   alignment: pw.Alignment.centerLeft,
              //   child: pw.Container(
              //   width: 500,
              //       height: 200,
              //       child: image2
              // )
              // ),
              pw.SizedBox(height: 20),
              // pw.Align(
              //   alignment: pw.Alignment.centerRight,
              //   child: pw.Container(
              //   width: 500,
              //       height: 200,
              //       child: image3
              // )
              // )
              
            ]),
            pw.SizedBox(height: 20),
            pw.Container(
              child: pw.Column(children: [

                pw.Text("Insured Details!",
              style: pw.TextStyle(  
                    fontWeight: pw.FontWeight.bold, // light
                    fontStyle: pw.FontStyle.italic,)
              ),
              pw.SizedBox(height: 20,),
              // Name of Insured and Claimant
              pw.Row(children: [
                pw.Padding(
                padding: pw.EdgeInsets.all(10),
                child: pw.Row(children: [
                  pw.Text('Name of Isured: ', style: pw.TextStyle(  
                    fontWeight: pw.FontWeight.bold, // light
                     ),),
                  pw.SizedBox(width: 20),
                  pw.Container(
                    child: pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Text(
                          nameClaimantController,
                        ),
                    )
                  ),
                  // pw.Text('{Name of Isured}'),
                ])
                ),
                pw.SizedBox(width: 50),
                pw.Padding(
                padding: pw.EdgeInsets.all(10),
                child: pw.Row(children: [
                  pw.Text('Name of Claimant: ', style: pw.TextStyle(  
                    fontWeight: pw.FontWeight.bold, // light
                     ),),
                  pw.SizedBox(width: 20),
                  pw.Container(
                    child: pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Text(
                          nameClaimantController,
                        ),
                    )
                  ),
                  // pw.Text('{Name of Isured}'),
                ])
                ),
                
              ]),
              

              //Postal Address And Postal Code
              pw.Row(children: [
                pw.Padding(
                padding: pw.EdgeInsets.all(10),
                child: pw.Row(children: [
                  pw.Text('Postal Address: ', style: pw.TextStyle(  
                    fontWeight: pw.FontWeight.bold, // light
                     ),),
                  pw.SizedBox(width: 20),
                  pw.Container(
                    child: pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Text(
                          postalAddressController,
                        ),
                    )
                  ),
                  // pw.Text('{Name of Isured}'),
                ])
                ),
                pw.SizedBox(width: 50),
                pw.Padding(
                padding: pw.EdgeInsets.all(10),
                child: pw.Row(children: [
                  pw.Text('Postal Code: ', style: pw.TextStyle(  
                    fontWeight: pw.FontWeight.bold, // light
                     ),),
                  pw.SizedBox(width: 20),
                  pw.Container(
                    child: pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Text(
                          postalCodeController,
                        ),
                    )
                  ),
                  // pw.Text('{Name of Isured}'),
                ])
                ),
                
              ]),
              
              
              //Date of Birth and Occupation
              pw.Row(children: [
                pw.Padding(
                padding: pw.EdgeInsets.all(10),
                child: pw.Row(children: [
                  pw.Text('Date of Birth: ', style: pw.TextStyle(  
                    fontWeight: pw.FontWeight.bold, // light
                     ),),
                  pw.SizedBox(width: 20),
                  pw.Container(
                    child: pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Text(
                          dateOfBirthInputController,
                        ),
                    )
                  ),
                  // pw.Text('{Name of Isured}'),
                ])
                ),
                pw.SizedBox(width: 50),
                pw.Padding(
                padding: pw.EdgeInsets.all(10),
                child: pw.Row(children: [
                  pw.Text('Occupation: ', style: pw.TextStyle(  
                    fontWeight: pw.FontWeight.bold, // light
                     ),),
                  pw.SizedBox(width: 20),
                  pw.Container(
                    child: pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Text(
                         occupationController,
                        ),
                    )
                  ),
                  // pw.Text('{Name of Isured}'),
                ])
                ),
                
              ]),
              

              //Email and Date of last premium
              pw.Row(children: [
                pw.Padding(
                padding: pw.EdgeInsets.all(10),
                child: pw.Row(children: [
                  pw.Text('Email: ', style: pw.TextStyle(  
                    fontWeight: pw.FontWeight.bold, // light
                     ),),
                  pw.SizedBox(width: 20),
                  pw.Container(
                    child: pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Text(
                          emailController,
                        ),
                    )
                  ),
                  // pw.Text('{Name of Isured}'),
                ])
                ),
                pw.SizedBox(width: 50),
                pw.Padding(
                padding: pw.EdgeInsets.all(10),
                child: pw.Row(children: [
                  pw.Text('Date of Last Premium: ', style: pw.TextStyle(  
                    fontWeight: pw.FontWeight.bold, // light
                     ),),
                  pw.SizedBox(width: 20),
                  pw.Container(
                    child: pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Text(
                          dateOfLastPremiumInputController,
                        ),
                    )
                  ),
                  // pw.Text('{Name of Isured}'),
                ])
                ),
                
              ]),
              
              ] ),
            ),
              // pw.Container(
              // child: pw.Column(children: [

              // ])
              // ),
            pw.Container(
            child: pw.Column(children: [
              pw.Text("Agency Details!",
                style: pw.TextStyle(  
                      fontWeight: pw.FontWeight.bold, // light
                      fontStyle: pw.FontStyle.italic,)),
                pw.SizedBox(height: 20),

                // Name of Insured and Claimant
                pw.Row(children: [
                  pw.Padding(
                  padding: pw.EdgeInsets.all(10),
                  child: pw.Row(children: [
                    pw.Text('Agency: ', style: pw.TextStyle(  
                      fontWeight: pw.FontWeight.bold, // light
                      ),),
                    pw.SizedBox(width: 20),
                    pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(),
                      ),
                      child: pw.Padding(
                      padding: pw.EdgeInsets.all(10),
                      child: pw.Text(
                            agencyController,
                          ),
                      )
                    ),
                    // pw.Text('{Name of Isured}'),
                  ])
                  ),
                  pw.SizedBox(width: 50),
                  pw.Padding(
                  padding: pw.EdgeInsets.all(10),
                  child: pw.Row(children: [
                    pw.Text('Policy Number: ', style: pw.TextStyle(  
                      fontWeight: pw.FontWeight.bold, // light
                      ),),
                    pw.SizedBox(width: 20),
                    pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(),
                      ),
                      child: pw.Padding(
                      padding: pw.EdgeInsets.all(10),
                      child: pw.Text(
                            policyNoController,
                          ),
                      )
                    ),
                    // pw.Text('{Name of Isured}'),
                  ])
                  ),
                  
                ]),
                

                //Postal Address And Postal Code
                pw.Row(children: [
                  pw.Padding(
                  padding: pw.EdgeInsets.all(10),
                  child: pw.Row(children: [
                    pw.Text('Phone Number: ', style: pw.TextStyle(  
                      fontWeight: pw.FontWeight.bold, // light
                      ),),
                    pw.SizedBox(width: 20),
                    pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(),
                      ),
                      child: pw.Padding(
                      padding: pw.EdgeInsets.all(10),
                      child: pw.Text(
                            agencyPhoneNoController,
                          ),
                      )
                    ),
                    // pw.Text('{Name of Isured}'),
                  ])
                  ),
                  pw.SizedBox(width: 50),
                  pw.Padding(
                  padding: pw.EdgeInsets.all(10),
                  child: pw.Row(children: [
                    pw.Text('Email: ', style: pw.TextStyle(  
                      fontWeight: pw.FontWeight.bold, // light
                      ),),
                    pw.SizedBox(width: 20),
                    pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(),
                      ),
                      child: pw.Padding(
                      padding: pw.EdgeInsets.all(10),
                      child: pw.Text(
                            agencyEmailController,
                          ),
                      )
                    ),
                    // pw.Text('{Name of Isured}'),
                  ])
                  )
            ])
            
            ])  
            )
              
          ])
        );
        },
    ));

//Accident Details
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Container(
          child:  pw.Column(children: [
            pw.Container(
              child: pw.Column(
                children: [
                  pw.Text("Accident Details!",
                  style: pw.TextStyle(  
                        fontWeight: pw.FontWeight.bold, // light
                        fontStyle: pw.FontStyle.italic,)),
                  pw.SizedBox(height: 20),
                  // Date and Location of Accident 
                  pw.Row(children: [
                    pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Row(children: [
                      pw.Text('Date of Accident: ', style: pw.TextStyle(  
                        fontWeight: pw.FontWeight.bold, // light
                        ),),
                      pw.SizedBox(width: 20),
                      pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(),
                        ),
                        child: pw.Padding(
                        padding: pw.EdgeInsets.all(10),
                        child: pw.Text(
                              dateOfAccidentPremiumInputController,
                            ),
                        )
                      ),
                      // pw.Text('{Name of Isured}'),
                    ])
                    ),
                    pw.SizedBox(width: 50),
                    pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Row(children: [
                      pw.Text('Location of Accident: ', style: pw.TextStyle(  
                        fontWeight: pw.FontWeight.bold, // light
                        ),),
                      pw.SizedBox(width: 20),
                      pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(),
                        ),
                        child: pw.Padding(
                        padding: pw.EdgeInsets.all(10),
                        child: pw.Text(
                              locationOfAccidentController,
                            ),
                        )
                      ),
                      // pw.Text('{Name of Isured}'),
                    ])
                    ),
                    
                  ]),
                  

                  pw.Text("Witness Details!",
                  style: pw.TextStyle(  
                        fontWeight: pw.FontWeight.bold, // light
                        fontStyle: pw.FontStyle.italic,)
                      ),
                  pw.SizedBox(height: 20),
                  //Name and Address of witness
                  pw.Row(children: [
                    pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Row(children: [
                      pw.Text('Name of Witness: ', style: pw.TextStyle(  
                        fontWeight: pw.FontWeight.bold, // light
                        ),),
                      pw.SizedBox(width: 20),
                      pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(),
                        ),
                        child: pw.Padding(
                        padding: pw.EdgeInsets.all(10),
                        child: pw.Text(
                              witnessNameController,
                            ),
                        )
                      ),
                      // pw.Text('{Name of Isured}'),
                    ])
                    ),
                    pw.SizedBox(width: 50),
                    pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Row(children: [
                      pw.Text('Occupation: ', style: pw.TextStyle(  
                        fontWeight: pw.FontWeight.bold, // light
                        ),),
                      pw.SizedBox(width: 20),
                      pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(),
                        ),
                        child: pw.Padding(
                        padding: pw.EdgeInsets.all(10),
                        child: pw.Text(
                              witnessOccupationController,
                            ),
                        )
                      ),
                      // pw.Text('{Name of Isured}'),
                    ])
                    ),
                    
                  ]),
                  
                  
                  //Occupation and Telephone Number
                  pw.Row(children: [
                    pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Row(children: [
                      pw.Text('Telephone: ', style: pw.TextStyle(  
                        fontWeight: pw.FontWeight.bold, // light
                        ),),
                      pw.SizedBox(width: 20),
                      pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(),
                        ),
                        child: pw.Padding(
                        padding: pw.EdgeInsets.all(10),
                        child: pw.Text(
                              witnessTelephoneController,
                            ),
                        )
                      ),
                      // pw.Text('{Name of Isured}'),
                    ])
                    ),
                    pw.SizedBox(width: 50),
                    pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Row(children: [
                      pw.Text('Address: ', style: pw.TextStyle(  
                        fontWeight: pw.FontWeight.bold, // light
                        ),),
                      pw.SizedBox(width: 20),
                      pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(),
                        ),
                        child: pw.Padding(
                        padding: pw.EdgeInsets.all(10),
                        child: pw.Text(
                              witnessAddressController,
                            ),
                        )
                      ),
                      // pw.Text('{Name of Isured}'),
                    ])
                    ),
                    
                  ]),
                  
                ]
              ),
            ),
            pw.Container(
              child: pw.Column(
                children: [
                  pw.Row(children: [
                  pw.Text("How did the accident Occur?", 
                  style: pw.TextStyle(  
                    fontWeight: pw.FontWeight.bold, // light
                    fontStyle: pw.FontStyle.italic,)
                   ),
                  ]
                ),
              pw.SizedBox(width: 20),
              //Email and Date of last premium
              pw.Column(
                children: [
                pw.Padding(
                padding: pw.EdgeInsets.all(10),
                child: pw.Row(children: [
                  pw.Container(
                    width: 500,
                    height: 200,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(),
                    ),
                    child: pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Text(
                          textarea,
                          maxLines: 8,
                        ),
                    )
                  ),
                  // pw.Text('{Name of Isured}'),
                ])
                ),
                
              ]),
              


              
                ]
              ),
              ),
            pw.SizedBox(height: 300),
            // pw.Container(
            //   width: 500,
            //       height: 200,
            //       child: image1
            // )
              

              
              // pw.Text("How did the accident Occur"),
              // pw.SizedBox(height: 20),
              // //Email and Date of last premium
              // pw.Row(children: [
              //   pw.Padding(
              //   padding: pw.EdgeInsets.all(10),
              //   child: pw.Row(children: [
              //     pw.Text('Name of Isured: ', style: pw.TextStyle(  
                    // fontWeight: pw.FontWeight.bold, // light
                    //  ),),
              //     pw.SizedBox(width: 20),
              //     pw.Container(
              //       decoration: pw.BoxDecoration(
              //         border: pw.Border.all(),
              //       ),
              //       child: pw.Padding(
              //       padding: pw.EdgeInsets.all(10),
              //       child: pw.Text(
              //             "{Name of Isured}",
              //           ),
              //       )
              //     ),
              //     // pw.Text('{Name of Isured}'),
              //   ])
              //   ),
              //   pw.SizedBox(width: 50),
              //   pw.Padding(
              //   padding: pw.EdgeInsets.all(10),
              //   child: pw.Row(children: [
              //     pw.Text('Name of Isured: ', style: pw.TextStyle(  
                    // fontWeight: pw.FontWeight.bold, // light
                    //  ),),
              //     pw.SizedBox(width: 20),
              //     pw.Container(
              //       decoration: pw.BoxDecoration(
              //         border: pw.Border.all(),
              //       ),
              //       child: pw.Padding(
              //       padding: pw.EdgeInsets.all(10),
              //       child: pw.Text(
              //             "{Name of Isured}",
              //           ),
              //       )
              //     ),
              //     // pw.Text('{Name of Isured}'),
              //   ])
              //   ),
                
              // ]),
              // 


             
          ]) 
        );
      },
    ));

    //Medical Details
    // pdf.addPage(pw.Page(
    //   build: (pw.Context context) {
    //     return pw.Container(
    //       child: pw.Column(
    //         children: [
              
              
    //         ],
    //       ),
          
    //     );
    //   },
    // ));


     //Get external storage directory
    final directory = await getApplicationSupportDirectory();

    //Get directory path
    final path = directory.path;

    //Create an empty file to write PDF data
    final file = File("$path/applicationCode.pdf");

    //Write PDF data
    await file.writeAsBytes(await pdf.save(), flush: true);

    //Open the PDF document in mobile
    OpenFile.open('$path/applicationCode.pdf');
    
  return file;
}