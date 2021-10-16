import 'package:flutter/material.dart';
import '/modal/case_modal.dart';
import '/provider/AuthProvider.dart';
import '/services/firestore_database.dart';
import '/widgets/post-card.dart';
import 'package:sliding_number/sliding_number.dart';
import '/widgets/follow_button.dart';

import '../constant.dart';

class StatusWidget extends StatefulWidget {
  final String uid;
  StatusWidget(this.uid);
  @override
  _StatusWidgetState createState() => _StatusWidgetState();
}

class _StatusWidgetState extends State<StatusWidget> {
  _reload() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.uid != AuthProvider().getCurrentUser().uid)
          FollowButton(userId: widget.uid, onPressed: _reload),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: kPadding,
            vertical: kPadding,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).accentColor
                ]),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  FutureBuilder(
                      future:
                          FirestoreDatabase(uid: widget.uid).numberOfCases(),
                      builder: (context, AsyncSnapshot<int> snapshot) {
                        if (snapshot.hasData &&
                            snapshot.connectionState == ConnectionState.done) {
                          return SlidingNumber(
                            number: snapshot.data,
                            style: TextStyle(color: Colors.white),
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.easeOutQuint,
                          );
                        }
                        return Text(
                          '0',
                          style: TextStyle(color: Colors.white),
                        );
                      }),
                  Text(
                    'Post',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              Column(
                children: [
                  FutureBuilder(
                      future: FirestoreDatabase(uid: widget.uid)
                          .numberOfFollowers(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('ERROR');
                        }
                        if (snapshot.connectionState == ConnectionState.done) {
                          return SlidingNumber(
                            number: snapshot.data,
                            style: TextStyle(color: Colors.white),
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.easeOutQuint,
                          );
                        }
                        return Container(
                          width: 3,
                          child: Text(
                            '0',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }),
                  Text(
                    'Follower',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              Column(
                children: [
                  FutureBuilder(
                      future: FirestoreDatabase(uid: widget.uid)
                          .numberOfFollowings(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('ERROR');
                        }
                        if (snapshot.connectionState == ConnectionState.done) {
                          return SlidingNumber(
                            number: snapshot.data,
                            style: TextStyle(color: Colors.white),
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.easeOutQuint,
                          );
                        }
                        return Container(
                          width: 3,
                          child: Text(
                            '0',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }),
                  Text(
                    'Following',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: kPadding,
        ),
        Divider(),
      ],
    );
  }
}
