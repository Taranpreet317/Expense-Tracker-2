import 'package:flutter/material.dart';

class ExpenseTile extends StatelessWidget {
  final String name;
  final String amount;
  final DateTime dateTime;
  final void Function()? onDelete;  

  const ExpenseTile({
    super.key,
    required this.name,
    required this.amount,
    required this.dateTime,
    this.onDelete,  
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('${name}_${dateTime.millisecondsSinceEpoch}'),  // Unique key
      direction: DismissDirection.endToStart,  // Swipe right to left only
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
      ),
      onDismissed: (direction) {
        onDelete?.call();  // Call the delete function
      },
      child: ListTile(
        title: Text(name),
        subtitle: Text('${dateTime.day}/${dateTime.month}/${dateTime.year}'),
        trailing: Text('Rs. $amount'),
      ),
    );
  }
}