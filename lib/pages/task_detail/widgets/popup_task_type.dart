import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:ametask/models/ametask_color.dart';
import 'package:ametask/db/database.dart';
import 'package:ametask/models/tasks_model.dart';

class PopUpType extends StatelessWidget {
  final Task task;
  final Function callback;
  const PopUpType({super.key, required this.task, required this.callback});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton.icon(
                  style: ButtonStyle(
                    iconSize: MaterialStateProperty.resolveWith((states) => 30),
                    textStyle: MaterialStateProperty.resolveWith((states) =>
                        GoogleFonts.poppins(
                            fontWeight: FontWeight.w500, fontSize: 20)),
                    foregroundColor: MaterialStateColor.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return AmetaskColors.main;
                      }
                      return AmetaskColors.accent;
                    }),
                  ),
                  onPressed: () async {
                    Task newTask = task.copy(type: "checktask");

                    await AmetaskDatabase.instance.updateTask(newTask);

                    await callback();

                    var currentContext = context;
                    Future.delayed(Duration.zero, () {
                      Navigator.of(currentContext).pop();
                    });
                  },
                  icon: const Icon(FeatherIcons.checkSquare),
                  label: const Text("Check task"),
                ),
                TextButton.icon(
                  style: ButtonStyle(
                    iconSize: MaterialStateProperty.resolveWith((states) => 30),
                    textStyle: MaterialStateProperty.resolveWith((states) =>
                        GoogleFonts.poppins(
                            fontWeight: FontWeight.w500, fontSize: 20)),
                    foregroundColor: MaterialStateColor.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return AmetaskColors.main;
                      }
                      return AmetaskColors.accent;
                    }),
                  ),
                  onPressed: () async {
                    Task newTask = task.copy(type: "numtask");

                    if (task.toDoNum == null) {
                      newTask = task.copy(doneNum: 0, toDoNum: 0);
                    }

                    await AmetaskDatabase.instance.updateTask(newTask);

                    await callback();

                    var currentContext = context;
                    Future.delayed(Duration.zero, () {
                      Navigator.of(currentContext).pop();
                    });
                  },
                  icon: const Icon(FeatherIcons.hash),
                  label: const Text("Num task"),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: TextButton.icon(
              style: ButtonStyle(
                iconSize: MaterialStateProperty.resolveWith((states) => 20),
                textStyle: MaterialStateProperty.resolveWith((states) =>
                    GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, fontSize: 15)),
                foregroundColor: MaterialStateColor.resolveWith((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return AmetaskColors.darker;
                  }
                  return AmetaskColors.main;
                }),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(FeatherIcons.arrowLeft),
              label: const Text("Go back"),
            ),
          ),
        ],
      ),
    );
  }
}
