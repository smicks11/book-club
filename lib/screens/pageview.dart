import 'package:book_club/screens/curatedTimeTable.dart';
import 'package:book_club/screens/library.dart';
import 'package:book_club/screens/study.dart';
import 'package:book_club/shared/constants.dart';
import 'package:flutter/material.dart';

class PageViewScreen extends StatefulWidget {
  @override
  _PageViewScreenState createState() => _PageViewScreenState();
}

class _PageViewScreenState extends State<PageViewScreen> {
  var _selectedPageIndex;
  List<Widget> _pages;
  PageController _pageController;

  @override
  void initState() {
    super.initState();

    _selectedPageIndex = 0;

    
    _pages = [CuratedTimeTable(), Study(), Library()];

    _pageController = PageController(initialPage: _selectedPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();

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
        height: 100,
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home,),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books_sharp,),
              label: "Study",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books,),
              label: "Library",
            ),
           
          ],
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey.shade300,
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
