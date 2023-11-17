import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class TasklistLists extends StatefulWidget {
  const TasklistLists({super.key});

  @override
  State<TasklistLists> createState() => _TasklistListsState();
}

class _TasklistListsState extends State<TasklistLists> {
  int _number = 10;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2000,
      color: Colors.purple,
      child: Column(children: [
        Text(_number.toString()),
        IconButton(
          onPressed: _AddOne,
          icon : Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ]),
    );
  }

  void _AddOne() {
    setState(() {
      _number ++;
    });
  }
}
