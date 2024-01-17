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
                  TextFormField(
                    minLines: 1,
                    maxLines: 3,
                    keyboardType: TextInputType.text,
                    initialValue: task.name,
                    style: GoogleFonts.poppins(
                      fontSize: 23,
                      color: AmetaskColors.white,
                      fontWeight: FontWeight.w500,
                    ),
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
                      hintText: "Title",
                      hintStyle: GoogleFonts.poppins(
                      fontSize: 23,
                      color: AmetaskColors.white.withOpacity(0.3),
                      fontWeight: FontWeight.w500,
                    ),
                    ),
                    //controller: TextEditingController(),
                    onChanged: (String value) async {
                      task = task.copy(name: value);

                      await AmetaskDatabase.instance.updateTask(task);
                    },
                    onFieldSubmitted: (String value) => refreshTask(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 8,
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        hintText: "Desciption",
                        hintStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        color: AmetaskColors.white.withOpacity(0.3),
                      ),
                      ),
                      onChanged: (String value) async {
                        task = task.copy(description: value);
                          await AmetaskDatabase.instance.updateTask(task);
                      },
                    ),
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
                              ),
                            ),
                          ).whenComplete(() => refreshTask());
                        },
                      )
                    ],
                  ),
                  ShowType(task: task, callback: refreshTask),
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
