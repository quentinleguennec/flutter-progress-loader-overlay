import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:progress_loader_overlay/progress_loader_overlay.dart';
import 'package:progress_loader_overlay_example/main.dart';

import 'complex_progress_loader_widget.dart';

/// This page is to test the behaviour of the loader if any change is made to the logic.
/// When testing make sure you can see the 'print('testSyncX END');' to make sure the function does not hang somewhere.
///
/// To see this page run the app with "flutter run --route '/testSync'"
class TestSync extends StatelessWidget {
  OverlayState get overlayState => MyApp.navigatorKey.currentState!.overlay!;

  /// This should show the default loader, then dismiss it and replace it with the long one straight away, then
  /// dismiss it soon after.
  void testSync1() async {
    print('testSync1 START');
    ProgressLoader().widgetBuilder = null;
    await Future<void>.delayed(Duration(milliseconds: 500));

    // VISIBLE

    ProgressLoader().show(overlayState);
    await Future<void>.delayed(Duration(seconds: 1));
    ProgressLoader().dismiss();

    // SWITCH

    ProgressLoader().widgetBuilder = (context, loaderWidgetController) =>
        ComplexProgressLoaderWidget(loaderWidgetController);
    ProgressLoader().show(overlayState);
    await Future<void>.delayed(Duration(seconds: 2));
    ProgressLoader().dismiss();

    // HIDDEN

    print('testSync1 END');
  }

  /// Should do the same as [testSync1].
  void testSync1_2() async {
    print('testSync1_2 START');
    ProgressLoader().widgetBuilder = null;
    await Future<void>.delayed(Duration(milliseconds: 500));

    // VISIBLE

    ProgressLoader().show(overlayState);
    await Future<void>.delayed(Duration(seconds: 1));
    ProgressLoader().widgetBuilder = (context, loaderWidgetController) =>
        ComplexProgressLoaderWidget(loaderWidgetController);
    await Future<void>.delayed(Duration(seconds: 1));
    ProgressLoader().dismiss();

    // SWITCH

    ProgressLoader().show(overlayState);
    await Future<void>.delayed(Duration(seconds: 2));
    ProgressLoader().dismiss();

    // HIDDEN
    print('testSync1_2 END');
  }

  /// This should show the default loader, then dismiss it soon after.
  void testSync2() async {
    print('testSync2 START');
    ProgressLoader().widgetBuilder = null;
    await Future<void>.delayed(Duration(milliseconds: 500));

    ProgressLoader().show(overlayState);
    ProgressLoader().show(overlayState);
    ProgressLoader().dismiss();
    ProgressLoader().dismiss();
    ProgressLoader().show(overlayState);
    ProgressLoader().show(overlayState);
    ProgressLoader().dismiss();
    await ProgressLoader().show(overlayState);
    ProgressLoader().dismiss();
    ProgressLoader().dismiss();
    await ProgressLoader().show(overlayState);
    await ProgressLoader().show(overlayState);
    await ProgressLoader().dismiss();

    // VISIBLE

    ProgressLoader().show(overlayState);
    await Future<void>.delayed(Duration(seconds: 2));
    ProgressLoader().dismiss();

    // HIDDEN
    print('testSync2 END');
  }

  /// This should show the default loader, then dismiss it and replace it with the long one straight away, then
  /// the long one plays for a bit, then stops and restarts straight away, then dismisses soon after.
  void testSync3() async {
    print('testSync3 START');
    ProgressLoader().widgetBuilder = null;
    await Future<void>.delayed(Duration(milliseconds: 500));

    await SchedulerBinding.instance.endOfFrame;

    // VISIBLE

    ProgressLoader().show(overlayState);
    await Future<void>.delayed(Duration(seconds: 1));
    ProgressLoader().dismiss();

    // HIDDEN

    await SchedulerBinding.instance.endOfFrame;

    ProgressLoader().show(overlayState);
    await SchedulerBinding.instance.endOfFrame;
    await SchedulerBinding.instance.endOfFrame;
    await SchedulerBinding.instance.endOfFrame;
    await SchedulerBinding.instance.endOfFrame;
    await SchedulerBinding.instance.endOfFrame;
    await SchedulerBinding.instance.endOfFrame;
    await SchedulerBinding.instance.endOfFrame;
    await SchedulerBinding.instance.endOfFrame;
    await SchedulerBinding.instance.endOfFrame;
    ProgressLoader().dismiss();

    ProgressLoader().widgetBuilder = (context, loaderWidgetController) =>
        ComplexProgressLoaderWidget(loaderWidgetController);

    // VISIBLE

    ProgressLoader().show(overlayState);
    await Future<void>.delayed(Duration(seconds: 3));
    await SchedulerBinding.instance.endOfFrame;
    ProgressLoader().show(overlayState);
    ProgressLoader().show(overlayState);
    ProgressLoader().dismiss();
    ProgressLoader().show(overlayState);
    await Future<void>.delayed(Duration(milliseconds: 50));
    ProgressLoader().dismiss();
    ProgressLoader().show(overlayState);
    await Future<void>.delayed(Duration(seconds: 2));
    ProgressLoader().dismiss();

    // HIDDEN
    print('testSync3 END');
  }

  /// This should show the default loader, then dismiss it and restart it straight away, then dismiss it and restart
  /// it straight away again, then dismiss it soon after.
  void testSync4() async {
    print('testSync4 START');
    ProgressLoader().widgetBuilder = null;
    await Future<void>.delayed(Duration(milliseconds: 500));

    await SchedulerBinding.instance.endOfFrame;

    await ProgressLoader().show(overlayState);
    await Future<void>.delayed(Duration(seconds: 1));
    await ProgressLoader().dismiss();
    await SchedulerBinding.instance.endOfFrame;

    await ProgressLoader().show(overlayState);
    await Future<void>.delayed(Duration(seconds: 3));
    await SchedulerBinding.instance.endOfFrame;
    await ProgressLoader().show(overlayState);
    await ProgressLoader().show(overlayState);
    await ProgressLoader().dismiss();
    await ProgressLoader().show(overlayState);
    await Future<void>.delayed(Duration(milliseconds: 50));
    await ProgressLoader().dismiss();
    await ProgressLoader().show(overlayState);
    await Future<void>.delayed(Duration(seconds: 3));
    await ProgressLoader().dismiss();
    print('testSync4 END');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                child: Text('testSync1'),
                onPressed: () => testSync1(),
              ),
              ElevatedButton(
                child: Text('testSync1_2'),
                onPressed: () => testSync1_2(),
              ),
              ElevatedButton(
                child: Text('testSync2'),
                onPressed: () => testSync2(),
              ),
              ElevatedButton(
                child: Text('testSync3'),
                onPressed: () => testSync3(),
              ),
              ElevatedButton(
                child: Text('testSync4'),
                onPressed: () => testSync4(),
              ),
              Container(height: 24),
              ElevatedButton(
                child: Text('Home'),
                onPressed: () => Navigator.pushNamed(context, '/'),
              ),
            ],
          ),
        ),
      );
}
