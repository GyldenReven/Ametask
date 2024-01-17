import 'package:ametask/db/database.dart';
import 'package:ametask/models/ametask_color.dart';
import 'package:ametask/models/tasks_model.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ametask/pages/tasklist_detail/tasklist_detail.dart';
import 'package:ametask/models/tasklists_model.dart';

class BottomTaskslistBar extends StatefulWidget {
  final Function callback;
  final int tasklistId;
  final DetailTasklist father;

  const BottomTaskslistBar(
      {super.key,
      required this.tasklistId,
      required this.father,
      required this.callback});

  @override
  State<BottomTaskslistBar> createState() => _BottomTaskslistBarState();
}

class _BottomTaskslistBarState extends State<BottomTaskslistBar> {
  late bool isAllFinished;
  late bool isShowed;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    refreshBar();
  }

  refreshBar() async {
    setState(() => isLoading = true);
    Tasklist tasklist =
        await AmetaskDatabase.instance.readTasklist(widget.tasklistId);

    isShowed = tasklist.isShow;

    List<Task> tasks =
        await AmetaskDatabase.instance.readAllTasksFor(widget.tasklistId, true);
    for (Task task in tasks) {
      if (!task.finished) {
        setState(() {
          setState(() => isLoading = false);
          isAllFinished = false;
        });
        return;
      }
    }
    setState(() {
      isAllFinished = true;
    });
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      child: BottomAppBar(
        padding: const EdgeInsets.only(top: 5),
        color: AmetaskColors.bg3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            deleteAllFinishedButton(),
            finishAllButton(),
            hideFinishedButton()
          ],
        ),
      ),
    );
  }

  Widget deleteAllFinishedButton() => Column(children: [
        IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                    backgroundColor: AmetaskColors.bg3,
                    title: Text(
                      'Are tou sure you want to delete all finished tasks ?',
                      style: GoogleFonts.poppins(
                          color: AmetaskColors.white,
                          fontWeight: FontWeight.w400),
                    ),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(FeatherIcons.arrowLeft),
                          label: const Text("cancel"),
                          style: ButtonStyle(
                            textStyle: MaterialStatePropertyAll(
                                GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600)),
                            foregroundColor:
                                MaterialStateColor.resolveWith((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return AmetaskColors.darker;
                              }
                              return AmetaskColors.main;
                            }),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () async {
                            List<Task> tasks = await AmetaskDatabase.instance
                                .readAllTasksFor(widget.tasklistId, true);
                            for (Task task in tasks) {
                              if (task.finished) {
                                await AmetaskDatabase.instance
                                    .deleteTask(task.id!);
                              }
                              tasks = await AmetaskDatabase.instance
                                  .readAllTasksFor(tasks[0].idTasklist, true);
                              for (int i = 0; i < tasks.length; i++) {
                                await AmetaskDatabase.instance
                                    .updateTask(tasks[i].copy(position: i));
                              }
                            }
                            var currentContext = context;
                            Future.delayed(Duration.zero, () {
                              Navigator.of(currentContext).pop();
                            });
                          },
                          icon: const Icon(FeatherIcons.trash2),
                          label: const Text(
                            "delete",
                          ),
                          style: ButtonStyle(
                            textStyle: MaterialStatePropertyAll(
                                GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600)),
                            foregroundColor: MaterialStateColor.resolveWith(
                              (states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return AmetaskColors.white;
                                }
                                return AmetaskColors.lightGray;
                              },
                            ),
                            backgroundColor: MaterialStateColor.resolveWith(
                              (states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return AmetaskColors.red;
                                }
                                return AmetaskColors.transparentRed;
                              },
                            ),
                          ),
                        ),
                      ],
                    ))).whenComplete(() async {
              await widget.callback();
            });
          },
          icon: const Icon(FeatherIcons.trash2),
          style: ButtonStyle(
              foregroundColor: MaterialStateColor.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return AmetaskColors.main;
            }
            return AmetaskColors.white;
          })),
        ),
        Text("delete finished",
            style: GoogleFonts.poppins(
                color: AmetaskColors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500))
      ]);

  Widget finishAllButton() {
    return isLoading
        ? const CircularProgressIndicator()
        : Column(children: [
            IconButton(
              onPressed: () async {
                List<Task> tasks = await AmetaskDatabase.instance
                    .readAllTasksFor(widget.tasklistId, true);

                if (isAllFinished) {
                  for (Task task in tasks) {
                    if (task.finished) {
                      if (task.type == "checktask") {
                        await AmetaskDatabase.instance
                            .updateTask(task.copy(finished: false));
                      } else if (task.type == "numtask") {
                        await AmetaskDatabase.instance
                            .updateTask(task.copy(finished: false, doneNum: 0));
                      }
                    }
                  }
                } else {
                  for (Task task in tasks) {
                    if (!task.finished) {
                      if (task.type == "checktask") {
                        await AmetaskDatabase.instance
                            .updateTask(task.copy(finished: true));
                      } else if (task.type == "numtask") {
                        await AmetaskDatabase.instance.updateTask(
                            task.copy(finished: true, doneNum: task.toDoNum));
                      }
                    }
                  }
                }
                await widget.callback();
              },
              icon: Icon(isAllFinished
                  ? FeatherIcons.square
                  : FeatherIcons.checkSquare),
              style: ButtonStyle(
                  foregroundColor: MaterialStateColor.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return AmetaskColors.main;
                }
                return AmetaskColors.white;
              })),
            ),
            Text(isAllFinished ? "finish all" : "unfinish all",
                style: GoogleFonts.poppins(
                    color: AmetaskColors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500))
          ]);
  }

  Widget hideFinishedButton() => isLoading
      ? const CircularProgressIndicator()
      : Column(children: [
          IconButton(
            onPressed: () async {
              Tasklist tasklist = await AmetaskDatabase.instance
                  .readTasklist(widget.tasklistId);
              await AmetaskDatabase.instance
                  .updateTasklist(tasklist.copy(isShow: !tasklist.isShow));
                  print("hello");
              await widget.callback();
              print("hello2");
            },
            icon: Icon(isShowed ? FeatherIcons.eyeOff : FeatherIcons.eye),
            style: ButtonStyle(
                foregroundColor: MaterialStateColor.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return AmetaskColors.main;
              }
              return AmetaskColors.white;
            })),
          ),
          Text(isShowed ? "hide finished" : "show finished",
              style: GoogleFonts.poppins(
                  color: AmetaskColors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500))
        ]);
}
