//Widget typeToShow(BuildContext context) =>

import 'package:ametask/models/tasks_model.dart';
import 'package:flutter/material.dart';
import 'package:ametask/db/database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ametask/models/ametask_color.dart';

class ShowType extends StatelessWidget {
  final Task task;
  final Function callback;
  const ShowType({super.key, required this.task, required this.callback});

  @override
  Widget build(BuildContext context) {
    return task.type == "checktask"
        ? Align(
            alignment: Alignment.topCenter,
            child: Container(
                width: 200,
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                  border:
                      Border.all(width: 2, color: AmetaskColors.discretLine1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Finished ?",
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      Checkbox(
                          activeColor: const Color(0xFF9B71CF),
                          value: task.finished,
                          onChanged: (bool? value) async {
                            Task newTask = task.copy(finished: value);
                            await AmetaskDatabase.instance.updateTask(newTask);
                            callback();
                          },
                          side: BorderSide.none,
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return Colors.orange.withOpacity(.32);
                            } else if (task.finished) {
                              return const Color(0xFF9B71CF);
                            }
                            return const Color(0xFF3F4678);
                          })),
                    ])))
        : Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: AmetaskColors.discretLine1),
              borderRadius: BorderRadius.circular(20),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  "Repetition :",
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                const VerticalDivider(),
                Flexible(
                  flex: 1,
                  child: TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    initialValue: task.toDoNum.toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: AmetaskColors.white,
                        fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      fillColor: const Color(0xFF222645),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    //controller: TextEditingController(),
                    onFieldSubmitted: (String value) async {
                      if (value == "") {
                        value = "0";
                      }
                      if (int.parse(value) <= task.doneNum!) {
                        Task newTask = task.copy(
                            toDoNum: int.parse(value), finished: true);
                        await AmetaskDatabase.instance.updateTask(newTask);
                      } else {
                        Task newTask = task.copy(
                            toDoNum: int.parse(value), finished: false);
                        await AmetaskDatabase.instance.updateTask(newTask);
                      }
                    },
                  ),
                ),
              ]),
              const Divider(
                color: AmetaskColors.discretLine1,
                thickness: 2,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  "Done :",
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                const VerticalDivider(
                  width: 60,
                ),
                Flexible(
                  flex: 1,
                  child: TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    initialValue: task.doneNum.toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: AmetaskColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      fillColor: const Color(0xFF222645),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    //controller: TextEditingController(),
                    onFieldSubmitted: (String value) async {
                      if (value == "") {
                        value = "0";
                      }

                      if (int.parse(value) >= task.toDoNum!) {
                        Task newTask = task.copy(
                            doneNum: int.parse(value), finished: true);
                        await AmetaskDatabase.instance.updateTask(newTask);
                      } else {
                        Task newTask = task.copy(
                            doneNum: int.parse(value), finished: false);
                        await AmetaskDatabase.instance.updateTask(newTask);
                      }
                    },
                  ),
                ),
              ])
            ]));
  }
}
