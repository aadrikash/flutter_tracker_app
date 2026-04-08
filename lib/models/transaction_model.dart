class TransactionModel {
  final String title;
  final double amount;
  final String type;
  final String category;
  final String date;

  TransactionModel({
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
  });
}
