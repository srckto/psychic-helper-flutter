import 'package:flutter/material.dart';
import 'package:psychic_helper/components/custom_text.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    Key? key,
    required this.title,
    this.subTitle,
    required this.textOfAccept,
    required this.textOfCancel,
    required this.onAccept,
    required this.onCancel,
  }) : super(key: key);
  final String title;
  final String? subTitle;
  final String textOfAccept;
  final void Function()? onAccept;
  final String textOfCancel;
  final void Function()? onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: CustomText(
        title,
        textAlign: TextAlign.start,
        color: Colors.black,
      ),
      content: subTitle == null ? null: CustomText(
        subTitle!,
        textAlign: TextAlign.start,
        color: Colors.black,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      actions: [
        TextButton(
          onPressed: onAccept,

          child: Text(
            textOfAccept,
          ),
        ),
        TextButton(
          onPressed: onCancel,
          child: CustomText(textOfCancel),
        ),
      ],
    );
  }
}
