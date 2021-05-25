import 'dart:math';

import 'package:flutter/material.dart';
import 'package:progress_loader_overlay/progress_loader_overlay.dart';
import 'package:vector_math/vector_math_64.dart' as mathVector;

import 'app_extensions.dart';

/// This slightly more complex example shows that the [ProgressLoader] transition and widget can be completely
/// customized.
class ComplexProgressLoaderWidget extends StatefulWidget {
  final ProgressLoaderWidgetController controller;

  const ComplexProgressLoaderWidget(
    this.controller, {
    Key? key,
  }) : super(key: key);

  @override
  _ComplexProgressLoaderWidgetState createState() =>
      _ComplexProgressLoaderWidgetState();
}

class _ComplexProgressLoaderWidgetState
    extends State<ComplexProgressLoaderWidget> with TickerProviderStateMixin {
  late final AnimationController transitionAnimationController;
  late final AnimationController animationController;

  @override
  void initState() {
    /// Attach a callback to be called when [ProgressLoader.dismiss] is called.
    /// The function can be synchronous or asynchronous. With the later, the [ProgressLoader] will wait until
    /// the future completes before switching to the dismissed state.
    /// If no callback is given, or if the callback is synchronous, this widget will be disposed as soon as
    /// [ProgressLoader.dismiss] is called.
    widget.controller.attach(dismiss);

    transitionAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )
      ..addListener(
        () {
          if (mounted) setState(() {});
        },
      )
      ..forward().then((value) => animationController.repeat(reverse: true));

    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    super.initState();
  }

  @override
  void dispose() {
    /// Don't forget to detach when this widget is disposed to avoid memory leaks.
    widget.controller.detach();
    animationController.dispose();
    transitionAnimationController.dispose();
    super.dispose();
  }

  Future<void> dismiss() async {
    /// We reverse the dancing box animation fully before removing the black overlay.
    /// [ProgressLoader] will be in the dismissed state only after both these animation are done playing.
    ///
    /// Important note: [orCancelSilently] is a custom extension, check what it does if you want to do something like
    /// this in your code.
    await animationController.reverse().orCancelSilently;
    await transitionAnimationController.reverse().orCancelSilently;
  }

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: transitionAnimationController.value,
        child: Container(
          color: Colors.black.withOpacity(0.3),
          child: Center(
            child: _DancingBox(animation: animationController),
          ),
        ),
      );
}

class _DancingBox extends AnimatedWidget {
  final Animation<double> animation;

  const _DancingBox({
    Key? key,
    required this.animation,
  }) : super(key: key, listenable: animation);

  double get size => 40 * (1 + animation.value);

  double get rotation => 2 * pi * animation.value;

  mathVector.Vector3 get translation =>
      mathVector.Vector3(20 * cos(rotation), 20 * sin(rotation), 0);

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        color: Theme.of(context).accentColor,
        transform: Matrix4.translation(translation)
          ..rotateZ(rotation)
          ..rotateY(rotation),
      );
}
