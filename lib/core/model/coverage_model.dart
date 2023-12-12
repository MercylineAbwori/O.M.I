class Coverage{
  final String name;
  final String sumInsured ;

  Coverage({
    required this.name,
    required this.sumInsured,
  });


 factory Coverage.fromJson(Map<String, dynamic> json) {
    return Coverage(
      name: json['name'],
      sumInsured: json['sumInsured'],
    );
  }
}