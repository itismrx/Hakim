import 'package:flutter/material.dart';
import '/constant.dart';
import '/widgets/post-card.dart';
import '/widgets/shimmer_widget.dart';

class ShimmerCaseWidget extends StatelessWidget {
  const ShimmerCaseWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerPostHeader(),
        SizedBox(
          height: kPadding,
        ),
        ShimmerWidget.rectangular(
          height: kPadding,
        ),
        SizedBox(
          height: 5,
        ),
        ShimmerWidget.rectangular(
          height: kPadding,
        ),
        SizedBox(
          height: 5,
        ),
        ShimmerWidget.rectangular(
          height: kPadding,
          width: MediaQuery.of(context).size.width - 100,
        ),
        SizedBox(
          height: kPadding,
        ),
        ShimmerWidget.rectangular(
          height: 300,
        )
      ],
    );
  }
}
