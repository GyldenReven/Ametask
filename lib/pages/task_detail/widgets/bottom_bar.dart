import 'package:ametask/db/database.dart';
import 'package:ametask/models/ametask_color.dart';
import 'package:ametask/models/tasks_model.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ametask/pages/tasklist_detail/tasklist_detail.dart';

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
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
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
                      'Are tou sure you want to delete all tasklist ?',
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
                              })),
                        ),
                        TextButton.icon(
                          onPressed: () async {
                            List<Task> tasks = await AmetaskDatabase.instance
                                .readAllTasksFor(widget.tasklistId);
                            for (Task task in tasks) {
                              if (task.finished) {
                                await AmetaskDatabase.instance
                                    .deleteTask(task.id!);
                              }
                            }
                            await widget.callback();
                            //widget.father.super.refreshTask();
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(FeatherIcons.trash2),
                          label: const Text(
                            "delete all",
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
                    )));
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

  Widget finishAllButton() => Column(children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(FeatherIcons.checkSquare),
          style: ButtonStyle(
              foregroundColor: MaterialStateColor.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return AmetaskColors.main;
            }
            return AmetaskColors.white;
          })),
        ),
        Text("finish all",
            style: GoogleFonts.poppins(
                color: AmetaskColors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500))
      ]);

  Widget hideFinishedButton() => Column(children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(FeatherIcons.eyeOff),
          style: ButtonStyle(
              foregroundColor: MaterialStateColor.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return AmetaskColors.main;
            }
            return AmetaskColors.white;
          })),
        ),
        Text("hide finished",
            style: GoogleFonts.poppins(
                color: AmetaskColors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500))
      ]);
}
