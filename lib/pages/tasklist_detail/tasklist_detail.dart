import 'package:ametask/models/ametask_color.dart';
import 'package:ametask/models/tasklists_model.dart';
import 'package:ametask/pages/tasklist_detail/widgets/bottom_bar.dart';
import 'package:ametask/pages/tasklist_detail/widgets/delete_button.dart';
import 'package:ametask/pages/tasklist_detail/widgets/info_button.dart';
import 'package:flutter/material.dart';
import 'package:ametask/db/database.dart';
import 'package:ametask/pages/tasklist_detail/widgets/tasks_list.dart';
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
          InfoTLButton(
            tasklistId: widget.tasklistId,
          ),
          DeleteTLButton(
            tasklistId: widget.tasklistId,
            context: context,
          ),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                BottomTaskslistBar(
                    tasklistId: widget.tasklistId,
                    father: widget,
                    callback: refreshTasklist)
              ],
            ),
    );
  }
}
