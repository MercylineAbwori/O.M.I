import 'package:flutter/material.dart';
import 'package:one_million_app/core/constant_service.dart';

class BeneficiaryFormPage extends StatefulWidget {
  BeneficiaryFormPage({
    super.key,
  });

  @override
  State<BeneficiaryFormPage> createState() => _BeneficiaryFormPageState();
}

class _BeneficiaryFormPageState extends State<BeneficiaryFormPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
                child: ElevatedButton(
                    onPressed: () async {
                      await ApiService().listClaim(1);
                    },
                    child: Text("Get Response")))
          ],
        ),
      ),
    );
  }
}
