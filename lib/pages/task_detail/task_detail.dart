import 'package:flutter/material.dart';
import 'package:ametask/models/tasks_model.dart';
import 'package:ametask/db/database.dart';

class TaskDetail extends StatefulWidget {
  final int taskId;

  const TaskDetail({
    super.key,
    required this.taskId,
  });

  @override
  State<TaskDetail> createState() => _TaskDetailState.initState();
}

class _TaskDetailState extends State<TaskDetail> {
  bool isLoading = false;
  late Task task;

  _TaskDetailState.initState();

  @override
  void initState() {
    super.initState();

    refreshTasklists();
  }

  Future refreshTasklists() async {
    setState(() => isLoading = true);

    task = await AmetaskDatabase.instance.readTask(widget.taskId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2D2E2F),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 5,
                        left: 15,
                        right: 15,
                      ),
                      child: TextFormField(
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        initialValue: task.name,
                        style: TextStyle(
                          fontSize: 25,
                          color: Color(0xFFFEFEFE),
                        ),
                        //controller: TextEditingController(),
                        onChanged: (String value) async {
                          task = task.copy(name: value);

                          await AmetaskDatabase.instance.updateTask(task);
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 10,
                      child: deleteButton(context),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget deleteButton(BuildContext context) => IconButton(
        icon: const Icon(Icons.delete),
        color: Color(0xFFFEFEFE),
        onPressed: () async {
          await AmetaskDatabase.instance.deleteTask(widget.taskId);

          Navigator.of(context).pop();
        },
      );
}
