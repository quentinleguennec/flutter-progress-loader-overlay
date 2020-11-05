import 'package:flutter/material.dart';
import 'package:progress_loader_overlay/progress_loader_overlay.dart';

/// This simple loader use an [AnimationController] to show a black overlay with opacity fading in and out,
/// with a spinner in the middle.
class SimpleProgressLoaderWidget extends StatefulWidget {
  final ProgressLoaderWidgetController controller;

  const SimpleProgressLoaderWidget(
    this.controller, {
    Key key,
  }) : super(key: key);

  @override
  _SimpleProgressLoaderWidgetState createState() => _SimpleProgressLoaderWidgetState();
}

class _SimpleProgressLoaderWidgetState extends State<SimpleProgressLoaderWidget> with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    /// Attach a callback to be called when [ProgressLoader.dismiss] is called.
    /// The function can be synchronous or asynchronous. With the later, the [ProgressLoader] will wait until
    /// the future completes before switching to the dismissed state.
    /// If no callback is given, or if the callback is synchronous, this widget will be disposed as soon as
    /// [ProgressLoader.dismiss] is called.
    widget.controller?.attach(dismiss);

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )
      ..addListener(
        () {
          if (mounted) setState(() {});
        },
      )
      ..forward();
    super.initState();
  }

  @override
  void dispose() {
    /// Don't forget to detach when this widget is disposed to avoid memory leaks.
    widget.controller?.detach();
    animationController?.dispose();
    super.dispose();
  }

  Future<void> dismiss() => animationController.reverse();

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: animationController.value,
        child: Container(
          color: Colors.black.withOpacity(0.3),
          child: Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.orange,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
        ),
      );
}
