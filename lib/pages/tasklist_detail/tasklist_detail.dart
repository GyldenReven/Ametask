import 'package:ametask/models/ametask_color.dart';
import 'package:ametask/models/tasklists_model.dart';
import 'package:ametask/pages/task_detail/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:ametask/db/database.dart';
import 'package:ametask/pages/tasklist_detail/widgets/tasks_list.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailTasklist extends StatefulWidget {
  final int tasklistId;

  const DetailTasklist({
    Key? key,
    required this.tasklistId,
  }) : super(key: key);

  @override
  State<DetailTasklist> createState() => _DetailTasklistState.initState();
}

class _DetailTasklistState extends State<DetailTasklist> {
  late Tasklist tasklist;
  late int numTasks;
  late int numTasksRemaining;
  bool isLoading = false;

  _DetailTasklistState.initState();

  @override
  void initState() {
    super.initState();

    refreshTasklist();
  }

  goBack() {
    Navigator.of(context).pop();
  }

  Future refreshTasklist() async {
    setState(() => isLoading = true);

    tasklist = await AmetaskDatabase.instance.readTasklist(widget.tasklistId);
    numTasks =
        await AmetaskDatabase.instance.countAllTasksFor(widget.tasklistId);
    numTasksRemaining = numTasks -
        await AmetaskDatabase.instance
            .countAllFinishedTasksFor(widget.tasklistId);

    setState(() => isLoading = false);
  }

  modifTasklist() {
    tasklist = tasklist.copy(lastModifDate: DateTime.now());
    AmetaskDatabase.instance.updateTasklist(tasklist);
    refreshTasklist();
  }

  String createDateToString() {
    return "${tasklist.createDate.day}"
        "/${tasklist.createDate.month}"
        "/${tasklist.createDate.year.toString().substring(2)}"
        " at ${tasklist.createDate.hour}"
        ":${tasklist.createDate.minute}";
  }

  String modifDateToString() {
    return "${tasklist.lastModifDate.day}"
        "/${tasklist.lastModifDate.month}"
        "/${tasklist.lastModifDate.year.toString().substring(2)}"
        " at ${tasklist.lastModifDate.hour}"
        ":${tasklist.lastModifDate.minute}";
  }

  String percentageFinished() {
    try {
      int percent = (((numTasks - numTasksRemaining) / numTasks) * 100).round();
      return '$percent%';
    } catch (e) {
      return '0%';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF383E6E),
      appBar: AppBar(
        title: Text(
          isLoading ? "loading..." : tasklist.name,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2C3158),
        foregroundColor: const Color(0xFFFBFBFB),
        actions: <Widget>[
          infoButton(),
          deleteButton(context),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(
                    "Title :",
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    maxLines: null,
                    keyboardType: TextInputType.text,
                    initialValue: tasklist.name,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: const Color(0xFFFEFEFE),
                    ),
                    decoration: InputDecoration(
                      fillColor: const Color(0xFF2C3158),
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
                      hintText: "Title of the tasklist",
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    //controller: TextEditingController(),
                    onChanged: (String value) async {
                      tasklist = tasklist.copy(name: value);

                      await AmetaskDatabase.instance.updateTasklist(tasklist);
                    },
                    onFieldSubmitted: (String value) => modifTasklist(),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(
                    "Description :",
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: TextFormField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    initialValue: tasklist.description,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: const Color(0xFFFEFEFE),
                    ),
                    decoration: InputDecoration(
                      fillColor: const Color(0xFF2C3158),
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
                      hintText: "Desciption of the tasklist",
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    onChanged: (String value) async {
                      tasklist = tasklist.copy(description: value);

                      await AmetaskDatabase.instance.updateTasklist(tasklist);
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(
                    "Tasks :",
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const Divider(height: 3, color: AmetaskColors.discretLine2),
                TasksList(
                  tasklist: tasklist,
                ),
                BottomTaskslistBar(tasklistId: widget.tasklistId, father: widget, callback: refreshTasklist)
              ],
            ),
    );
  }

  Widget deleteButton(BuildContext context) => IconButton(
        icon: const Icon(FeatherIcons.trash2),
        color: const Color(0xFFFBFBFB),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    backgroundColor: const Color(0xFF2B3259),
                    title: Text(
                      'Are you sure you want to delete this tasklist ?',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          style: ButtonStyle(
                            foregroundColor: MaterialStateColor.resolveWith(
                                (states) => AmetaskColors.accent),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(FeatherIcons.arrowLeft),
                          label: const Text("Go back"),
                        ),
                        TextButton.icon(
                          style: ButtonStyle(
                            foregroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.red),
                          ),
                          onPressed: () async {
                            await AmetaskDatabase.instance
                                .deleteTasklist(tasklist.id!);
                            goBack();
                            goBack();
                          },
                          icon: const Icon(FeatherIcons.trash2),
                          label: const Text("Delete"),
                        ),
                      ],
                    ),
                  ));
        },
      );

  Widget infoButton() => IconButton(
      icon: const Icon(FeatherIcons.info),
      color: const Color(0xFFFBFBFB),
      onPressed: () async {
        await refreshTasklist();
        infoAlert();
      });
  infoAlert() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: const Color(0xFF2B3259),
        title: Text(
          'Statistiques',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        content: SizedBox(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Created on :',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, color: Colors.white70),
                  ),
                  Text(
                    createDateToString(),
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700, color: Colors.white),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Modified on :',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, color: Colors.white70),
                  ),
                  Text(
                    modifDateToString(),
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700, color: Colors.white),
                  )
                ],
              ),
              const Divider(color: Colors.white60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Number total of task :',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, color: Colors.white70),
                  ),
                  Text(
                    numTasks.toString(),
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700, color: Colors.white),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Number of remaining :',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, color: Colors.white70),
                  ),
                  Text(
                    numTasksRemaining.toString(),
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700, color: Colors.white),
                  )
                ],
              ),
              const Divider(color: Colors.white60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'global progression :',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, color: Colors.white70),
                  ),
                  Text(
                    percentageFinished(),
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700, color: Colors.white),
                  )
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: Text(
              'OK',
              style: GoogleFonts.poppins(
                  color: AmetaskColors.main, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}