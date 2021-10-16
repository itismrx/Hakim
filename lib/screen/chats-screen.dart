import 'package:flutter/material.dart';
import '/widgets/chat-card.dart';

import '../constant.dart';

class ChatScreen extends StatefulWidget {
  static const String screenName = '/chats-screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  _buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        // padding: EdgeInsets.all(4),
        child: CircleAvatar(
          foregroundImage: AssetImage('assets/images/pp.jpg'),
        ),
      ),
      title: Text(
        'Messages',
        style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontFamily: 'Roboto',
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w800),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding),
          child: IconButton(
              icon: Icon(Icons.search, color: Theme.of(context).primaryColor),
              onPressed: () {}),
        )
      ],
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            ChatCard(context: context),
            ChatCard(context: context),
            ChatCard(context: context),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }
}
