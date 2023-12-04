class Coverage{
  final String benefits;
  final String sumInsured ;
  final String balance ;

  Coverage({
    required this.benefits,
    required this.sumInsured,
    required this.balance,
  });


 factory Coverage.fromJson(Map<String, dynamic> json) {
    return Coverage(
      benefits: json['benefits'],
      sumInsured: json['sumInsured'],
      balance: json['balance']
    );
  }
}