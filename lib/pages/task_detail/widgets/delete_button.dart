import 'package:ametask/models/ametask_color.dart';
import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:ametask/db/database.dart';
import 'package:ametask/models/tasks_model.dart';

class DeleteTButton extends StatelessWidget {
  final Task task;
  const DeleteTButton({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(FeatherIcons.trash2),
      color: AmetaskColors.white,
      onPressed: () async {
        int taskPos = task.position;
        List<Task> friends =
            await AmetaskDatabase.instance.readAllTasksFor(task.idTasklist);
        await AmetaskDatabase.instance.deleteTask(task.id!);

        for (Task friend in friends) {
          if (friend.position > taskPos) {
            await AmetaskDatabase.instance
                .updateTask(friend.copy(position: friend.position - 1));
          }
        }

        var currentContext = context;
        Future.delayed(Duration.zero, () {
          Navigator.of(currentContext).pop();
        });
      },
    );
  }
}
