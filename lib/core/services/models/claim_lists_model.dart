class claimListItem {
  const claimListItem({
    required this.claimType,
    required this.processingStatus,
    required this.updatedAt,

  });

  final String claimType;
  final String processingStatus;
  final String updatedAt;

}

class claimListModel {
  List<claimListItem> claim_data = [];
  bool isLoading = false;
  String error = '';

  claimListModel.initial();
}
