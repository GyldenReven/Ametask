import 'package:flutter/material.dart';
import 'package:ametask/pages/home/widgets/search.dart';
import 'package:ametask/pages/home/widgets/tasklists_list.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ametask/models/ametask_color.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(
      fontSize: 30, fontWeight: FontWeight.bold, color: AmetaskColors.white);

  static const List<Widget> _widgetOptions = <Widget>[
    Column(children: [Search(), TasklistLists()]),
    Center(
      child: Text(
        'Work in progress',
        style: optionStyle,
      ),
    ),
    Center(
      child: Text(
        'Work in progress',
        style: optionStyle,
      ),
    ),
    Center(
      child: Text(
        'Work in progress',
        style: optionStyle,
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      backgroundColor: AmetaskColors.bg1,
      bottomNavigationBar: navigationBar(),
    );
  }

  Widget navigationBar() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        backgroundColor: AmetaskColors.bg3,
        selectedItemColor: AmetaskColors.main,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        selectedIconTheme: const IconThemeData(size: 35),
        unselectedIconTheme: const IconThemeData(size: 30),
        selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w800),
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
              ),
            ),
          ),
          BottomNavigationBarItem(
            label: "folders",
            icon: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              child: const Icon(
                FeatherIcons.folder,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
