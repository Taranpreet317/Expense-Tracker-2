// import 'dart:math';

import 'package:expense_tracker_2/components/expense_summary.dart';
import 'package:expense_tracker_2/components/expense_tile.dart';
import 'package:expense_tracker_2/data/expensedata/expense_data.dart';
import 'package:expense_tracker_2/models/expenseitem/expenseitem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController expenseNameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // prepare data on startup
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  // add new expense function
  void addNewExpense() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Add New Expense'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: expenseNameController,
                  decoration: InputDecoration(labelText: 'Expense Name'),
                ),
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: save, child: Text('Save')),
              TextButton(onPressed: cancel, child: Text('Cancel')),
            ],
          ),
    );
  }

  // save new expense
  void save() {
    if (expenseNameController.text.isNotEmpty &&
        amountController.text.isNotEmpty) {
      // create expense item
      Expenseitem newExpense = Expenseitem(
        name: expenseNameController.text,
        amount: amountController.text,
        dateTime: DateTime.now(),
      );
      // add new expense
      Provider.of<ExpenseData>(
        context,
        listen: false,
      ).addNewExpense(newExpense);
    }
    Navigator.pop(context);

    clear();
  }

  void deleteExpense(Expenseitem expenseToDelete) {
    Provider.of<ExpenseData>(
      context,
      listen: false,
    ).deleteExpense(expenseToDelete);
  }

  // cancel adding expense
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    expenseNameController.clear();
    amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder:
          (context, value, child) => Scaffold(
            backgroundColor: Colors.grey[300],
            floatingActionButton: FloatingActionButton(
              onPressed: addNewExpense,
              backgroundColor: Colors.black,
              child: const Icon(Icons.add, color: Colors.white),
            ),
            body: ListView(
              children: [
                // weekly expense chart
                ExpenseSummary(startOfWeek: value.getStartOfWeek()),

                const SizedBox(height: 20),
                // expense list
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: value.getAllExpenseList().length,
                  itemBuilder: (context, index) {
                    final expense = value.getAllExpenseList()[index];
                    return ExpenseTile(
                      name: expense.name,
                      amount: expense.amount,
                      dateTime: expense.dateTime,
                      onDelete: () => deleteExpense(expense),
                    );
                  },
                ),
              ],
            ),
          ),
    );
  }
}
