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
      backgroundColor: const Color(0xFF2D2E2F),
      appBar: AppBar(
        title: Text(isLoading ? "loading..." : tasklist.name),
        backgroundColor: const Color(0xFF202020),
        foregroundColor: const Color(0xFFFBFBFB),
        actions: <Widget>[deleteButton(context)],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  child: TextFormField(
                    maxLines: null,
                    keyboardType: TextInputType.text,
                    initialValue: tasklist.name,
                    style: const TextStyle(
                      fontSize: 25,
                      color: Color(0xFFFEFEFE),
                    ),
                    //controller: TextEditingController(),
                    onChanged: (String value) async {
                      tasklist = tasklist.copy(name: value);

                      await AmetaskDatabase.instance.updateTasklist(tasklist);
                    },
                    onFieldSubmitted: (String value) => refreshTasklist(),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  child: TextFormField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    initialValue: tasklist.description,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFFFEFEFE),
                    ),
                    onChanged: (String value) async {
                      tasklist = tasklist.copy(description: value);

                      await AmetaskDatabase.instance.updateTasklist(tasklist);
                    },
                  ),
                ),
                TasksList(
                  tasklistId: widget.tasklistId,
                ),
              ],
            ),
    );
  }

  Widget deleteButton(BuildContext context) => IconButton(
        icon: const Icon(Icons.delete),
        color: const Color(0xFFFBFBFB),
        onPressed: () async {
          await AmetaskDatabase.instance.deleteTasklist(widget.tasklistId);

          Navigator.of(context).pop();
        },
      );
}
