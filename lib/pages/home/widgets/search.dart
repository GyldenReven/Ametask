import 'package:ametask/models/ametask_color.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 0,
      
      child: Container(
        padding: EdgeInsets.only(
          left: 25,
          right: 25,
          top: MediaQuery.of(context).padding.top + 25,
        ),
        child: Stack(
          children: [
            TextField(
              cursorColor: AmetaskColors.main,
              style: const TextStyle(color: AmetaskColors.white),
              decoration: InputDecoration(
                fillColor: AmetaskColors.bg2,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                prefixIcon: const Icon(
                  FeatherIcons.search,
                  size: 30,
                  color: AmetaskColors.white,
                ),
                hintText: "Search for a tasklist",
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: AmetaskColors.white.withOpacity(0.3),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 12,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AmetaskColors.main,
                ),
                child: const Icon(
                  FeatherIcons.filter,
                  color: AmetaskColors.white,
                  size: 33,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
