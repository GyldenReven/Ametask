import 'package:ametask/models/tasks_model.dart';
import 'package:flutter/material.dart';
import 'package:ametask/db/database.dart';
import 'package:ametask/pages/task_detail/task_detail.dart';

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
          description: "description",
          position: tasks.length,
          type: 'checklist',
          finished: false));
    });

    Task newTask = await AmetaskDatabase.instance.createTask(tasks.last);

    refreshTasks();

    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TaskDetail(taskId: newTask.id!)));
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
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        TaskDetail(taskId: tasks[index].id!)));

                refreshTasks();
              },
              child: Container(
                child: Row(children: [
                  // penser au stack + positioned !!!
                  Container(
                    padding: EdgeInsets.only(left: 5),
                    width: 40,
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
                    width: MediaQuery.of(context).size.width - 50,
                    child: Text(
                      tasks[index].name,
                      style: const TextStyle(
                        color: Color(0xFFFEFEFE),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            separatorBuilder: (context, index) => Container(
              width: 10,
              height: 3,
              color: Color.fromARGB(26, 155, 155, 155),
            ),
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
