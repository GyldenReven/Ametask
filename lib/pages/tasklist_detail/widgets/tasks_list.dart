import 'package:ametask/models/tasks_model.dart';
import 'package:flutter/material.dart';
import 'package:ametask/db/database.dart';
import 'package:ametask/pages/task_detail/task_detail.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:feather_icons/feather_icons.dart';

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
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return TaskDetail(taskId: tasks[index].id!);
                    });
                refreshTasks();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFF2C3158),
                    borderRadius: BorderRadius.circular(15)),
                child: Row(children: [
                  // penser au stack + positioned !!!
                  Container(
                    padding: const EdgeInsets.only(left: 5),
                    width: 40,
                    child: Checkbox(
                        activeColor: const Color(0xFF9B71CF),
                        value: tasks[index].finished,
                        onChanged: (bool? value) async {
                          tasks[index] = tasks[index].copy(finished: value);
                          await AmetaskDatabase.instance
                              .updateTask(tasks[index]);
                          refreshTasks();
                        },
                        side: BorderSide.none,
                        fillColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Colors.orange.withOpacity(.32);
                          } else if (tasks[index].finished) {
                            return const Color(0xFF9B71CF);
                          }
                          return const Color(0xFF3F4678);
                        })),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 70,
                    child: Text(
                      tasks[index].name,
                      style: GoogleFonts.poppins(
                          color: Color(0xFFFEFEFE),
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ]),
              ),
            ),
            separatorBuilder: (context, index) => Container(
              height: 8,
            ),
            itemCount: tasks.length,
          ),
          Positioned(
            bottom: 15,
            right: 15,
            child: GestureDetector(
              onTap: addTask,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color(0xFF9B72CF),
                ),
                padding: const EdgeInsetsDirectional.symmetric(
                    vertical: 8, horizontal: 10),
                child: Row(
                  children: [
                    Text(
                      'New Task',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    const Icon(FeatherIcons.plus, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
