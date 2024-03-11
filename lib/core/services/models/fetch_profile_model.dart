class profilePicItem {
  const profilePicItem({

  required this.pic,

  });

  final String pic;
}

class profilePicModel {
  String profile_url = '';
  bool isLoading = false;
  String error = '';

 profilePicModel.initial();
}
