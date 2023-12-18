import 'package:ametask/models/ametask_color.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:ametask/models/tasks_model.dart';
import 'package:ametask/db/database.dart';
import 'package:ametask/models/tasklists_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ametask/pages/task_detail/widgets/delete_button.dart';

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
          color: Color(0xFF2C3158),
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
                          color: Colors.white,
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
                      hintText: "Title of the task",
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.3),
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
                          color: Colors.white,
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
                    color: Color(0x00000000),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "priority :",
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        width: 70,
                        child: TextFormField(
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          initialValue: (task.position + 1).toString(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: const Color(0xFFFEFEFE),
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
                            List<Task> friendsTasks = await AmetaskDatabase
                                .instance
                                .readAllTasksFor(task.idTasklist);
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
                                if (friend.position >= oldPos &&
                                    friend.position <= newPos) {
                                  await AmetaskDatabase.instance.updateTask(
                                      friend.copy(
                                          position: friend.position - 1));
                                }
                              }
                            } else if (newPos < oldPos) {
                              for (var friend in friendsTasks) {
                                if (friend.position <= oldPos &&
                                    friend.position >= newPos) {
                                  await AmetaskDatabase.instance.updateTask(
                                      friend.copy(
                                          position: friend.position + 1));
                                }
                              }
                            }

                            task = task.copy(position: newPos);

                            await AmetaskDatabase.instance.updateTask(task);
                          },
                        ),
                      ),
                      const VerticalDivider(
                        width: 20,
                        thickness: 1,
                        indent: 20,
                        endIndent: 15,
                        color: Colors.grey,
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
                                      color: Colors.white,
                                    ),
                                  ),
                                  content: popUpType(context)));
                        },
                      )
                    ],
                  ),
                  typeToShow(context),
                ],
              ),
            ),
    );
  }

  Widget backButton(BuildContext context) => IconButton(
        icon: const Icon(FeatherIcons.arrowLeft),
        color: const Color(0xFFFEFEFE),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );

  Widget typeToShow(BuildContext context) => task.type == "checktask"
      ? Align(
          alignment: Alignment.topCenter,
          child: Container(
              width: 200,
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: AmetaskColors.discretLine1),
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
                          task = task.copy(finished: value);
                          await AmetaskDatabase.instance.updateTask(task);
                          refreshTask();
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
                      task =
                          task.copy(toDoNum: int.parse(value), finished: true);
                    } else {
                      task =
                          task.copy(toDoNum: int.parse(value), finished: false);
                    }
                    await AmetaskDatabase.instance.updateTask(task);
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
                      task =
                          task.copy(doneNum: int.parse(value), finished: true);
                    } else {
                      task =
                          task.copy(doneNum: int.parse(value), finished: false);
                    }

                    await AmetaskDatabase.instance.updateTask(task);
                  },
                ),
              ),
            ])
          ]));

  Widget popUpType(BuildContext context) => SizedBox(
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
                    task = task.copy(type: "checktask");

                    await AmetaskDatabase.instance.updateTask(task);

                    await refreshTask();

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
                    task = task.copy(type: "numtask");

                    if (task.toDoNum == null) {
                      task = task.copy(doneNum: 0, toDoNum: 0);
                    }

                    await AmetaskDatabase.instance.updateTask(task);

                    await refreshTask();

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
      ));
}
