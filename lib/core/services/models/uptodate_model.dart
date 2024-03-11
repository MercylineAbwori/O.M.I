class upToDateListItem {
  const upToDateListItem({
    required this.claimApplicationActive,
    required this.paymentAmount,
    required this.qualifiesForCompensation,
    required this.uptoDatePayment,
  });
  //userDetails:

  final String claimApplicationActive;
  final num paymentAmount;
  final String qualifiesForCompensation;
  final String uptoDatePayment;
}

class upToDateListModel {
  List<upToDateListItem> uptodate_data = [];
  bool isLoading = false;
  String error = '';

  upToDateListModel.initial();
}
