import 'package:ametask/models/tasklists_model.dart';
import 'package:flutter/material.dart';
import 'package:ametask/db/database.dart';

class TasklistLists extends StatefulWidget {
  const TasklistLists({super.key});

  @override
  State<TasklistLists> createState() => _TasklistListsState.initState();
}

class _TasklistListsState extends State<TasklistLists> {
  List<Tasklist> tasklists = [Tasklist(idFolder: 0, name: 'Title', color: "white", createDate: DateTime.now(), lastModifDate: DateTime.now())];
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
    setState(() {tasklists.add(Tasklist(idFolder: 0, name: 'Title', color: "white", createDate: DateTime.now(), lastModifDate: DateTime.now()));
    });

    await AmetaskDatabase.instance.createTasklist(tasklists.last);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(25),
        child: Stack(
          children: [
            Column(
              children: tasklists
                  .map(
                    (tasklist) => Container(
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tasklist.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 2),
                                        /* Etoille Review - Notation */
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              size: 15,
                                              color: Colors.amber,
                                            ),
                                            const Icon(
                                              Icons.star,
                                              size: 15,
                                              color: Colors.amber,
                                            ),
                                            const Icon(
                                              Icons.star,
                                              size: 15,
                                              color: Colors.amber,
                                            ),
                                            const Icon(
                                              Icons.star,
                                              size: 15,
                                              color: Colors.amber,
                                            ),
                                            Icon(
                                              Icons.star,
                                              size: 15,
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    /**  Bouton Install*/
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 15,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF5F67EA),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: const Text(
                                        'Install',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
            Container(
              height: 50,
              color: Colors.red,
              child: IconButton(onPressed: addTasklist, icon: const Icon(Icons.add)),
            )
          ],
        ));
  }
}
