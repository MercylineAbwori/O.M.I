class policyDetailsItem {
  const policyDetailsItem({
    required this.createdAt,
    required this.dependants,
    required this.id,
    required this.paymentAmount,
    required this.paymentPeriod,
    required this.policyNumber,
    required this.sumInsured,
    required this.updatedAt,

    //userDetails:

    required this.userDetailscreatedAt,
    required this.userDetailsemail,
    required this.userDetailsgender,
    required this.userDetailsmsisdn,
    required this.userDetailsname,
    required this.userDetailspin,
    required this.userDetailsupdatedAt,
    required this.userDetailsuserId,
  });

  final String createdAt;
  final num dependants;
  final num id;
  final num paymentAmount;
  final String paymentPeriod;
  final String policyNumber;
  final num sumInsured;
  final String updatedAt;

  //userDetails:

  final String userDetailscreatedAt;
  final String userDetailsemail;
  final String userDetailsgender;
  final String userDetailsmsisdn;
  final String userDetailsname;
  final String userDetailspin;
  final String userDetailsupdatedAt;
  final num userDetailsuserId;
}

class policyDetailsModel {
  List<policyDetailsItem> policy_details_data = [];
  bool isLoading = false;
  String error = '';

  policyDetailsModel.initial();
}
