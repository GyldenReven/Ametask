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
          bottom: 25,
        ),
        child: Stack(
          children: [
            TextField(
              cursorColor: const Color(0xFF9B72CF),
              style: const TextStyle(color: Colors.white70),
              decoration: InputDecoration(
                fillColor: const Color(0xFF2D2E2F),
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
                  Icons.search_outlined,
                  size: 30,
                  color: Colors.white70,
                ),
                hintText: "Search for a tasklist",
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.3),
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
                  color: const Color(0xFF9B72CF),
                ),
                child: const Icon(
                  Icons.manage_search,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
