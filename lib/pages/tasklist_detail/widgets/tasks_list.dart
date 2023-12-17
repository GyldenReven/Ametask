import 'package:ametask/models/ametask_color.dart';
import 'package:ametask/models/tasklists_model.dart';
import 'package:ametask/models/tasks_model.dart';
import 'package:flutter/material.dart';
import 'package:ametask/db/database.dart';
import 'package:ametask/pages/task_detail/task_detail.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:feather_icons/feather_icons.dart';

class TasksList extends StatefulWidget {
  final Tasklist tasklist;
  const TasksList({super.key, required this.tasklist});

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

    tasks = await AmetaskDatabase.instance.readAllTasksFor(widget.tasklist.id!);

    setState(() => isLoading = false);
  }

  Future addTask() async {
    setState(() {
      tasks.add(Task(
          idTasklist: widget.tasklist.id!,
          name: '',
          description: '',
          position: tasks.length,
          type: 'checktask',
          finished: false));
    });

    Task newTask = await AmetaskDatabase.instance.createTask(tasks.last);
    refreshTasks();
    taskOpening(newTask);
  }

  taskOpening(newTask) {
    showModalBottomSheet(
        context: context,
        scrollControlDisabledMaxHeightRatio: double.infinity,
        builder: (BuildContext context) {
          return TaskDetail(taskId: newTask.id!);
        }).whenComplete(() {
      refreshTasks();
      AmetaskDatabase.instance
          .updateTasklist(widget.tasklist.copy(lastModifDate: DateTime.now()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: GestureDetector(
                onTap: () async {
                  showModalBottomSheet(
                      scrollControlDisabledMaxHeightRatio: double.infinity,
                      context: context,
                      builder: (BuildContext context) {
                        return TaskDetail(taskId: tasks[index].id!);
                      }).whenComplete(() {
                    refreshTasks();
                  });
                  refreshTasks();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFF2C3158),
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(children: [
                    // penser au stack + positioned !!!
                    validation(index),
                    Flexible(
                      flex: 1,
                      child: Text(
                        tasks[index].name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                            color: const Color(0xFFFEFEFE),
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
            separatorBuilder: (context, index) => Container(
              height: 0,
            ),
            itemCount: tasks.length,
          ),
          Positioned(
            bottom: 15,
            right: 15,
            child: TextButton.icon(
              onPressed: addTask,
              icon: const Icon(FeatherIcons.plus),
              label: const Text("New Task"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                  (states) {
                    if (states.contains(MaterialState.pressed)) {
                      return AmetaskColors.darker;
                    }
                    return AmetaskColors.main;
                  },
                ),
                foregroundColor: MaterialStateProperty.resolveWith(
                  (states) {
                    if (states.contains(MaterialState.pressed)) {
                      return AmetaskColors.lightGray;
                    }
                    return AmetaskColors.white;
                  },
                ),
                textStyle: MaterialStatePropertyAll(GoogleFonts.poppins(fontSize: 20)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget validation(int index) => tasks[index].type == "checktask"
      ? Container(
          padding: const EdgeInsets.only(left: 5),
          width: 40,
          child: Checkbox(
              activeColor: const Color(0xFF9B71CF),
              value: tasks[index].finished,
              onChanged: (bool? value) async {
                tasks[index] = tasks[index].copy(finished: value);
                await AmetaskDatabase.instance.updateTask(tasks[index]);

                await AmetaskDatabase.instance.updateTasklist(
                    widget.tasklist.copy(lastModifDate: DateTime.now()));

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
        )
      : Row(
          children: [
            Container(
              width: 40,
              padding: const EdgeInsets.only(left: 5),
              child: IconButton(
                iconSize: 20,
                style: ButtonStyle(
                    iconColor: MaterialStateColor.resolveWith((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return AmetaskColors.accent;
                  }
                  return Colors.white;
                })),
                icon: const Icon(
                  FeatherIcons.plusSquare,
                ),
                onPressed: () async {
                  int newValue = tasks[index].doneNum! + 1;

                  Task newTask = tasks[index].copy(doneNum: newValue);
                  if (newValue >= tasks[index].toDoNum!) {
                    newTask = newTask.copy(finished: true);
                  }

                  await AmetaskDatabase.instance.updateTask(newTask);
                  refreshTasks();
                },
              ),
            ),
            Text(tasks[index].doneNum.toString(),
                style: GoogleFonts.poppins(
                    color: const Color(0xFFFEFEFE),
                    fontSize: 20,
                    fontWeight: FontWeight.w600)),
            Text("/ ${tasks[index].toDoNum.toString()}",
                style: GoogleFonts.poppins(
                    color: const Color(0xFFCCCCCC),
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
            const VerticalDivider(
              width: 10,
            )
          ],
        );
}
