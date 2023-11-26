import 'package:ametask/models/tasklists_model.dart';
import 'package:flutter/material.dart';
import 'package:ametask/db/database.dart';
import 'package:ametask/pages/tasklist_detail/tasklist_detail.dart';

class TasklistLists extends StatefulWidget {
  const TasklistLists({super.key});

  @override
  State<TasklistLists> createState() => _TasklistListsState.initState();
}

class _TasklistListsState extends State<TasklistLists> {
  List<Tasklist> tasklists = [
    Tasklist(
        idFolder: 0,
        name: 'Title',
        color: "white",
        createDate: DateTime.now(),
        lastModifDate: DateTime.now())
  ];
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
          name: 'Title',
          color: "white",
          createDate: DateTime.now(),
          lastModifDate: DateTime.now()));
    });

    await AmetaskDatabase.instance.createTasklist(tasklists.last);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) => GestureDetector(
                  onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DetailPage(tasklists[index]),
                        ),
                      ),
                  child: Container(
                    color: Color(0xFFFEFEFE),
                    height: 40,
                    child: Text(tasklists[index].name),
                  )),
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemCount: tasklists.length,
            ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xFF9B72CF),
              ),
              child: IconButton(
                  onPressed: addTasklist,
                  icon: const Icon(Icons.add, color: Color(0xFFFEFEFE))),
            ),
          ),
        ],
      ),
    );
  }
}
