class policyDetailsItem {
  const policyDetailsItem({
    required this.dependants,
    required this.paymentAmount,
    required this.paymentPeriod,
    required this.policyNumber,
    required this.sumInsured,
  });

  final num dependants;
  final num paymentAmount;
  final String paymentPeriod;
  final String policyNumber;
  final num sumInsured;

  
}

class policyDetailsModel {
  List<policyDetailsItem> policy_details_data = [];
  bool isLoading = false;
  String error = '';

  policyDetailsModel.initial();
}
