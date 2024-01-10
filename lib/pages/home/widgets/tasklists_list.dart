import 'package:ametask/models/tasklists_model.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:ametask/db/database.dart';
import 'package:ametask/pages/tasklist_detail/tasklist_detail.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ametask/models/ametask_color.dart';

class TasklistLists extends StatefulWidget {
  const TasklistLists({super.key});

  @override
  State<TasklistLists> createState() => _TasklistListsState.initState();
}

class _TasklistListsState extends State<TasklistLists> {
  List<Tasklist> tasklists = [];
  bool isLoading = false;

  _TasklistListsState.initState();

  @override
  void initState() {
    super.initState();

    refreshTasklists();
  }

  @override
  void dispose() {
    AmetaskDatabase.instance.close();

    super.dispose();
  }

  Future refreshTasklists() async {
    setState(() => isLoading = true);

    tasklists = await AmetaskDatabase.instance.readAllTasklists();

    setState(() => isLoading = false);
  }

  Future addTasklist() async {
    setState(() {
      tasklists.add(Tasklist(
          idFolder: 0,
          name: '',
          color: "white",
          description: "",
          createDate: DateTime.now(),
          lastModifDate: DateTime.now(),
          tagsList: ["0"]));
    });

    Tasklist newTaskList =
        await AmetaskDatabase.instance.createTasklist(tasklists.last);

    refreshTasklists();

    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DetailTasklist(tasklistId: newTaskList.id!)));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Stack(
        children: [
          ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () async {
                await Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) =>
                            DetailTasklist(tasklistId: tasklists[index].id!)))
                    .whenComplete(() {
                  refreshTasklists();
                });
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: AmetaskColors.bg2,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                              color: AmetaskColors.discretLine1, width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x66000000),
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ]),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    bottom: 15,
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tasklists[index].name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              color: AmetaskColors.white,
                              fontSize: 20),
                        ),
                        Text(tasklists[index].description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: AmetaskColors.white,
                                fontSize: 16)),
                      ])),
            ),
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemCount: tasklists.length,
          ),
          Positioned(
            bottom: 15,
            right: 15,
            child: TextButton.icon(
              onPressed: addTasklist,
              icon: const Icon(FeatherIcons.plus),
              label: const Text("New Tasklist"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                  (states) {
                    if (states.contains(MaterialState.pressed)) {
                      return AmetaskColors.darker;
                    }
                    return AmetaskColors.main;
                  },
                ),
                foregroundColor: MaterialStateProperty.resolveWith(
                  (states) {
                    if (states.contains(MaterialState.pressed)) {
                      return AmetaskColors.lightGray;
                    }
                    return AmetaskColors.white;
                  },
                ),
                textStyle:
                    MaterialStatePropertyAll(GoogleFonts.poppins(fontSize: 20)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
