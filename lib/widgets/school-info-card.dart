import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../constant.dart';

class SchoolInfoCard extends StatefulWidget {
  final TextEditingController schoolController;
  final TextEditingController graduationDateController;
  final String type;

  const SchoolInfoCard({
    this.schoolController,
    this.graduationDateController,
    this.type,
  });
  @override
  _SchoolInfoCardState createState() => _SchoolInfoCardState();
}

class _SchoolInfoCardState extends State<SchoolInfoCard> {
  DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    DateTime _underGradFinshedDate;
    return Column(
      children: [
        TypeAheadFormField(
          textFieldConfiguration: TextFieldConfiguration(
            controller: widget.schoolController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      widget.schoolController.text = '';
                    }),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                labelText: "School",
                hintText: "University,College,..."),
          ),
          onSuggestionSelected: (text) {
            setState(() {
              widget.schoolController.text = text;
            });
          },
          itemBuilder: (context, suggesion) {
            return ListTile(
              title: Text(suggesion),
            );
          },
          suggestionsCallback: (pattern) {
            if (pattern.isNotEmpty) {
              return getUniversity()
                  .where((university) => university.startsWith(
                        RegExp('^$pattern', caseSensitive: false),
                      ))
                  .toList();
            } else {
              return [];
            }
          },
          validator: (text) {
            if (text.isEmpty && widget.type == 'ug') {
              return '* Required Filed';
            }

            return null;
          },
          onSaved: (text) {
            setState(() {
              widget.schoolController.text = text;
            });
          },
        ),
        SizedBox(
          height: kPadding,
        ),
        TextFormField(
          //
          keyboardType: TextInputType.datetime,
          textInputAction: TextInputAction.next,
          controller: widget.graduationDateController,
          validator: (text) {
            if (text.isEmpty && widget.type == 'ug') {
              return '* Required Filed';
            }
            if (text.isNotEmpty) {
              try {
                int.parse(text);
              } catch (e) {
                return 'Invalid Format';
              }
            }

            if (widget.schoolController.text.isEmpty &&
                widget.graduationDateController.text.isNotEmpty) {
              return 'Please, enter the college name first';
            }

            return null;
          },
          decoration: InputDecoration(
              suffixIcon: Container(
                height: kPadding * 2,
                width: kPadding * 2,
                child: Padding(
                  padding: const EdgeInsets.only(right: kPadding),
                  child: GestureDetector(
                    child: Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).primaryColor,
                    ),
                    onTap: () async {
                      selectedDate = await showRoundedDatePicker(
                        context: context,
                        initialDatePickerMode: DatePickerMode.year,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year - 50),
                        lastDate: DateTime(DateTime.now().year + 1),
                        borderRadius: 15,
                      );
                      setState(() {
                        _underGradFinshedDate = selectedDate;
                        widget.graduationDateController.text =
                            '${_underGradFinshedDate.year}';
                      });
                    },
                  ),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              labelText: 'Graduation Year',
              hintText: 'Year',
              contentPadding: const EdgeInsets.all(kPadding)),
        ),
      ],
    );
  }
}
