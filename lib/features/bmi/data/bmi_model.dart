class BMIRecord {
  final int? id;
  final String date;
  final double weight;
  final double height;
  final double bmi;

  BMIRecord({
    this.id,
    required this.date,
    required this.weight,
    required this.height,
    required this.bmi,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'weight': weight,
      'height': height,
      'bmi': bmi,
    };
  }

  factory BMIRecord.fromMap(Map<String, dynamic> map) {
    return BMIRecord(
      id: map['id'] as int?,
      date: map['date'] as String,
      weight: map['weight'] as double,
      height: map['height'] as double,
      bmi: map['bmi'] as double,
    );
  }

  BMIRecord copyWith({
    int? id,
    String? date,
    double? weight,
    double? height,
    double? bmi,
  }) {
    return BMIRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      bmi: bmi ?? this.bmi,
    );
  }

  static double calculateBMI(double weight, double height) {
    if (height <= 0 || weight <= 0) return 0.0;
    return weight / ((height / 100) * (height / 100));
  }

  static String getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  static int getBMIColor(double bmi) {
    if (bmi < 18.5) return 0xFF2196F3; // Blue
    if (bmi < 25) return 0xFF4CAF50; // Green
    if (bmi < 30) return 0xFFFF9800; // Orange
    return 0xFFF44336; // Red
  }
}

