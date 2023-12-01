import 'package:flutter/material.dart';
import 'package:ametask/pages/home/widgets/search.dart';
import 'package:ametask/pages/home/widgets/tasklists_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(children: [Search(), TasklistLists()]),
      ),
      backgroundColor: const Color(0xFF1c1c21),
      bottomNavigationBar: NavigationBar(),
    );
  }

  Widget NavigationBar() {
    return Container(
      child: Container(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            backgroundColor: const Color(0xFF26262c),
            selectedItemColor: const Color(0xFF9B71CF),
            selectedFontSize: 12,
            unselectedFontSize: 12,
            unselectedItemColor: Colors.grey.withOpacity(0.7),
            type: BottomNavigationBarType.fixed,
            items: [
              const BottomNavigationBarItem(
                label: 'home',
                icon: Icon(
                  Icons.home_rounded,
                  size: 50,
                ),
              ),
              BottomNavigationBarItem(
                label: "folders",
                icon: Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  child: const Icon(
                    Icons.folder_rounded,
                    size: 30,
                    color: Color(0xFFEFEFEF),
                  ),
                ),
              ),
              BottomNavigationBarItem(
                label: "example",
                icon: Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  child: const Icon(
                    Icons.more_horiz_rounded,
                    size: 30,
                    color: Color(0xFFEFEFEF),
                  ),
                ),
              ),
              BottomNavigationBarItem(
                label: "Settings",
                icon: Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  child: const Icon(
                    Icons.settings,
                    size: 30,
                    color: Color(0xFFEFEFEF),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
