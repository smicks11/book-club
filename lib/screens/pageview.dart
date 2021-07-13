
import 'package:book_club/screens/Library/library.dart';
import 'package:book_club/screens/Study/study.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:book_club/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'Homescreen/curatedtimetable.dart';

class PageViewScreen extends StatefulWidget {
  @override
  _PageViewScreenState createState() => _PageViewScreenState();
}

class _PageViewScreenState extends State<PageViewScreen> with WidgetsBindingObserver{
  var _selectedPageIndex;
  List<Widget> _pages;
  PageController _pageController;
  // final DynamicLinkService _dynamicLinkService = DynamicLinkService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _selectedPageIndex = 0;
    _pages = [CuratedTimeTable(), Study(), Library()];
    _pageController = PageController(initialPage: _selectedPageIndex);
  }


  @override
  void dispose() {
    _pageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        //The following parameter is just to prevent
        //the user from swiping to the next page.
        physics: NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: Container(
        height: 110,
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon:  SvgPicture.asset('assets/svg/home.svg',),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/svg/study.svg',),
              label: "Study",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/svg/library.svg',),
              label: "Library",
            ),
           
          ],
          selectedItemColor: HexColor('1A43E7'),
          unselectedItemColor: HexColor('1c1c1c'),
          type: BottomNavigationBarType.fixed,
          // showSelectedLabels: true,
          // showUnselectedLabels: false,
          currentIndex: _selectedPageIndex,
          onTap: (selectedPageIndex) {
            setState(() {
              _selectedPageIndex = selectedPageIndex;
              _pageController.jumpToPage(selectedPageIndex);
            });
          },
        ),
      ),
    );
  }
}
