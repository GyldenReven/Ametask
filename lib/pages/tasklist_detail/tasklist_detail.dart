import 'package:ametask/models/tasklists_model.dart';
import 'package:flutter/material.dart';
import 'package:ametask/db/database.dart';
import 'package:path/path.dart';
import 'package:ametask/pages/home/widgets/tasklists_list.dart';

class DetailTasklist extends StatefulWidget {
  final int tasklistId;

  const DetailTasklist({
    Key? key,
    required this.tasklistId,
  }) : super(key: key);

  @override
  State<DetailTasklist> createState() => _DetailTasklistState.initState();
}

class _DetailTasklistState extends State<DetailTasklist> {
  late Tasklist tasklist;
  bool isLoading = false;

  _DetailTasklistState.initState();

  @override
  void initState() {
    super.initState();

    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);

    tasklist = await AmetaskDatabase.instance.readTasklist(widget.tasklistId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 100,
        color: Colors.purpleAccent,
        child: deleteButton(context),
        ),
      );
  }

  Widget deleteButton(BuildContext context) => IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          await AmetaskDatabase.instance.deleteTasklist(widget.tasklistId);

          Navigator.of(context).pop();
        },
      );
}
