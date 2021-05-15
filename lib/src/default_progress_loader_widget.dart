part of 'progress_loader.dart';

/// This Default loader use an [AnimationController] to show a full-screen black overlay with opacity fading in and out,
/// with a spinner in the middle.
/// If the [ProgressLoader] widgetBuilder is not specified this widget will be used.
class _DefaultProgressLoaderWidget extends StatefulWidget {
  final ProgressLoaderWidgetController controller;

  const _DefaultProgressLoaderWidget(
    this.controller, {
    Key? key,
  }) : super(key: key);

  @override
  _DefaultProgressLoaderWidgetState createState() => _DefaultProgressLoaderWidgetState();
}

class _DefaultProgressLoaderWidgetState extends State<_DefaultProgressLoaderWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void initState() {
    widget.controller.attach(dismiss);

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )..forward();

    super.initState();
  }

  @override
  void dispose() {
    widget.controller.detach();
    animationController.dispose();
    super.dispose();
  }

  Future<void> dismiss() => animationController.reverse();

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: animationController,
        child: Container(
          color: Colors.black.withOpacity(0.3),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        builder: (context, child) => Opacity(
          opacity: animationController.value,
          child: child,
        ),
      );
}
