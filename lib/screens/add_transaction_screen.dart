import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/database_helper.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController amountController = TextEditingController();

  String type = "expense";

  void save() {
    final tx = TransactionModel(
      title: titleController.text,
      amount: double.parse(amountController.text),
      type: type,
      category: "General",
      date: DateTime.now().toString(),
    );

    DatabaseHelper.instance.insertTransaction(tx);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Transaction")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Amount",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: type,
              items: ["income", "expense"]
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                setState(() {
                  type = val!;
                });
              },
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: save,
                child: Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
