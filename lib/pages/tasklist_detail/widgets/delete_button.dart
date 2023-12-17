import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ametask/models/ametask_color.dart';
import 'package:ametask/db/database.dart';

class DeleteTLButton extends StatelessWidget {
  final int tasklistId;
  final BuildContext context;
  const DeleteTLButton({super.key, required this.tasklistId, required this.context});

  goBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(FeatherIcons.trash2),
        color: const Color(0xFFFBFBFB),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    backgroundColor: const Color(0xFF2B3259),
                    title: Text(
                      'Are you sure you want to delete this tasklist ?',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          style: ButtonStyle(
                            foregroundColor: MaterialStateColor.resolveWith(
                                (states) => AmetaskColors.accent),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(FeatherIcons.arrowLeft),
                          label: const Text("Go back"),
                        ),
                        TextButton.icon(
                          style: ButtonStyle(
                            foregroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.red),
                          ),
                          onPressed: () async {
                            await AmetaskDatabase.instance
                                .deleteTasklist(tasklistId);
                            goBack();
                            goBack();
                          },
                          icon: const Icon(FeatherIcons.trash2),
                          label: const Text("Delete"),
                        ),
                      ],
                    ),
                  ));
        },
      );
  }
}