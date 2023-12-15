import 'package:ametask/models/tasklists_model.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:ametask/db/database.dart';
import 'package:ametask/pages/tasklist_detail/tasklist_detail.dart';
import 'package:google_fonts/google_fonts.dart';

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
                  decoration: const BoxDecoration(
                    color: Color(0xFF383E6E),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
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
                              color: Colors.white,
                              fontSize: 20),
                        ),
                        Text(tasklists[index].description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 16)),
                      ])),
            ),
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemCount: tasklists.length,
          ),
          Positioned(
            bottom: 15,
            right: 15,
            child: GestureDetector(
              onTap: addTasklist,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color(0xFF9B72CF),
                ),
                padding: const EdgeInsetsDirectional.symmetric(
                    vertical: 8, horizontal: 10),
                child: Row(
                  children: [
                    Text(
                      'New Tasklist',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    const Icon(FeatherIcons.plus, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
