import 'package:ametask/models/ametask_color.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomTaskslistBar extends StatefulWidget {

  const BottomTaskslistBar({super.key});

  @override
  State<BottomTaskslistBar> createState() => _BottomTaskslistBarState();
}

class _BottomTaskslistBarState extends State<BottomTaskslistBar> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      child: BottomAppBar(
        padding: const EdgeInsets.only(top: 5),
        color: AmetaskColors.bg3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [deleteAllFinishedButton(), finishAllButton(), hideFinishedButton()],
        ),
      ),
    );
  }

  Widget deleteAllFinishedButton() => Column(children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(FeatherIcons.trash2),
          style: ButtonStyle(
              foregroundColor: MaterialStateColor.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return AmetaskColors.main;
            }
            return AmetaskColors.white;
          })),
        ),
        Text("delete finished",
            style: GoogleFonts.poppins(
                color: AmetaskColors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500))
      ]);
  Widget finishAllButton() => Column(children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(FeatherIcons.checkSquare),
          style: ButtonStyle(
              foregroundColor: MaterialStateColor.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return AmetaskColors.main;
            }
            return AmetaskColors.white;
          })),
        ),
        Text("finish all",
            style: GoogleFonts.poppins(
                color: AmetaskColors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500))
      ]);
  Widget hideFinishedButton() => Column(children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(FeatherIcons.eyeOff),
          style: ButtonStyle(
              foregroundColor: MaterialStateColor.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return AmetaskColors.main;
            }
            return AmetaskColors.white;
          })),
        ),
        Text("hide finished",
            style: GoogleFonts.poppins(
                color: AmetaskColors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500))
      ]);
}
