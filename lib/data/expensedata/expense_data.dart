import 'package:expense_tracker_2/data/hive_database/hive_databse.dart';
import 'package:expense_tracker_2/datetime/date_time_helper.dart';
import 'package:expense_tracker_2/models/expenseitem/expenseitem.dart';
import 'package:flutter/material.dart';

class ExpenseData extends ChangeNotifier {
  // list of All Expenses
  List<Expenseitem> overallExpenseList = [];

  // get expense list
  List<Expenseitem> getAllExpenseList() {
    return overallExpenseList;
  }

  // prepare data to display
  final db = HiveDatabse();
  void prepareData() {
    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
    }
  }

  // add expense to the list
  void addNewExpense(Expenseitem newExpense) {
    overallExpenseList.add(newExpense);
    notifyListeners();
    db.saveData(
      overallExpenseList
          .map(
            (expense) => {
              'name': expense.name,
              'amount': expense.amount,
              'dateTime': expense.dateTime,
            },
          )
          .toList(),
    );
  }

  // delete expense from the list
  void deleteExpense(Expenseitem expenseToDelete) {
    overallExpenseList.remove(expenseToDelete);
    notifyListeners();
    db.saveData(
      overallExpenseList
          .map(
            (expense) => {
              'name': expense.name,
              'amount': expense.amount,
              'dateTime': expense.dateTime,
            },
          )
          .toList(),
    );
  }

  // get weekday(mon,tues,wed...) from dateTime object
  String getDayOfWeek(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  // get the date for the start of the week (Sunday)
  DateTime getStartOfWeek() {
    DateTime? startOfweek;

    // get todays date
    DateTime today = DateTime.now();
    // go backwards to find the sunday
    for (int i = 0; i < 7; i++) {
      if (getDayOfWeek(today.subtract(Duration(days: i))) == 'Sun') {
        startOfweek = today.subtract(Duration(days: i));
      }
    }
    return startOfweek!;
  }

  // calculate daily expense
  Map<String, double> calculateDailyExpense() {
    Map<String, double> dailyExpenseMap = {};

    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.tryParse(expense.amount) ?? 0.0;

      if (dailyExpenseMap.containsKey(date)) {
        double currentAmount = dailyExpenseMap[date]!;
        currentAmount += amount;
        dailyExpenseMap[date] = currentAmount;
      } else {
        dailyExpenseMap.addAll({date: amount});
      }
    }

    return dailyExpenseMap;
  }
}
