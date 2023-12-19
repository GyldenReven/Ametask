//Widget typeToShow(BuildContext context) =>

import 'package:ametask/models/tasks_model.dart';
import 'package:flutter/material.dart';
import 'package:ametask/db/database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ametask/models/ametask_color.dart';

class ShowType extends StatelessWidget {
  final Task task;
  const ShowType({super.key, required this.task});

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
                            color: AmetaskColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      Checkbox(
                          activeColor: AmetaskColors.main,
                          value: task.finished,
                          onChanged: (bool? value) async {
                            Task newTask = task.copy(finished: value);
                            await AmetaskDatabase.instance.updateTask(newTask);
                          },
                          side: BorderSide.none,
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return AmetaskColors.grey.withOpacity(.32);
                            } else if (task.finished) {
                              return AmetaskColors.main;
                            }
                            return AmetaskColors.bg2;
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
                      fillColor: AmetaskColors.bg3,
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
                        color: AmetaskColors.white.withOpacity(0.3),
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
                      color: AmetaskColors.white,
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
                      fillColor: AmetaskColors.bg3,
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
                        color: AmetaskColors.white.withOpacity(0.3),
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
