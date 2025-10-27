import 'package:expense_tracker_2/models/expenseitem/expenseitem.dart';
import 'package:hive_flutter/adapters.dart';

class HiveDatabse {
  // refrence the hive box
  final _myBox = Hive.box('expense_database');
  // write data
  void saveData(List<Map<String, dynamic>> allExpense) {
    List<List<dynamic>> allExpensesFormatted = [];

    for (var expense in allExpense) {
      // convert each expenseItem into a list  of storable types (string,dateTime)
      List<dynamic> expenseFormatted = [
        expense['name'],
        expense['amount'],
        expense['dateTime'].toString(),
      ];
      allExpensesFormatted.add(expenseFormatted);
    }
    // finally store in our database
    _myBox.put('ALL_EXPENSE', allExpensesFormatted);
  }

  // read data
  List<Expenseitem> readData() {
    List savedExpense = _myBox.get('ALL_EXPENSE') ?? [];
    List<Expenseitem> allExpenses = [];

    for (int i = 0; i < savedExpense.length; i++) {
      // collect individual expense data
      String name = savedExpense[i][0];
      String amount = savedExpense[i][1];
      DateTime dateTime = DateTime.parse(savedExpense[i][2]);

      // create expense item
      Expenseitem expense = Expenseitem(
        name: name,
        amount: amount,
        dateTime: dateTime,
      );
      // add expense item to the list
      allExpenses.add(expense);
    }
    return allExpenses;
  }
}
