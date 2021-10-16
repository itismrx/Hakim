import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/constant.dart';
import '/widgets/custome_button.dart';

class UploadCard extends StatelessWidget {
  final String iconUrl;
  final Function onPressed;
  final Function onDelte;
  final bool isSelected;
  final bool isAsset;

  const UploadCard(
      {this.isAsset: true,
      this.iconUrl,
      this.onDelte,
      this.onPressed,
      this.isSelected});
  @override
  Widget build(BuildContext context) {
    print('\n>>>>>>>');
    print(iconUrl);
    print('\n>>>>>');
    return Expanded(
      child: Stack(
        children: [
          Stack(
            children: [
              Container(
                // width: 150,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: isAsset
                        ? AssetImage(
                            iconUrl,
                          )
                        : FileImage(File(iconUrl)),
                  ),
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              if (!isAsset)
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ),
                    onPressed: onDelte,
                  ),
                ),
            ],
          ),
          Positioned(
            left: kPadding * 3,
            bottom: 10,
            child: Column(
              children: [
                CustomeButton(
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Select image",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        isSelected
                            ? FontAwesomeIcons.checkCircle
                            : FontAwesomeIcons.fileUpload,
                        color: Colors.white,
                        size: 15,
                      )
                    ],
                  ),
                  onTap: onPressed,
                  width: kPadding * 10,
                  height: kPadding * 2,
                  backgourndColor:
                      Theme.of(context).accentColor.withAlpha(1000),
                  textColor: Colors.white,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
