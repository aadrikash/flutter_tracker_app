import 'package:flutter/material.dart';

class AnalyticsCard extends StatelessWidget {
  final double income;
  final double expense;

  AnalyticsCard({required this.income, required this.expense});

  @override
  Widget build(BuildContext context) {
    double total = income + expense;
    double incomePercent = total == 0 ? 0 : (income / total);
    double expensePercent = total == 0 ? 0 : (expense / total);

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient:
            LinearGradient(colors: [Colors.deepPurple, Colors.purpleAccent]),
      ),
      child: Column(
        children: [
          Text("Monthly Analysis",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),

          SizedBox(height: 20),

          // Income Bar
          buildBar("Income", incomePercent, Colors.green),

          SizedBox(height: 15),

          // Expense Bar
          buildBar("Expense", expensePercent, Colors.red),
        ],
      ),
    );
  }

  Widget buildBar(String label, double percent, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white)),
        SizedBox(height: 6),
        Container(
          height: 10,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(10),
          ),
          child: FractionallySizedBox(
            widthFactor: percent,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
