import 'package:flutter/material.dart';

abstract class LoaderMixin {
  showHideLoaderHelper(BuildContext context, bool isLoading) {
    if (isLoading) {
      showLoader(context);
    } else {
      hideLoader(context);
    }
  }

  showLoader(BuildContext context) {
    if (context == null) return;
    return Future.delayed(Duration.zero, () {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return Container(
              width: 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            );
          });
    });
  }

  hideLoader(BuildContext context) {
    if (context != null) {
      Navigator.of(context).pop();
    }
  }
}
