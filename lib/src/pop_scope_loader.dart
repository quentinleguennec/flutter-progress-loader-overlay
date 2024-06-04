import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'progress_loader.dart';

/// A callback type for informing that a navigation pop has been invoked,
/// whether or not it was handled successfully.
///
/// Accepts a didPop boolean indicating whether or not back navigation
/// succeeded.
/// Accepts a wasLoading boolean returning the value [ProgressLoader.isLoading] had before
/// the back navigation was attempted. If [PopScopeLoader.allowPopWhenLoading] is set to false this
/// allows you to know whether or not the [ProgressLoader] was showing before the back navigation was requested.
typedef PopScopeLoaderInvokedCallback = void Function(
  bool didPop,
  bool wasLoading,
);

/// Use this class instead of [PopScope] to control the [ProgressLoader] when the user tries to dismiss
/// the enclosing [ModalRoute].
///
/// This can be tuned to prevent the user from popping the route, or to have the [ProgressLoader] dismiss
/// itself when the user pops the route.
///
/// Note that, like Flutter's [PopScope], this does not prevent navigation from code using [Navigator.pop].
///
/// NOTE: [PopScope] only recognize system back gestures. On iOS there is not consistency for back gestures,
/// and therefore there is no system back gesture. This can lead to issues if you create your own loader widget
/// and your widget is intercepting the swipe gesture. Check [_DefaultProgressLoaderWidget] in the code to
/// learn more about the issue and see the proposed work-around.
class PopScopeLoader extends StatelessWidget {
  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  /// {@template flutter.widgets.PopScope.onPopInvoked}
  /// Called after a route pop was handled.
  /// {@endtemplate}
  ///
  /// It's not possible to prevent the pop from happening at the time that this
  /// method is called; the pop has already happened. Use [canPop] to
  /// disable pops in advance.
  ///
  /// This will still be called even when the pop is canceled. A pop is canceled
  /// when the relevant [Route.popDisposition] returns false, such as when
  /// [canPop] is set to false on a [PopScope].
  /// The `didPop` parameter indicates whether or not the back navigation actually happened
  /// successfully.
  /// The `wasLoading` parameter reports the value [ProgressLoader.isLoading] had before
  /// the back navigation was attempted. If [PopScopeLoader.allowPopWhenLoading] is set to false this
  /// allows you to know whether or not the [ProgressLoader] was showing before the back navigation was requested.
  final PopScopeLoaderInvokedCallback? onPopInvoked;

  /// {@template flutter.widgets.PopScope.canPop}
  /// When true, if [allowPopWhenLoading] is false and the [ProgressLoader] is visible then blocks the current route from being popped.
  /// When false, blocks the current route from being popped.
  ///
  /// This includes the root route, where upon popping, the Flutter app would
  /// exit.
  ///
  /// If multiple [PopScope] widgets appear in a route's widget subtree, then
  /// each and every `canPop` must be `true` in order for the route to be
  /// able to pop.
  ///
  /// [Android's predictive back](https://developer.android.com/guide/navigation/predictive-back-gesture)
  /// feature will not animate when this boolean is false.
  /// {@endtemplate}
  final bool canPop;

  /// Set this to true to allow the route to be popped even when the [ProgressLoader] is showing.
  ///
  /// [canPop] is still respected, so if [canPop] is false [allowPopWhenLoading] will have no effect.
  ///
  /// This will not dismiss the [ProgressLoader] when the route is popped, unless
  /// [dismissProgressLoaderWhenPopping] is true.
  final bool allowPopWhenLoading;

  /// If this and [allowPopWhenLoading] are true then popping the route will dismiss the [ProgressLoader].
  ///
  /// It is an error to have this true and [allowPopWhenLoading] false at the same time, an assert will be thrown.
  final bool dismissProgressLoaderWhenPopping;

  const PopScopeLoader({
    Key? key,
    required this.child,
    this.onPopInvoked,
    this.canPop = true,
    this.allowPopWhenLoading = false,
    this.dismissProgressLoaderWhenPopping = false,
  }) : assert(!dismissProgressLoaderWhenPopping || allowPopWhenLoading);

  @override
  Widget build(BuildContext context) => StreamBuilder<bool>(
        stream: ProgressLoader().onStatusChangedStream,
        builder: (context, snapshot) {
          final bool isLoading = snapshot.data == true;
          return PopScope(
            canPop: canPop && (!isLoading || allowPopWhenLoading),
            onPopInvoked: (didPop) async {
              final bool wasProgressLoaderVisible = ProgressLoader().isLoading;
              if (didPop && dismissProgressLoaderWhenPopping) {
                await ProgressLoader().dismiss();
              }
              onPopInvoked?.call(didPop, wasProgressLoaderVisible);
            },
            child: child,
          );
        },
      );
}
