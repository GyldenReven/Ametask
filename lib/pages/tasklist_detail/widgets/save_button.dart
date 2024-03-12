import 'package:ametask/models/ametask_color.dart';
import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';

class SaveButton extends StatelessWidget {
  final Function callback;
  const SaveButton({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(FeatherIcons.check),
      color: AmetaskColors.white,
      onPressed: () => callback(),
    );
  }
}
