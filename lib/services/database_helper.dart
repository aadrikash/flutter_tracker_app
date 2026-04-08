import '../models/transaction_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  DatabaseHelper._init();

  final List<TransactionModel> _transactions = [];

  List<TransactionModel> getTransactions() {
    return _transactions;
  }

  void insertTransaction(TransactionModel transaction) {
    _transactions.add(transaction);
  }
}
