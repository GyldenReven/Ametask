import 'package:ametask/models/ametask_color.dart';
import 'package:ametask/pages/task_detail/widgets/task_priority.dart';
import 'package:ametask/pages/task_detail/widgets/type_to_show.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:ametask/models/tasks_model.dart';
import 'package:ametask/db/database.dart';
import 'package:ametask/models/tasklists_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ametask/pages/task_detail/widgets/delete_button.dart';
import 'package:ametask/pages/task_detail/widgets/popup_task_type.dart';

class TaskDetail extends StatefulWidget {
  final int taskId;

  const TaskDetail({
    super.key,
    required this.taskId,
  });

  @override
  State<TaskDetail> createState() => _TaskDetailState.initState();
}

class _TaskDetailState extends State<TaskDetail> {
  bool isLoading = false;
  late Task task;
  late Tasklist fromTasklist;
  late String shortTlName;

  _TaskDetailState.initState();

  @override
  void initState() {
    super.initState();

    refreshTask();
  }

  Future refreshTask() async {
    setState(() => isLoading = true);

    task = await AmetaskDatabase.instance.readTask(widget.taskId);
    fromTasklist = await AmetaskDatabase.instance.readTasklist(task.idTasklist);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: AmetaskColors.bg1,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [backButton(context), DeleteTButton(task: task)],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "Title :",
                      style: GoogleFonts.poppins(
                          color: AmetaskColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  TextFormField(
                    maxLines: null,
                    keyboardType: TextInputType.text,
                    initialValue: task.name,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: AmetaskColors.white,
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
                      hintText: "Title of the task",
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: AmetaskColors.white.withOpacity(0.3),
                      ),
                    ),
                    //controller: TextEditingController(),
                    onChanged: (String value) async {
                      task = task.copy(name: value);

                      await AmetaskDatabase.instance.updateTask(task);
                    },
                    onFieldSubmitted: (String value) => refreshTask(),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "Description :",
                      style: GoogleFonts.poppins(
                          color: AmetaskColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  TextFormField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    initialValue: task.description,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: AmetaskColors.white,
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
                      hintText: "Desciption of the task",
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    onChanged: (String value) async {
                      task = task.copy(description: value);

                      await AmetaskDatabase.instance.updateTask(task);
                    },
                  ),
                  const Divider(
                    color: AmetaskColors.invisible,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PriorityChanger(task: task),
                      const VerticalDivider(
                        width: 20,
                        thickness: 1,
                        indent: 20,
                        endIndent: 15,
                        color: AmetaskColors.grey,
                      ),
                      TextButton.icon(
                        style: ButtonStyle(
                          iconSize:
                              MaterialStateProperty.resolveWith((states) => 30),
                          textStyle: MaterialStateProperty.resolveWith(
                              (states) => GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600, fontSize: 20)),
                          foregroundColor:
                              MaterialStateColor.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return AmetaskColors.main;
                            }
                            return AmetaskColors.accent;
                          }),
                        ),
                        icon: const Icon(FeatherIcons.tool),
                        label: const Text("type"),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              backgroundColor: AmetaskColors.bg1,
                              title: Text(
                                'What type of tasklist do you want ?',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AmetaskColors.white,
                                ),
                              ),
                              content: PopUpType(
                                task: task,
                                callback: refreshTask,
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                  ShowType(task: task),
                ],
              ),
            ),
    );
  }

  Widget backButton(BuildContext context) => IconButton(
        icon: const Icon(FeatherIcons.arrowLeft),
        color: AmetaskColors.white,
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
}
