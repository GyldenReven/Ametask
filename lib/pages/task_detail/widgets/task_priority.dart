import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ametask/models/ametask_color.dart';
import 'package:ametask/db/database.dart';
import 'package:ametask/models/tasks_model.dart';

class PriorityChanger extends StatelessWidget {
  final Task task;
  const PriorityChanger({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(
          "priority :",
          style: GoogleFonts.poppins(
              color: AmetaskColors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 20),
        width: 70,
        child: TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.number,
          initialValue: (task.position + 1).toString(),
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              fontSize: 18,
              color: AmetaskColors.white,
              fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            fillColor: AmetaskColors.bg3,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            hintStyle: TextStyle(
              fontSize: 14,
              color: AmetaskColors.white.withOpacity(0.3),
            ),
          ),
          //controller: TextEditingController(),
          onFieldSubmitted: (String value) async {
            List<Task> friendsTasks =
                await AmetaskDatabase.instance.readAllTasksFor(task.idTasklist);
            int newPos;
            int oldPos = task.position;
            if (value == "") {
              newPos = friendsTasks.length - 1;
            } else {
              newPos = int.parse(value) - 1;
              if (newPos < 0) {
                newPos = 0;
              }
              if (newPos > friendsTasks.length) {
                newPos = friendsTasks.length - 1;
              }
            }
            if (newPos > oldPos) {
              for (var friend in friendsTasks) {
                if (friend.position >= oldPos && friend.position <= newPos) {
                  await AmetaskDatabase.instance
                      .updateTask(friend.copy(position: friend.position - 1));
                }
              }
            } else if (newPos < oldPos) {
              for (var friend in friendsTasks) {
                if (friend.position <= oldPos && friend.position >= newPos) {
                  await AmetaskDatabase.instance
                      .updateTask(friend.copy(position: friend.position + 1));
                }
              }
            }
            Task newTask = task.copy(position: newPos);
            await AmetaskDatabase.instance.updateTask(newTask);
          },
        ),
      ),
    ]);
  }
}
