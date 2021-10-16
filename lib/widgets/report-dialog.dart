import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hakim_app/modal/case_modal.dart';
import 'package:hakim_app/provider/AuthProvider.dart';
import 'package:hakim_app/services/firestore_database.dart';
import '/constant.dart';
import '/modal/report.dart';

Future buildReportSheet(BuildContext context, CaseModal caseModal) {
  return showModalBottomSheet(
      context: context,
      builder: (ctx) {
        Size size = MediaQuery.of(context).size;
        return Container(
          height: size.height * 2 / 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          ),
          padding: EdgeInsets.symmetric(horizontal: kPadding),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: kPadding, top: kPadding),
                    child: Text(
                      'Report',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      child: Expanded(
                    child: ListView(
                        children: Reports()
                            .reports
                            .map((report) => ListTile(
                                  title: Text(report.label),
                                  leading: report.icon,
                                  onTap: () async {
                                    await FirestoreDatabase(
                                            uid: AuthProvider()
                                                .getCurrentUser()
                                                .uid)
                                        .addReport(caseModal.caseId,
                                            caseModal.ownerId, report.label);
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.black54,
                                        duration: Duration(seconds: 5),
                                        content: Row(
                                          children: [
                                            Icon(
                                              Icons.local_police,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'We have recevied your report.\nOur team will look into it.\nThank you For your cooperation.',
                                              softWrap: true,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ))
                            .toList()),
                  )),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    FontAwesomeIcons.times,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        );
      });
}
