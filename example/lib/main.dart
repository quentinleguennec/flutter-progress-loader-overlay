import 'package:flutter/material.dart';
import 'package:progress_loader_overlay/progress_loader_overlay.dart';
import 'package:progress_loader_overlay_example/test_sync.dart';

import 'complex_progress_loader_widget.dart';
import 'simple_progress_loader_widget.dart';
import 'stateless_progress_loader_widget.dart';
import 'will_pop_scope_loader_page.dart';

void main() {
  /// Initialize the builder. This could be done anywhere, but must be done before the loader is first shown.
  ProgressLoader().widgetBuilder = (context, loaderWidgetController) =>
      SimpleProgressLoaderWidget(loaderWidgetController);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Progress Loader Overlay Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => MyHomePage(),
          '/testSync': (context) => TestSync(),
        },
      );
}

class MyHomePage extends StatelessWidget {
  void showSimpleLoader(BuildContext context) async {
    /// The widget used when the [ProgressLoader] is showing can be changed at any time.
    /// If the [ProgressLoader] is showing when the widget is replaced the new widget will only be shown after the
    /// [ProgressLoader] is dismissed and shown again.
    ProgressLoader().widgetBuilder = (context, loaderWidgetController) =>
        SimpleProgressLoaderWidget(loaderWidgetController);

    /// Show the loader,
    await ProgressLoader().show(context);

    /// Wait for a network task or any Future,
    await Future<void>.delayed(Duration(seconds: 2));

    /// Dismiss the loader when the task is done.
    await ProgressLoader().dismiss();
  }

  void showComplexLoader(BuildContext context) async {
    ProgressLoader().widgetBuilder = (context, loaderWidgetController) =>
        ComplexProgressLoaderWidget(loaderWidgetController);

    await ProgressLoader().show(context);
    await Future<void>.delayed(Duration(seconds: 5));
    await ProgressLoader().dismiss();
  }

  void showStatelessLoader(BuildContext context) async {
    /// With this widget we don't want to do anything special when the [ProgressLoader] is dismissed,
    /// so we don't have to attach anything to the controller, and there is no need to pass it to the widget.
    ProgressLoader().widgetBuilder =
        (context, _) => StatelessProgressLoaderWidget();

    await ProgressLoader().show(context);
    await Future<void>.delayed(Duration(seconds: 2));
    await ProgressLoader().dismiss();
  }

  void showDefaultLoader(BuildContext context) async {
    /// If no widgetBuilder is specified a simple default loader will be displayed.
    ProgressLoader().widgetBuilder = null;

    await ProgressLoader().show(context);
    await Future<void>.delayed(Duration(seconds: 2));
    await ProgressLoader().dismiss();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                child: Text('Simple loader'),
                onPressed: () => showSimpleLoader(context),
              ),
              ElevatedButton(
                child: Text('Complex loader'),
                onPressed: () => showComplexLoader(context),
              ),
              ElevatedButton(
                child: Text('Stateless loader'),
                onPressed: () => showStatelessLoader(context),
              ),
              ElevatedButton(
                child: Text('Default loader'),
                onPressed: () => showDefaultLoader(context),
              ),
              ElevatedButton(
                child: Text('Open WillPopScopeLoader demo page'),
                onPressed: () =>
                    Navigator.push(context, WillPopScopeLoaderPage()),
              ),
            ],
          ),
        ),
      );
}
