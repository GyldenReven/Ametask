import 'package:ametask/models/tasklists_model.dart';
import 'package:flutter/material.dart';
import 'package:ametask/db/database.dart';
import 'package:flutter/services.dart';

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
          children: [
            Column(
              children: tasklists
                  .map(
                    (tasklist) => Container(
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Color(0xFF2D2E2F),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Text(
                            tasklist.name,
                            style: TextStyle(
                              color: Color(0xFFEFEFEF),
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
            Positioned(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color(0xFF9B72CF),
                ),
                child: IconButton(
                    onPressed: addTasklist,
                    icon: const Icon(Icons.add, color: Color(0xFFFEFEFE))),
              ),
              top: 0,
              right: 0,
            )
          ],
        ));
  }
}
