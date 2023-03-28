import 'package:expense_tracker/component/expense_summary.dart';
import 'package:expense_tracker/component/expense_title.dart';
import 'package:expense_tracker/data/expense_data.dart';
import 'package:expense_tracker/data_time/date_time_helper.dart';
import 'package:expense_tracker/modules/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();

  @override
  void initState(){
    super.initState();

    // prepare data on startup
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }


  void addNewExpense() {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text('Add New Expense'),
      content:Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //expense name
          TextField(
            controller: newExpenseNameController,
            decoration: const InputDecoration(
              hintText: "Expenses Name",
            ),
          ),


          //expense amount

          TextField(
            controller: newExpenseAmountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Enter Amount",
            ),
          ),



        ],
      ) ,

      actions: [
        //save button
        MaterialButton(onPressed: save,
        child: Text('save'),),

        //cancle Button

        MaterialButton(onPressed: cancle,
        child: Text('cancle'),),
      ],
    ));

  }



  //delete Expense

  void deleteExpense(ExpenseItem expense){
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }






  void save(){

    if(newExpenseNameController.text.isNotEmpty && newExpenseAmountController.text.isNotEmpty){
      ExpenseItem newExpense = ExpenseItem(
        name: newExpenseNameController.text,
        amount: newExpenseAmountController.text,
        dateTime: DateTime.now(),);

      Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);
    }
    
    // ExpenseItem newExpense = ExpenseItem(
    //     name: newExpenseNameController.text,
    //     amount: newExpenseAmountController.text,
    //     dateTime: DateTime.now(),);
    //
    // Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);

    Navigator.pop(context);
    clear();

  }

  void cancle(){
    Navigator.pop(context);
    clear();


  }

  //clear controller

  void clear(){
    newExpenseNameController.clear();
    newExpenseAmountController.clear();
  }





  @override
  Widget build(BuildContext context) {

    return Consumer<ExpenseData>(builder: (context,value,child)=>
    Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: FloatingActionButton(
        onPressed: addNewExpense,
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
      ),

      body: ListView(
        children: [
        //weekly summary

        ExpenseSummary(startofWeek: value.startofWeekDate()),


        //expense list
        ListView.builder(
          shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: value.getAllExpenseList().length,
            itemBuilder: (context,index) => ExpenseTile(
                name: value.getAllExpenseList()[index].name,
                amount: value.getAllExpenseList()[index].amount,
                dateTime: value.getAllExpenseList()[index].dateTime,
                deleteTapped: (p0)=> deleteExpense(value.getAllExpenseList()[index]),
            )
        ),
      ],
      )

    ),
    );
  }
}
