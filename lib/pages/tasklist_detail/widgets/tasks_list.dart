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

    refreshTasklists();
  }

  Future refreshTasklists() async {
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
    
    refreshTasklists();
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

                refreshTasklists();
              },
              child: Container(
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFF2D2E2F),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                margin: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  bottom: 15,
                ),
                child: Text(
                  tasks[index].name,
                  style: const TextStyle(
                    color: Color(0xFFFEFEFE),
                    fontSize: 25,
                  ),
                ),
              ),
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
