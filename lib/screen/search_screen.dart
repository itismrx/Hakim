import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/constant.dart';
import '/modal/case_modal.dart';
import '/provider/AuthProvider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _editingController = TextEditingController();
  Widget _body = Container();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  testSearch(String query) {
    print('\n\n$query\n\n');
    Widget body = StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cases')
            .doc(AuthProvider().getCurrentUser().uid)
            .collection('cases')
            .startAt([query]).endAt([query + '\uf8ff']).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text(
              snapshot.error.toString(),
            ));
          }
          if (snapshot.hasData) {
            if (snapshot.data.docs.isNotEmpty)
              print(snapshot.data.docs.first.id.toString());
            List<ListTile> lists = [];
            for (QueryDocumentSnapshot<Object> data in snapshot.data.docs) {
              lists.add(ListTile(title: Text(
                  // data.id,
                  CaseModal.fromDocument(data).caseTitle)));
            }
            return Container(
              child: Column(
                children: lists,
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        });

    setState(() {
      _body = body;
    });
  }

  handleSearch(query) {
    setState(() {
      _body = FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('cases')
            .where('caseDescription', arrayContainsAny: query)
            .get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Oops, something has gone wrong.',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          print(snapshot.data.docs
              .toList()
              .toString()); // if (snapshot.connectionState == ConnectionState.done) {
          //   print('Dont');
          //   if (snapshot.data.docs.isEmpty) {
          //     return Center(
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           RichText(
          //               text: TextSpan(children: [
          //             TextSpan(
          //               text: 'i couldn\'t find ',
          //               style: TextStyle(
          //                 color: Colors.grey,
          //                 fontSize: 18,
          //               ),
          //             ),
          //             TextSpan(
          //               text: '$query',
          //               style: TextStyle(
          //                 color: Colors.grey,
          //                 fontSize: 19,
          //                 fontWeight: FontWeight.bold,
          //               ),
          //             ),
          //           ])),
          //         ],
          //       ),
          //     );
          //   }
          //   if (snapshot.data.docs.isNotEmpty) {
          //     // List<ListTile> listText = [];
          //     // snapshot.data.docs.forEach((doc) {
          //     //   print('>>>>>>>');
          //     //   print(doc.data().toString());
          //     //   print('>>>>>');
          //     //   listText.add(ListTile(
          //     //     title: Text('Found'),
          //     //   ));
          //     // });
          //     // return Container(
          //     //   child: ListView(
          //     //     children: listText,
          //     //   ),
          //     // );
          //     return Text('Found');
          //   }
          // }
          return Text('Loading');
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(
            top: kPadding,
            right: kPadding,
          ),
          child: Column(
            children: [
              Container(
                child: Stack(
                  children: [
                    TextField(
                      controller: _editingController,
                      onSubmitted: (value) {
                        testSearch(_editingController.text);
                        print(value);
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search',
                          contentPadding: const EdgeInsets.all(kPadding),
                          prefixIcon: IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                            ),
                            onPressed: () => Navigator.pop(context),
                          )),
                    ),
                    Positioned(
                        right: 0,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              _editingController.text = '';
                            });
                          },
                          icon: Icon(Icons.cancel),
                        ))
                  ],
                ),
              ),
              Divider(),
              _body
            ],
          ),
        ),
      ),
    );
  }
}
