import 'package:flutter/material.dart';

class CustomChip extends StatefulWidget {
  final String label;
  final Function onPressed;
  final bool setAvater;

  CustomChip({this.label, this.onPressed, this.setAvater = false});

  @override
  _CustomChipState createState() => _CustomChipState();
}

class _CustomChipState extends State<CustomChip> {
  bool isSelected = false;

  handleSelected() {
    setState(() {
      isSelected = !isSelected;
    });
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: InputChip(
        showCheckmark: true,
        selectedColor: Colors.green.shade400,
        label: Text(
          widget.label,
          style: TextStyle(color: Colors.white),
        ),
        labelPadding: const EdgeInsets.all(2.0),
        avatar: widget.setAvater
            ? CircleAvatar(
                backgroundColor: Colors.white70,
                child: Text(
                  widget.label[0].toUpperCase(),
                ),
              )
            : null,
        backgroundColor: Colors.blue.shade400,
        elevation: 6,
        shadowColor: Colors.grey[60],
        padding: EdgeInsets.all(6),
        selected: isSelected,
        onSelected: (value) => handleSelected(),
      ),
    );
  }
}
