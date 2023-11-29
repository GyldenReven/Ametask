import 'package:ametask/models/tasklists_model.dart';
import 'package:flutter/material.dart';
import 'package:ametask/db/database.dart';
import 'package:ametask/pages/tasklist_detail/widgets/tasks_list.dart';

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

    refreshTasklists();
  }

  Future refreshTasklists() async {
    setState(() => isLoading = true);

    tasklist = await AmetaskDatabase.instance.readTasklist(widget.tasklistId);

    setState(() => isLoading = false);
  }

  Future renameTasklists() async {
    tasklist = tasklist.copy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2D2E2F),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 5,
                        left: 15,
                        right: 15,
                      ),
                      child: TextFormField(
                        initialValue: tasklist.name,
                        style: TextStyle(
                          fontSize: 25,
                          color: Color(0xFFFEFEFE),
                        ),
                        //controller: TextEditingController(),
                        onFieldSubmitted: (String value) async {
                          tasklist = tasklist.copy(name: value);

                          await AmetaskDatabase.instance
                              .updateTasklist(tasklist);
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 10,
                      child: deleteButton(context),
                    ),
                  ],
                ),
                TasksList(tasklistId: widget.tasklistId,)
              ],
            ),
    );
  }

  Widget deleteButton(BuildContext context) => IconButton(
        icon: const Icon(Icons.delete),
        color: Color(0xFFFEFEFE),
        onPressed: () async {
          await AmetaskDatabase.instance.deleteTasklist(widget.tasklistId);

          Navigator.of(context).pop();
        },
      );
}
