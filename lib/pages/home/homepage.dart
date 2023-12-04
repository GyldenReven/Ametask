import 'package:flutter/material.dart';
import 'package:ametask/pages/home/widgets/search.dart';
import 'package:ametask/pages/home/widgets/tasklists_list.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(children: [Search(), TasklistLists()]),
      ),
      backgroundColor: const Color(0xFF2C3158),
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
            backgroundColor: const Color(0xFF3F4678),
            selectedItemColor: const Color(0xFF9B71CF),
            selectedFontSize: 12,
            unselectedFontSize: 12,
            selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700),
            unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700),
            unselectedItemColor: const Color(0xFFFFFFFF),
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                label: 'home',
                icon: Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  child: const Icon(
                  FeatherIcons.home,
                  size: 50,
                ),),
              ),
              BottomNavigationBarItem(
                label: "folders",
                icon: Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  child: const Icon(
                    FeatherIcons.folder,
                    size: 50,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
              BottomNavigationBarItem(
                label: "example",
                icon: Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  child: const Icon(
                    FeatherIcons.moreHorizontal,
                    size: 50,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
              BottomNavigationBarItem(
                label: "Settings",
                icon: Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  child: const Icon(
                    FeatherIcons.settings,
                    size: 50,
                    color: Color(0xFFFFFFFF),
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
