import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  final String url;
  final String fullName;
  final double radius;
  final Function onTap;

  const ProfilePicture(
      {Key key, this.url, this.fullName, this.radius, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
          backgroundColor: Colors.blue,
          backgroundImage: url != null
              ? url.isNotEmpty
                  ? CachedNetworkImageProvider(url)
                  : null
              : null,
          radius: radius,
          child: url == null
              ? Text(
                  fullName.isEmpty ? '' : fullName[0].toUpperCase(),
                  style: TextStyle(color: Colors.white, fontSize: radius),
                )
              : url.isEmpty
                  ? Text(
                      fullName.isEmpty ? '' : fullName[0].toUpperCase(),
                      style: TextStyle(color: Colors.white, fontSize: radius),
                    )
                  : null),
    );
  }
}
