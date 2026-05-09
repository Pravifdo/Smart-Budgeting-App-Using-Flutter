import 'package:flutter/material.dart';
import 'add_expense_screen.dart';
import 'add_income_screen.dart';
import '../services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final String userName = "Praveen";
  double totalBalance = 0.0;
  double income = 0.0;
  double expense = 0.0;
  List<Map<String, dynamic>> recentTransactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() => isLoading = true);
    try {
      final expenses = await ApiService.getExpenses();
      final incomes = await ApiService.getIncomes();

      double totalExp = 0;
      for (var item in expenses) {
        totalExp += (item['amount'] as num).toDouble();
      }

      double totalInc = 0;
      for (var item in incomes) {
        totalInc += (item['amount'] as num).toDouble();
      }

      List<Map<String, dynamic>> allTxs = [];
      for (var item in incomes) {
        allTxs.add({
          "title": item['source'] ?? "Income",
          "amount": (item['amount'] as num).toDouble(),
          "date": DateTime.parse(item['date']),
        });
      }
      for (var item in expenses) {
        allTxs.add({
          "title": item['category'] ?? "Expense",
          "amount": -(item['amount'] as num).toDouble(),
          "date": DateTime.parse(item['date']),
        });
      }

      allTxs.sort((a, b) => b['date'].compareTo(a['date']));

      setState(() {
        income = totalInc;
        expense = totalExp;
        totalBalance = totalInc - totalExp;
        recentTransactions = allTxs;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background
      appBar: AppBar(
        title: const Text("Dashboard"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Text
              Text(
                "Welcome $userName 👋",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),

              // Total Balance Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blueAccent, Colors.lightBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "Total Balance",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Rs. ${totalBalance.toStringAsFixed(0)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Income & Expense Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIncomeExpenseCard(
                    title: "Income",
                    amount: income,
                    icon: Icons.arrow_downward,
                    color: Colors.green,
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddIncomeScreen()),
                      );

                      if (result != null && result is Map<String, dynamic>) {
                        await ApiService.addIncome({
                          "source": result['title'],
                          "amount": result['amount'],
                        });
                        fetchData(); // Refresh all data
                      }
                    },
                  ),
                  _buildIncomeExpenseCard(
                    title: "Expense",
                    amount: expense,
                    icon: Icons.arrow_upward,
                    color: Colors.red,
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
                      );

                      if (result != null && result is Map<String, dynamic>) {
                        await ApiService.addExpense({
                          "category": result['title'],
                          "amount": result['amount'],
                          "description": result['title'],
                        });
                        fetchData(); // Refresh all data
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Recent Transactions Header
              const Text(
                "Recent Transactions",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // Recent Transactions List
              Expanded(
                child: ListView.builder(
                  itemCount: recentTransactions.length,
                  itemBuilder: (context, index) {
                    final tx = recentTransactions[index];
                    final bool isIncome = tx["amount"] > 0;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: (isIncome ? Colors.green : Colors.red).withValues(alpha: 0.1),
                          child: Icon(
                            isIncome ? Icons.attach_money : Icons.money_off,
                            color: isIncome ? Colors.green : Colors.red,
                          ),
                        ),
                        title: Text(
                          tx["title"],
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        trailing: Text(
                          "${tx["amount"].toStringAsFixed(0)} Rs",
                          style: TextStyle(
                            color: isIncome ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // Add Expense Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
            );

            if (result != null && result is Map<String, dynamic>) {
              await ApiService.addExpense({
                "category": result['title'],
                "amount": result['amount'],
                "description": result['title'],
              });
              fetchData();
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.blueAccent,
            elevation: 2,
          ),
          child: const Text(
            "+ Add Expense",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIncomeExpenseCard({
    required String title,
    required double amount,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
        margin: EdgeInsets.only(
          right: title == "Income" ? 10 : 0,
          left: title == "Expense" ? 10 : 0,
        ),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.05),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.1),
              radius: 18,
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    amount.toStringAsFixed(0),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
