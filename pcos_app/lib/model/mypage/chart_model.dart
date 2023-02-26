class ChartModel {
  final DateTime date;
  final double height;
  final double weight;
  final double predict;

  ChartModel(
      {required this.date,
      required this.height,
      required this.weight,
      required this.predict});

  ChartModel.fromMap(Map<String, dynamic> map)
      : date = map['date'],
        height = map['height'],
        weight = map['weight'],
        predict = map['predict'];

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'height': height,
      'weight': weight,
      'predict': predict,
    };
  }
}
