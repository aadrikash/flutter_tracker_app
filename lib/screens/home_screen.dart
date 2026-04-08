import 'package:flutter/material.dart';
import '../services/theme_service.dart';
import '../services/database_helper.dart';
import '../models/transaction_model.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_tile.dart';
import '../widgets/analytics_card.dart';
import '../widgets/pie_chart_widget.dart';
import '../widgets/location_card.dart';
import 'add_transaction_screen.dart';
import 'chatbot_screen.dart';
import 'ar_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final ThemeService themeService;

  HomeScreen({required this.themeService});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TransactionModel> transactions = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    transactions = DatabaseHelper.instance.getTransactions();
  }

  double get income => transactions
      .where((e) => e.type == "income")
      .fold(0, (sum, item) => sum + item.amount);

  double get expense => transactions
      .where((e) => e.type == "expense")
      .fold(0, (sum, item) => sum + item.amount);

  void refresh() {
    setState(() {
      loadData();
    });
  }

  Widget buildLegend(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(4)),
        ),
        SizedBox(width: 6),
        Text(title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Dashboard"),
        centerTitle: true,
        elevation: 0,
        actions: [
          // 🔷 AR Experience entry point
          IconButton(
            icon: const Icon(Icons.view_in_ar),
            tooltip: 'View in AR',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ARScreen()),
              );
            },
          ),
          // 💬 Chatbot entry point
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            tooltip: 'Chat Assistant',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChatbotScreen()),
              );
            },
          ),
        ],
      ),

      // 🔹 Drawer
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient:
                    LinearGradient(colors: [Colors.indigo, Colors.blueAccent]),
              ),
              child: Center(
                child: Text(
                  "Settings",
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SwitchListTile(
              title: Text("Dark Mode"),
              value: widget.themeService.isDark,
              onChanged: (val) {
                widget.themeService.toggleTheme();
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        LoginScreen(themeService: widget.themeService),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // 💰 Summary Card
            SummaryCard(income: income, expense: expense),

            SizedBox(height: 10),

            // 📍 GPS Location Card (Feature 1)
            const LocationCard(),

            SizedBox(height: 10),

            // 🥧 Pie Chart Section
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.purpleAccent]),
              ),
              child: Column(
                children: [
                  Text(
                    "Income vs Expense",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  PieChartWidget(
                    income: income,
                    expense: expense,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildLegend("Income", Colors.green),
                      buildLegend("Expense", Colors.red),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 15),

            // 📊 Analytics Bars
            AnalyticsCard(income: income, expense: expense),

            SizedBox(height: 20),

            // 🧾 Transactions Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Recent Transactions",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            SizedBox(height: 10),

            transactions.isEmpty
                ? Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "No transactions yet!",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return TransactionTile(transaction: transactions[index]);
                    },
                  ),

            SizedBox(height: 80),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTransactionScreen()),
          );
          refresh();
        },
      ),
    );
  }
}
