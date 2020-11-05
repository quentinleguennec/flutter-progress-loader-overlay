import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'progress_loader.dart';

/// Use this class instead of [WillPopScope] to control the [ProgressLoader] when the user tries dismiss
/// the enclosing [ModalRoute].
///
/// This can be tuned to prevent the user from popping the route, or to have the [ProgressLoader] dismiss
/// itself when the user pops the route.
///
/// Note that, like Flutter's [WillPopScope], this does not prevent navigation from code using [Navigator.pop].
///
/// IMPORTANT: [WillPopScope] is a bit broken in Flutter on iOS, and will prevent users from navigating back even if
/// onWillPop returns true. This widget relies on [WillPopScope] and suffers from the same issue.
/// See here for more: https://github.com/flutter/flutter/issues/14203
class WillPopScopeLoader extends StatelessWidget {
  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  /// Called to veto attempts by the user to dismiss the enclosing [ModalRoute].
  ///
  /// If the callback returns a Future that resolves to false, the enclosing route will not be popped.
  /// If it returns true, it will only be popped if the [ProgressLoader] is not showing.
  ///
  /// Defaults to allow popping.
  final WillPopCallback onWillPop;

  /// Set this to true to allow the route to be popped even when [ProgressLoader] is showing.
  ///
  /// The [onWillPop] is still respected (so if [onWillPop] says the page can't be popped
  /// it won't be popped, even if this is true).
  ///
  /// This will not dismiss the [ProgressLoader] when the route is popped, unless
  /// [dismissProgressLoaderWhenPopping] is true.
  final bool allowPopWhenLoading;

  /// If this and [allowPopWhenLoading] is true then popping the route will dismiss the [ProgressLoader].
  ///
  /// It is an error to have this true and [allowPopWhenLoading] false at the same time, an assert will be thrown.
  final bool dismissProgressLoaderWhenPopping;

  const WillPopScopeLoader({
    Key key,
    @required this.child,
    this.onWillPop,
    this.allowPopWhenLoading = false,
    this.dismissProgressLoaderWhenPopping = false,
  }) : assert(!dismissProgressLoaderWhenPopping || allowPopWhenLoading);

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          if (await onWillPop?.call() == false) return false;

          if (dismissProgressLoaderWhenPopping)
            await ProgressLoader().dismiss();

          return !ProgressLoader().isLoading || allowPopWhenLoading;
        },
        child: child,
      );
}
