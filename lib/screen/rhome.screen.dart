import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/constant.dart';
import '/provider/AuthProvider.dart';
import '/screen/Post/post-screen.dart';
import '/screen/chat/chat-page.dart';
import '/screen/chat/rooms-page.dart';
import '/screen/chat/users-page.dart';
import '/screen/chats-screen.dart';
import '/screen/home-page.dart';
import 'settings.dart';
import '/screen/home-page.dart';
import '/screen/notification-screen.dart';
import '/screen/post-create-screen.dart';
import '/services/notification_services.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class RealHomeScreen extends StatefulWidget {
  static const String screenName = '/rhome-screen';
  @override
  _RealHomeScreenState createState() => _RealHomeScreenState();
}

class _RealHomeScreenState extends State<RealHomeScreen> {
  List<Widget> _pages = [
    HomePage(),
    Rooms(),
    NotificationScreen(),
    Settings(),
  ];
  PageController controller =
      PageController(viewportFraction: 1, keepPage: false);
  int _currentIndex = 0;

  void nextPage() async {
    await controller.nextPage(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  void prevPage() async {
    await controller.previousPage(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPadding),
        child: _buildCarousel(context),
      ),
      floatingActionButton: _buildFAB(),
      bottomNavigationBar: SalomonBottomBar(
          unselectedItemColor: Theme.of(context).primaryColor,
          itemPadding: const EdgeInsets.symmetric(
              horizontal: kPadding * 0.5, vertical: 10),
          currentIndex: _currentIndex,
          onTap: (i) {
            controller.jumpToPage(i);
            setState(() {
              _currentIndex = i;
            });
          },
          items: [
            SalomonBottomBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              selectedColor: Theme.of(context).accentColor,
            ),
            SalomonBottomBarItem(
              icon: Icon(FontAwesomeIcons.facebookMessenger),
              title: Text('Chat'),
              selectedColor: Theme.of(context).accentColor,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.notifications),
              title: Text('Notfification'),
              selectedColor: Theme.of(context).accentColor,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.settings),
              title: Text('Setting'),
              selectedColor: Theme.of(context).accentColor,
            ),
          ]),
    );
  }

  Widget _buildCarousel(BuildContext context) {
    return PageView.builder(
      physics: NeverScrollableScrollPhysics(),
      controller: controller,
      scrollDirection: Axis.horizontal,
      onPageChanged: (val) {
        // print('Value $val');
        setState(() {
          _currentIndex = val.ceil();
        });
      },
      itemBuilder: (BuildContext context, int itemIndex) {
        return _buildItem(context, itemIndex);
      },
      itemCount: 4,
    );
  }

  FloatingActionButton _buildFAB() {
    if (_currentIndex == 0) {
      return FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, PostScreen.screenName),
        child: Icon(Icons.edit),
      );
    } else if (_currentIndex == 1) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, UsersPage.screenName);
        },
        child: Icon(Icons.message),
      );
    } else
      return null;
  }

  Widget _buildItem(BuildContext context, int itemIndex) {
    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dx < 0) {
          nextPage();
        }
        if (details.delta.dx > 0) {
          prevPage();
        }
      },
      child: _pages[itemIndex],
    );
  }
}
