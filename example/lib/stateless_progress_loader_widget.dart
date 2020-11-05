import 'package:flutter/material.dart';

/// This simplistic loader shows a black overlay with opacity with a spinner in the middle.
class StatelessProgressLoaderWidget extends StatelessWidget {
  StatelessProgressLoaderWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.black.withOpacity(0.3),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
}
