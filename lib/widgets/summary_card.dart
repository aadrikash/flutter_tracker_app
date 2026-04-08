import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final double income;
  final double expense;

  SummaryCard({required this.income, required this.expense});

  @override
  Widget build(BuildContext context) {
    double balance = income - expense;

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: [Colors.indigo, Colors.blueAccent],
        ),
      ),
      child: Column(
        children: [
          Text("Total Balance", style: TextStyle(color: Colors.white70)),
          SizedBox(height: 8),
          Text("₹ $balance",
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildMiniCard("Income", income, Colors.green),
              buildMiniCard("Expense", expense, Colors.red),
            ],
          )
        ],
      ),
    );
  }

  Widget buildMiniCard(String title, double value, Color color) {
    return Column(
      children: [
        Text(title, style: TextStyle(color: Colors.white70)),
        Text("₹ $value",
            style: TextStyle(color: color, fontWeight: FontWeight.bold))
      ],
    );
  }
}
