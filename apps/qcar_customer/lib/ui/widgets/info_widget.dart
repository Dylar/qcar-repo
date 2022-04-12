import 'package:flutter/material.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 4,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      ),
    );
  }
}
