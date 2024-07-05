# Progress Loader Overlay Flutter Package

[![pub package](https://img.shields.io/pub/v/progress_loader_overlay.svg)](https://pub.dev/packages/progress_loader_overlay)
[![pub points](https://img.shields.io/pub/points/progress_loader_overlay?color=2E8B57&label=pub%20points)](https://pub.dev/packages/progress_loader_overlay/score)

A flutter package to show an easy to use and fully customizable progress loader as an overlay.

The overlay abstract all the logic of managing it's own state for you so you don't have to worry
about having 2 progress loaders showing at the same time if you call the `show` method more
than once at the same time.

You have full control over the widget shown in the loader too, including any animation. You could
even play a video there, or some soothing elevator music, up to you.

You also have access to a modified version of `PopScope` that makes it a breeze to handle navigation
gestures when your loader is showing (and either prevent navigation or allow it and dismiss the
loader).

Showing and dismissing the loader is as simple as that:

```
  await ProgressLoader().show(Overlay.of(context));
  await Future<void>.delayed(Duration(seconds: 2));
  await ProgressLoader().dismiss();
```

Using your own widget for the loader is as simple as that:

```
  ProgressLoader().widgetBuilder = (context, _) => MyLoaderWidget();
```

You can also change your loader widget at runtime whenever you want!

### Migrating from 4.0.1 to 5.0.0

Either replace all your calls to `ProgressLoader().show(context)`
with `ProgressLoader().show(Overlay.of(context))`, or use the `MaterialApp` navigator key.
Example setup to use the `navigatorKey`:

```
  class MyApp extends StatelessWidget {
    static final navigatorKey = GlobalKey<NavigatorState>();
    
    @override
    Widget build(BuildContext context) => const MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Material App',
      home: Scaffold(
        body: Center(
          child: Text('Hello World'),
        ),
      ),
    );
```

and then `ProgressLoader().show(MyApp.navigatorKey.currentState!.overlay!)`.