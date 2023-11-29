import 'package:ametask/models/tasks_model.dart';
import 'package:flutter/material.dart';
import 'package:ametask/db/database.dart';

class TasksList extends StatefulWidget {
  final int tasklistId;
  const TasksList({super.key, required this.tasklistId});

  @override
  State<TasksList> createState() => _TasksListState.initState();
}

class _TasksListState extends State<TasksList> {
  List<Task> tasks = [];
  bool isLoading = false;

  _TasksListState.initState();

  @override
  void initState() {
    super.initState();

    refreshTasks();
  }

  Future refreshTasks() async {
    setState(() => isLoading = true);

    tasks = await AmetaskDatabase.instance.readAllTasksFor(widget.tasklistId);

    setState(() => isLoading = false);
  }

  Future addTask() async {
    setState(() {
      tasks.add(Task(
          idTasklist: widget.tasklistId,
          name: 'task',
          description: "",
          position: tasks.length,
          type: 'checklist',
          finished: false));
    });

    await AmetaskDatabase.instance.createTask(tasks.last);

    refreshTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Placeholder()));

                refreshTasks();
              },
              child: Row(children: [
                Container(
                  width: 35,
                  child: CheckboxListTile(
                    value: tasks[index].finished,
                    onChanged: (bool? value) async {
                      tasks[index] = tasks[index].copy(finished: value);
                      await AmetaskDatabase.instance.updateTask(tasks[index]);
                      refreshTasks();
                    },
                  ),
                ),
                Container(
                  width: 300,
                  child: TextFormField(
                    initialValue: tasks[index].name,
                    style: const TextStyle(
                      color: Color(0xFFFEFEFE),
                      fontSize: 20,
                    ),
                    onFieldSubmitted: (String? value) async {
                      tasks[index] = tasks[index].copy(name: value);
                      await AmetaskDatabase.instance.updateTask(tasks[index]);
                      refreshTasks();
                    },
                  ),
                ),
              ]),
            ),
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemCount: tasks.length,
          ),
          Positioned(
            bottom: 15,
            right: 15,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xFF9B72CF),
              ),
              child: IconButton(
                  onPressed: addTask,
                  icon: const Icon(Icons.add, color: Color(0xFFFEFEFE))),
            ),
          ),
        ],
      ),
    );
  }
}
