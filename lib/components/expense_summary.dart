import 'package:expense_tracker_2/bar%20graph/bar_graph.dart';
import 'package:expense_tracker_2/data/expensedata/expense_data.dart';
import 'package:expense_tracker_2/datetime/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseSummary extends StatelessWidget {
  final DateTime startOfWeek;
  const ExpenseSummary({super.key, required this.startOfWeek});

  // calculate max amount in bar graph
  double calculateMa(
    ExpenseData value,
    String sunday,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
  ) {
    double? max = 10000;
    List<double> values = [
      value.calculateDailyExpense()[sunday] ?? 0,
      value.calculateDailyExpense()[monday] ?? 0,
      value.calculateDailyExpense()[tuesday] ?? 0,
      value.calculateDailyExpense()[wednesday] ?? 0,
      value.calculateDailyExpense()[thursday] ?? 0,
      value.calculateDailyExpense()[friday] ?? 0,
      value.calculateDailyExpense()[saturday] ?? 0,
    ];

    // sotrt values in ascending order
    values.sort();
    // get the largest value
    // and increase the cap slightly for better visuals
    max = values.last + 1000;
    return max == 0 ? 1000 : max;
  }

  // calculate the week total

  String calculateWeekTotal(
    ExpenseData value,
    String sunday,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
  ) {
    List<double> values = [
      value.calculateDailyExpense()[sunday] ?? 0,
      value.calculateDailyExpense()[monday] ?? 0,
      value.calculateDailyExpense()[tuesday] ?? 0,
      value.calculateDailyExpense()[wednesday] ?? 0,
      value.calculateDailyExpense()[thursday] ?? 0,
      value.calculateDailyExpense()[friday] ?? 0,
      value.calculateDailyExpense()[saturday] ?? 0,
    ];

    double total = 0;
    for (int i = 0; i < values.length; i++) {
      total += values[i];
    }

    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    // get yyyymmdd for each of this week
    String sunday = convertDateTimeToString(
      startOfWeek.add(const Duration(days: 0)),
    );
    String monday = convertDateTimeToString(
      startOfWeek.add(const Duration(days: 1)),
    );
    String tuesday = convertDateTimeToString(
      startOfWeek.add(const Duration(days: 2)),
    );
    String wednesday = convertDateTimeToString(
      startOfWeek.add(const Duration(days: 3)),
    );
    String thursday = convertDateTimeToString(
      startOfWeek.add(const Duration(days: 4)),
    );
    String friday = convertDateTimeToString(
      startOfWeek.add(const Duration(days: 5)),
    );
    String saturday = convertDateTimeToString(
      startOfWeek.add(const Duration(days: 6)),
    );

    return Consumer<ExpenseData>(
      builder:
          (context, value, child) => Column(
            children: [
              // week total
              Padding(
                padding: const EdgeInsets.all(25),
                child: Row(
                  children: [
                    Text(
                      "Week Total: ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Rs.${calculateWeekTotal(value, sunday, monday, tuesday, wednesday, thursday, friday, saturday)}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 200,
                child: BarGraph(
                  maxY: calculateMa(
                    value,
                    sunday,
                    monday,
                    tuesday,
                    wednesday,
                    thursday,
                    friday,
                    saturday,
                  ),
                  sunAmount: value.calculateDailyExpense()[sunday] ?? 0,
                  monAmount: value.calculateDailyExpense()[monday] ?? 0,
                  tueAmount: value.calculateDailyExpense()[tuesday] ?? 0,
                  wedAmount: value.calculateDailyExpense()[wednesday] ?? 0,
                  thuAmount: value.calculateDailyExpense()[thursday] ?? 0,
                  friAmount: value.calculateDailyExpense()[friday] ?? 0,
                  satAmount: value.calculateDailyExpense()[saturday] ?? 0,
                ),
              ),
            ],
          ),
    );
  }
}
