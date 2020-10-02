import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class MessagesMixin {
  final ScaffoldGlobalKey = GlobalKey<ScaffoldState>();

  showSnackBarMessage({
    @required String message,
    BuildContext context,
    GlobalKey<ScaffoldState> key,
    Color color = Colors.red,
  }) =>
      _showSnackBar(context: context, color: color, message: message, key: key);

  void _showSnackBar({
    BuildContext context,
    String message,
    GlobalKey<ScaffoldState> key,
    Color color,
  }) {
    final snackbar = SnackBar(backgroundColor: color, content: Text(message));

    if (key != null) {
      key.currentState.showSnackBar(snackbar);
    } else {
      Scaffold.of(context).showSnackBar(snackbar);
    }
  }
}
