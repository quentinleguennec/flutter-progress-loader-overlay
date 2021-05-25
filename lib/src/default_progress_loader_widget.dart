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
  _DefaultProgressLoaderWidgetState createState() =>
      _DefaultProgressLoaderWidgetState();
}

class _DefaultProgressLoaderWidgetState
    extends State<_DefaultProgressLoaderWidget>
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

  /// Important note:
  /// [AnimationController].reverse() does not return a [Future], it returns a [TickerFuture].
  /// And [TickerFuture] will not return (and will hang forever) in some cases,
  /// like if the [AnimationController] is dismissed before the [TickerFuture] completes for example.
  /// To avoid hanging the [ProgressLoader] we must use [TickerFuture].orCancel and catch any [TickerCanceled] exception.
  Future<void> dismiss() => animationController.reverse().orCancel.catchError(
        (Object _) {
          /// The error is a [TickerCanceled], just complete the future.
        },
        test: (error) => error is TickerCanceled,
      );

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
