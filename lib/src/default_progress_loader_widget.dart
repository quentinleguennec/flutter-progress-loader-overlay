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
        child: Platform.isIOS ? _IOSLoader() : _StandardLoader(),
        builder: (context, child) => Opacity(
          opacity: animationController.value,
          child: child,
        ),
      );
}

class _StandardLoader extends StatelessWidget {
  const _StandardLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.black.withOpacity(0.3),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
}

/// NOTE: [PopScope] only recognize system back gestures. On iOS there is not consistency for back gestures,
/// and therefore there is no system back gesture. This can lead to issues if you create your own loader widget
/// and your widget is intercepting the swipe gesture. Check [_DefaultProgressLoaderWidget] in the code to
/// learn more about the issue and see the proposed work-around.
///
/// [PopScope] only recognize system back gestures. On iOS there is not consistency for back gestures,
/// and therefore there is no system back gesture.
/// This means that the standard left to right swipe to dismiss is actually always handled by developers at
/// the application level. Flutter implements it by default in [CupertinoRouteTransitionMixin].
/// But this means it is handled internally by looking at the users gesture, which means that if something is blocking
/// the swipe gesture then [CupertinoRouteTransitionMixin] never triggers the back navigation event.
/// In our case, the full screen [Container] in [_StandardLoader] is blocking all gestures, thus preventing back navigation
/// on iOS. This special widget leaves a small invisible vertical band on the edge of the screen to
/// allow [CupertinoRouteTransitionMixin] to detect the swipe gesture.
class _IOSLoader extends StatelessWidget {
  /// [_backGestureWidth] is the amount of space on the edge of the screen used to detect the swipe gesture.
  /// Using the same value Flutter uses internally (`_kBackGestureWidth = 20` found in Flutter's `route.dart`).
  /// NOTE: This respects text directionality and handles screen notches.
  /// NOTE: Since Flutter uses _kBackGestureWidth = 20 there is no point making [_backGestureWidth] bigger than 20.
  static final double _backGestureWidth = 20;

  const _IOSLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// This is inspired by Flutter's [_CupertinoBackGestureDetectorState] in the `route.dart` file.
    double dragAreaWidth = Directionality.of(context) == TextDirection.ltr
        ? MediaQuery.paddingOf(context).left
        : MediaQuery.paddingOf(context).right;
    dragAreaWidth = max(dragAreaWidth, _backGestureWidth);

    return Stack(
      children: [
        /// This black background will let all the gestures go through.
        IgnorePointer(
          child: Container(
            color: Colors.black.withOpacity(0.3),
          ),
        ),

        /// This will not let any gestures go through, and covers the whole screen excepts the small vertical band.
        PositionedDirectional(
          start: dragAreaWidth,
          end: 0.0,
          top: 0.0,
          bottom: 0.0,
          child: AbsorbPointer(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),

        /// This is the small vertical band. It allows the swipe back gesture to go through and prevents all the
        /// other gestures that do not interfere with the horizontal swipe gesture detection.
        /// In other words, this will prevent taps and vertical swipes to be detected on the page under the loader.
        PositionedDirectional(
          start: 0.0,
          width: dragAreaWidth,
          top: 0.0,
          bottom: 0.0,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTapDown: (_) {},
            onTapUp: (_) {},
            onTap: () {},
            onTapCancel: () {},
            onSecondaryTap: () {},
            onSecondaryTapDown: (_) {},
            onSecondaryTapUp: (_) {},
            onSecondaryTapCancel: () {},
            onTertiaryTapDown: (_) {},
            onTertiaryTapUp: (_) {},
            onTertiaryTapCancel: () {},
            onDoubleTapDown: (_) {},
            onDoubleTap: () {},
            onDoubleTapCancel: () {},
            onLongPressDown: (_) {},
            onLongPressCancel: () {},
            onLongPress: () {},
            onLongPressStart: (_) {},
            onLongPressUp: () {},
            onLongPressEnd: (_) {},
            onSecondaryLongPressDown: (_) {},
            onSecondaryLongPressCancel: () {},
            onSecondaryLongPress: () {},
            onSecondaryLongPressStart: (_) {},
            onSecondaryLongPressUp: () {},
            onSecondaryLongPressEnd: (_) {},
            onTertiaryLongPressDown: (_) {},
            onTertiaryLongPressCancel: () {},
            onTertiaryLongPress: () {},
            onTertiaryLongPressStart: (_) {},
            onTertiaryLongPressUp: () {},
            onTertiaryLongPressEnd: (_) {},
            onVerticalDragDown: (_) {},
            onVerticalDragStart: (_) {},
            onVerticalDragUpdate: (_) {},
            onVerticalDragEnd: (_) {},
            onVerticalDragCancel: () {},
            onForcePressStart: (_) {},
            onForcePressPeak: (_) {},
            onForcePressUpdate: (_) {},
            onForcePressEnd: (_) {},
          ),
        ),
      ],
    );
  }
}
