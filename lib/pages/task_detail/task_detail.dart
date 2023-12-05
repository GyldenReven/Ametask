import 'package:flutter/material.dart';
import 'package:ametask/models/tasks_model.dart';
import 'package:ametask/db/database.dart';
import 'package:ametask/models/tasklists_model.dart';

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
  late Tasklist fromTasklist;
  late String shortTlName;

  _TaskDetailState.initState();

  @override
  void initState() {
    super.initState();

    refreshTask();
  }

  Future refreshTask() async {
    setState(() => isLoading = true);

    task = await AmetaskDatabase.instance.readTask(widget.taskId);
    fromTasklist = await AmetaskDatabase.instance.readTasklist(task.idTasklist);
    if (fromTasklist.name.length > 13) {
      shortTlName = fromTasklist.name.substring(0, 11) + "...";
    } else {
      shortTlName = fromTasklist.name;
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: const Color(0xFF2C3158),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  child: TextFormField(
                    maxLines: null,
                    keyboardType: TextInputType.text,
                    initialValue: task.name,
                    style: const TextStyle(
                      fontSize: 25,
                      color: Color(0xFFFEFEFE),
                    ),
                    //controller: TextEditingController(),
                    onChanged: (String value) async {
                      task = task.copy(name: value);

                      await AmetaskDatabase.instance.updateTask(task);
                    },
                    onFieldSubmitted: (String value) => refreshTask(),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  child: TextFormField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    initialValue: task.description,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFFFEFEFE),
                    ),
                    //controller: TextEditingController(),
                    onChanged: (String value) async {
                      task = task.copy(description: value);

                      await AmetaskDatabase.instance.updateTask(task);
                    },
                  ),
                ),
                Container(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 5),
                          width: 40,
                          child: CheckboxListTile(
                            checkboxSemanticLabel: 'done ?',
                            value: task.finished,
                            onChanged: (bool? value) async {
                              task = task.copy(finished: value);
                              await AmetaskDatabase.instance.updateTask(task);
                              refreshTask();
                            },
                          ),
                        ),
                        const Text(
                          "done ?",
                          style:
                              TextStyle(color: Color(0xFFFEFEFE), fontSize: 20),
                        ),
                      ],
                    )),
              ],
            ),
    );
  }

  Widget deleteButton(BuildContext context) => IconButton(
        icon: const Icon(Icons.delete),
        color: const Color(0xFFFEFEFE),
        onPressed: () async {
          await AmetaskDatabase.instance.deleteTask(widget.taskId);

          Navigator.of(context).pop();
        },
      );
}
