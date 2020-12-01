import 'package:comma/services/firebase_services.dart';
import 'package:comma/tabs/home_tab.dart';
import 'package:comma/tabs/saved_tab.dart';
import 'package:comma/tabs/search_tab.dart';
import 'package:comma/widgets/bottom_tabs.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  FirebaseServices _firebaseServices = FirebaseServices();

  PageController _tabsPageController;
  int _selectedTab = 0;

  @override
  void initState() {
    
    _tabsPageController = PageController();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _tabsPageController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          child: Expanded(
            child: PageView(
              controller: _tabsPageController,
              onPageChanged: (num) {
                setState(() {
                  _selectedTab = num;
                });
              },
              children: <Widget>[
                HomeTab(),
                SearchTab(),
                SavedTab(),
              ],
            ),
          ),
        ),
        BottomTabs(
          selectedTab: _selectedTab,
          tabPressed: (num) {
            _tabsPageController.animateToPage(num,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInCubic);
          },
        ),
      ],
    ));
  }
}
