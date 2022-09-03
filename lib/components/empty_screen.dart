import 'package:flutter/material.dart';

import 'package:psychic_helper/components/custom_text.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({
    Key? key,
    this.message,
  }) : super(key: key);
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomText(message ?? " Empty Screen "),
    );
  }
}
