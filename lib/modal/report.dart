import 'package:flutter/material.dart';

class Report {
  final String id;
  final String label;
  final Icon icon;
  Report({this.id, this.label, this.icon});
}

class Reports {
  List<Report> _reports = [
    Report(id: '1', label: 'Spam', icon: Icon(Icons.delete)),
    Report(id: '2', label: 'Violence', icon: Icon(Icons.sports_kabaddi)),
    Report(id: '3', label: 'Child Abuse', icon: Icon(Icons.child_care)),
    Report(id: '4', label: 'Pornography', icon: Icon(Icons.do_disturb_rounded)),
    Report(id: '5', label: 'Other', icon: Icon(Icons.report))
  ];

  List<Report> get reports {
    return [..._reports];
  }

  Report getReportById(String id) {
    return _reports.firstWhere((report) => report.id == id);
  }
}
