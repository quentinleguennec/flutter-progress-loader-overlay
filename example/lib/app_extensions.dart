import 'package:flutter/animation.dart';

extension TickerFutureExtension on TickerFuture {
  /// Important note:
  /// [AnimationController].reverse() does not return a [Future], it returns a [TickerFuture].
  /// And [TickerFuture] will not return (and will hang forever) in some cases,
  /// like if the [AnimationController] is dismissed before the [TickerFuture] completes for example.
  /// To avoid hanging the [ProgressLoader] we must use [TickerFuture].orCancel and catch any [TickerCanceled] exception.
  Future<void> get orCancelSilently => orCancel.catchError(
        (Object _) {
          /// The error is a [TickerCanceled], just complete the future.
        },
        test: (error) => error is TickerCanceled,
      );
}
