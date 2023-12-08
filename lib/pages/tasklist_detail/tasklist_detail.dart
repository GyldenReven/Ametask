import 'package:ametask/models/tasklists_model.dart';
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
  bool isLoading = false;

  _DetailTasklistState.initState();

  @override
  void initState() {
    super.initState();

    refreshTasklist();
  }

  Future refreshTasklist() async {
    setState(() => isLoading = true);

    tasklist = await AmetaskDatabase.instance.readTasklist(widget.tasklistId);

    setState(() => isLoading = false);
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
        actions: <Widget>[deleteButton(context)],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "Title :",
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                  ),),
                  TextFormField(
                    maxLines: null,
                    keyboardType: TextInputType.text,
                    initialValue: tasklist.name,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Color(0xFFFEFEFE),
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
                    onFieldSubmitted: (String value) => refreshTasklist(),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "Description :",
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                  ),),
                  TextFormField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    initialValue: tasklist.description,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Color(0xFFFEFEFE),
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
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "Tasks :",
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                  ),),
                  Divider(
                    height: 3,
                    color: Color(0xFF575B7B)
                  ),
                  TasksList(
                    tasklistId: widget.tasklistId,
                  ),
                ],
              ),
            ),
    );
  }

  Widget deleteButton(BuildContext context) => IconButton(
        icon: const Icon(FeatherIcons.trash2),
        color: const Color(0xFFFBFBFB),
        onPressed: () async {
          await AmetaskDatabase.instance.deleteTasklist(widget.tasklistId);

          Navigator.of(context).pop();
        },
      );
}
