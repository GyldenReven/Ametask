import 'package:ametask/models/tasklists_model.dart';
import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ametask/models/ametask_color.dart';
import 'package:ametask/db/database.dart';

class InfoTLButton extends StatefulWidget {
  final int tasklistId;
  const InfoTLButton({super.key, required this.tasklistId});

  @override
  State<InfoTLButton> createState() => _InfoTLButtonState.initState();
}

class _InfoTLButtonState extends State<InfoTLButton> {
  late int numTasks;
  late int numTasksRemaining;
  late Tasklist tasklist;

  _InfoTLButtonState.initState();

  @override
  void initState() {
    super.initState();

    refreshTasklist();
  }

  refreshTasklist() async {
    tasklist = await AmetaskDatabase.instance.readTasklist(widget.tasklistId);
    numTasks =
        await AmetaskDatabase.instance.countAllTasksFor(widget.tasklistId);
    numTasksRemaining = numTasks -
        await AmetaskDatabase.instance
            .countAllFinishedTasksFor(widget.tasklistId);
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
    return IconButton(
        icon: const Icon(FeatherIcons.info),
        color: AmetaskColors.white,
        onPressed: () async {
          await refreshTasklist();
          infoAlert();
        });
  }

  infoAlert() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: AmetaskColors.bg1,
        title: Text(
          'Statistiques',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: AmetaskColors.white),
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
                        fontWeight: FontWeight.bold,
                        color: AmetaskColors.lightGray),
                  ),
                  Text(
                    createDateToString(),
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        color: AmetaskColors.white),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Modified on :',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: AmetaskColors.lightGray),
                  ),
                  Text(
                    modifDateToString(),
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        color: AmetaskColors.white),
                  )
                ],
              ),
              const Divider(color: AmetaskColors.discretLine2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Number total of task :',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: AmetaskColors.lightGray),
                  ),
                  Text(
                    numTasks.toString(),
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        color: AmetaskColors.white),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Number of remaining :',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: AmetaskColors.lightGray),
                  ),
                  Text(
                    numTasksRemaining.toString(),
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        color: AmetaskColors.white),
                  )
                ],
              ),
              const Divider(color: AmetaskColors.discretLine2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'global progression :',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: AmetaskColors.lightGray),
                  ),
                  Text(
                    percentageFinished(),
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        color: AmetaskColors.white),
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
