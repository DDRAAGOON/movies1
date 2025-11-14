import 'package:flutter/material.dart';
import 'package:movies1/home/utils/app_assets.dart';
import 'package:movies1/home/utils/app_colors.dart';
import 'package:movies1/screens/home/browse_tab.dart';
import 'package:movies1/screens/home/home_tab.dart';
import 'package:movies1/screens/home/profile_tab.dart';
import 'package:movies1/screens/home/search_tab.dart';

class HomeScreen extends StatefulWidget {
   const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
int selectedIndex = 0;
List<Widget> tabs =[
  HomeTab(),SearchTab(),BrowseTab(),ProfileTab()
];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      extendBody: true,
      bottomNavigationBar:
           Container(
             margin: EdgeInsets.all(15),
             height: 65,
            // margin: EdgeInsets.all(15),
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(16),
             ),
             child: ClipRRect(
               borderRadius: BorderRadius.circular(20),
               child: BottomNavigationBar(
                 onTap: (index) {
                   selectedIndex = index;
                   setState(() {

                   });
                 },
                 currentIndex: selectedIndex,
                 selectedFontSize: 0,
                 unselectedFontSize: 0,
                 showSelectedLabels: false,
                 showUnselectedLabels: false,
                 type: BottomNavigationBarType.fixed,
                 backgroundColor: AppColors.greyColor,
                  items: [
                   builtBottomNavBarItem(
                       index: 0,
                       selectedIconName: AppAssets.homeSelect,
                       unSelectedIconName: AppAssets.iconHome, label: ''),
                    builtBottomNavBarItem(
                        index: 1,
                        selectedIconName: AppAssets.searchSelect,
                        unSelectedIconName: AppAssets.iconSearch, label: ''),
                    builtBottomNavBarItem(
                        index: 2,
                        selectedIconName: AppAssets.browseSelect,
                        unSelectedIconName: AppAssets.iconBrowse, label: ''),
                    builtBottomNavBarItem(
                        index: 3,
                        selectedIconName: AppAssets.profileSelect,
                        unSelectedIconName: AppAssets.iconProfile, label: ''),

                  ],

                         ),
             ),
           ),
      body: tabs[selectedIndex],
    );
  }

  BottomNavigationBarItem builtBottomNavBarItem({required String selectedIconName,
    required String unSelectedIconName,required int index,
  required String label}){
    return BottomNavigationBarItem(icon: Image.asset(selectedIndex == index ? selectedIconName :
    unSelectedIconName),
    label: label);
  }
}
