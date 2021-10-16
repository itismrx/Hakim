import 'package:flutter/material.dart';
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hakim_app/provider/AuthProvider.dart';
import 'package:hakim_app/services/firestore_database.dart';
import 'package:hakim_app/utility.dart';
// import package:hakim_app/modal/message.dart';
// import package:hakim_app/screen/message-screen.dart';
import '../constant.dart';

class ChatCard extends StatelessWidget {
  final String ppUrl;
  final String displayName;
  final types.Room room;
  final String lastSeen;
  final String uid;
  final String roomId;
  final List<types.Message> lastMessages;
  final Function onTap;
  final Widget avater;
  final BuildContext context;
  // final Widget avater;
  const ChatCard(
      {this.lastSeen,
      this.uid,
      this.room,
      this.roomId,
      this.lastMessages,
      this.ppUrl,
      this.displayName,
      this.avater,
      @required this.context,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    // String value = '';
    // if (lastMessages.first.type == types.MessageType.text) {
    //   types.Message msg = lastMessages.first;

    // }
    // String msg = "";

    return Dismissible(
      key: ValueKey(this.uid),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        color: Theme.of(context).primaryColor.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.only(right: kPadding),
          child: Icon(
            Icons.delete,
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).accentColor.withOpacity(0.4),
      ),
      onDismissed: (dir) {
        print('\n>>>>>>');
        print('Deleted');
        print('\n>>>>>>');
        FirestoreDatabase(uid: AuthProvider().getCurrentUser().uid)
            .removeChat(roomId);
      },
      confirmDismiss: (direction) async {
        bool isConfirmed = false;
        await showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Row(
                  children: [
                    avater,
                    SizedBox(
                      width: kPadding,
                    ),
                    Text('Delete Chat'),
                  ],
                ),
                content: Text(
                    'Are you sure you want to delete the chat with Dr.Jane Doe?'),
                actions: [
                  TextButton(
                      onPressed: () {
                        isConfirmed = false;
                        Navigator.pop(ctx);
                      },
                      child: Text(
                        'CANCEL',
                        style: TextStyle(color: Colors.blue),
                      )),
                  TextButton(
                      onPressed: () {
                        isConfirmed = true;
                        Navigator.pop(ctx);
                      },
                      child: Text(
                        'DELETE CHAT',
                        style: TextStyle(color: Colors.red),
                      ))
                ],
              );
            });
        return isConfirmed;
      },
      child: Container(
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              onTap: onTap,
              leading: Stack(
                children: [
                  avater,
                ],
              ),
              title: Text(
                displayName,
                style: kNameTextStyle,
              ),
              subtitle: lastMessages != null
                  ? lastMessages.isNotEmpty
                      ? lastMessages.first.type == types.MessageType.text
                          ? FutureBuilder(
                              future: FirestoreDatabase(
                                      uid: AuthProvider().getCurrentUser().uid)
                                  .getMessage(room.id),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(snapshot.data.toString());
                                }
                                return Text('');
                              })
                          : Row(
                              children: [
                                if (lastMessages.first.type ==
                                    types.MessageType.file)
                                  Icon(
                                    FontAwesomeIcons.file,
                                    size: 10,
                                  ),
                                if (lastMessages.first.type ==
                                    types.MessageType.image)
                                  Icon(
                                    FontAwesomeIcons.image,
                                    size: 10,
                                  ),
                                if (lastMessages.first.type ==
                                    types.MessageType.custom)
                                  Icon(FontAwesomeIcons.figma),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(lastMessages.first.type
                                    .toString()
                                    .split('.')
                                    .last),
                              ],
                            )
                      // ? Text(room.lastMessages[0].author.firstName)
                      : Text('')
                  : Text(''),
              //TODO : ADD last Message
              // TODO : ADD DELIVERD FEATURE
              // TODO : ADD ACTIVE FEATURE
              // subtitle: lastMessages != null
              //     ? lastMessages.last.type == types.TextMessage
              //         ? Text(lastMessages[0].author.firstName,
              //             style: TextStyle(
              //               color: Colors.black,
              //             ))
              //         : null
              //     : null,
              trailing: Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10),
                  child: (lastMessages != null)
                      ? (lastMessages.isNotEmpty)
                          ? Column(
                              children: [
                                Text(
                                  calculateTimeDifferenceBetween(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          lastMessages.first.createdAt),
                                      DateTime.now()),
                                  style: TextStyle(fontSize: 10),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                if (lastMessages.first.status ==
                                    types.Status.seen)
                                  Icon(
                                    FontAwesomeIcons.checkDouble,
                                    size: 15,
                                  ),
                                if (lastMessages.first.status ==
                                    types.Status.delivered)
                                  Icon(
                                    FontAwesomeIcons.check,
                                    size: 15,
                                  ),
                                if (lastMessages.first.status ==
                                    types.Status.sending)
                                  Icon(
                                    Icons.more,
                                    size: 15,
                                  ),
                              ],
                            )
                          : null
                      : null),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
