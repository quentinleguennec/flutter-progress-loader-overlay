import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

part 'default_progress_loader_widget.dart';

/// Signature for a function that creates a widget, e.g. [StatelessWidget.build]
/// or [State.build].
///
/// Used by [ProgressLoader]. The created widget can use the provided [ProgressLoaderWidgetController] and register
/// the onDismiss callback with [ProgressLoaderWidgetController.attach].
typedef ProgressLoaderWidgetBuilder = Widget Function(
    BuildContext context, ProgressLoaderWidgetController controller);

/// Can be used to show a widget in an overlay to indicate loading.
///
/// Singleton instance managing it's own state, calling [show] and [dismiss] will affect the overlay no matter where it
/// is called from.
///
/// Only one overlay can be shown at any time (calling [show] twice without calling [dismiss] will not cause
/// 2 overlays to show).
class ProgressLoader {
  static final ProgressLoader _instance = ProgressLoader._internal();

  late final OverlayEntry _overlayEntry;
  late final ProgressLoaderWidgetController _widgetController;
  late bool _isShowing;
  late bool _isScheduledToShow;
  late bool _isDismissing;

  Completer<void>? _showCompleter;

  ProgressLoaderWidgetBuilder? _widgetBuilder;

  ProgressLoaderWidgetBuilder get widgetBuilder =>
      _widgetBuilder ?? _defaultWidgetBuilder;

  /// Set [widgetBuilder] to use your own custom widget when the [ProgressLoader] is showing.
  set widgetBuilder(ProgressLoaderWidgetBuilder? value) =>
      _widgetBuilder = value;

  ProgressLoaderWidgetBuilder get _defaultWidgetBuilder =>
      (context, controller) => _DefaultProgressLoaderWidget(controller);

  /// This will be true if the [ProgressLoader] is currently on screen, or is scheduled to show on the next frame.
  /// It will stay true until [ProgressLoader] is fully dismissed, which could be long after [ProgressLoader.dismiss] is
  /// called if [ProgressLoader] is waiting for the future in [ProgressLoaderWidgetController] to complete.
  bool get isLoading => _isShowing || _isScheduledToShow;

  ProgressLoader._internal() {
    _overlayEntry = _createOverlayEntry();
    _widgetController = ProgressLoaderWidgetController();
    _isShowing = false;
    _isDismissing = false;
    _isScheduledToShow = false;
  }

  factory ProgressLoader() => _instance;

  /// Call this from anywhere to have the [ProgressLoader] show.
  ///
  /// Calling this when the [ProgressLoader] is already showing (i.e [isLoading] is true) will not do anything.
  ///
  /// Calling this when the [ProgressLoader] is dismissing (i.e. waiting for the future in
  /// [ProgressLoaderWidgetController] to complete) will cause the [ProgressLoader] to show again as soon as the
  /// it is done dismissing (unless dismissed is called again in the meantime).
  ///
  /// This future will complete on the frame where the overlay is inserted, or when [dismiss] is called, or right away
  /// if the overlay is already showing and not dismissing.
  Future<void> show(BuildContext context) async {
    if (_isScheduledToShow) {
      return _showCompleter?.future;
    }

    if (_isDismissing && !_isScheduledToShow) {
      _isScheduledToShow = true;
      if (_showCompleter == null) {
        _showCompleter = Completer<void>();
      }
      await _showCompleter?.future;
      if (!_isScheduledToShow) {
        return;
      }
    }

    if (_isShowing || _isDismissing) return;

    _isScheduledToShow = true;
    await SchedulerBinding.instance!.endOfFrame;
    if (!_isScheduledToShow) return;

    Overlay.of(context)!.insert(_overlayEntry);
    _isScheduledToShow = false;
    _isShowing = true;
  }

  /// Call this from anywhere to have the [ProgressLoader] dismiss.
  /// Calling this when the [ProgressLoader] is not showing or already dismissing will not do anything.
  ///
  /// This future will complete on the frame where the overlay is removed (after waiting for the loading animation to
  /// complete), or right away if the overlay is not showing or already dismissing.
  Future<void> dismiss() async {
    _isScheduledToShow = false;
    if (_showCompleter?.isCompleted == false) {
      _showCompleter?.complete();
    }
    _showCompleter = null;

    if (!_isShowing || _isDismissing) return;
    _isDismissing = true;

    /// This is here to make sure the widget has been built before trying to dismiss it.
    /// Without this, calling show and dismiss on the same frame will prevent the call to [_WidgetController.dismiss],
    /// because the controller won't have the time to attach itself to the widget.
    await SchedulerBinding.instance!.endOfFrame;

    await _widgetController._dismiss();

    _overlayEntry.remove();
    _isDismissing = false;
    _isShowing = false;

    if (_showCompleter?.isCompleted == false) {
      _showCompleter?.complete();
    }
    _showCompleter = null;
  }

  OverlayEntry _createOverlayEntry() => OverlayEntry(
        builder: (context) => widgetBuilder(context, _widgetController),
      );
}

class ProgressLoaderWidgetController {
  AsyncCallback? _onDismiss;

  void attach(AsyncCallback onDismiss) => _onDismiss = onDismiss;

  void detach() => _onDismiss = null;

  Future<void> _dismiss() async => await _onDismiss?.call();
}
