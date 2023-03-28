import 'package:expense_tracker/data/hive_database.dart';
import 'package:expense_tracker/data_time/date_time_helper.dart';
import 'package:flutter/widgets.dart';

import '../modules/expense_item.dart';

class ExpenseData extends ChangeNotifier {
  //list of all Expenses
  List<ExpenseItem> overallExpensesList = [];

  //get expenses list
  List<ExpenseItem> getAllExpenseList() {
    return overallExpensesList;
  }

  //prepare data to display

  final db = HiveDataBase();

  void prepareData() {
    if (db.readData().isNotEmpty) {
      overallExpensesList = db.readData();
    }
  }

  //add new expenses

  void addNewExpense(ExpenseItem newExpense) {
    overallExpensesList.add(newExpense);

    notifyListeners();
    db.saveData(overallExpensesList);
  }

  //delete Expenses

  void deleteExpense(ExpenseItem expense) {
    overallExpensesList.remove(expense);
    notifyListeners();
    db.saveData(overallExpensesList);
  }

//get weekend (mon,tues,etc) from a dataTime object

  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'wed';
      case 4:
        return 'thu';
      case 5:
        return 'fri';
      case 6:
        return 'sat';
      case 7:
        return 'sun';
      default:
        return ' ';
    }
  }

//get the date for the start of the week (sunday)

  DateTime startofWeekDate() {
    DateTime? startofWeek;

    //get todays date
    DateTime today = DateTime.now();

    //go backward from today to find sunday

    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'sun') {
        startofWeek = today.subtract(Duration(days: i));
      }
    }
    return startofWeek!;
  }

  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {};

    for (var expense in overallExpensesList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      } else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }
    return dailyExpenseSummary;
  }
}
