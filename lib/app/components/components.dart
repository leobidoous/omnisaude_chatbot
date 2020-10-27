import 'package:flutter/material.dart';

OutlineInputBorder generalOutlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.0),
    borderSide: BorderSide(width: 0.0, color: Colors.transparent),
    gapPadding: 0.0,
  );
}

Widget iconButtonExit(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Theme.of(context).cardColor.withOpacity(0.2),
    ),
    child: IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Icon(Icons.close),
    ),
  );
}
