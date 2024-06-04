# Progress Loader Overlay Flutter Package

[![pub package](https://img.shields.io/pub/v/progress_loader_overlay.svg)](https://pub.dev/packages/progress_loader_overlay)
[![pub points](https://img.shields.io/pub/points/progress_loader_overlay?color=2E8B57&label=pub%20points)](https://pub.dev/packages/progress_loader_overlay/score)

A flutter package to show an easy to use and fully customizable progress loader as an overlay.

The overlay abstract all the logic of managing it's own state for you so you don't have to worry
about having 2 progress loaders showing at the same time if you call the `show` method more
than once at the same time.

You have full control over the widget shown in the loader too, including any animation. You could
even play a video there, or some soothing elevator music, up to you.

You also have access to a modified version of `PopScope` that makes it a breeze to users navigation 
gestures when your loader is showing (and either prevent navigation or allow it and dismiss the loader).

Showing and dismissing the loader is as simple as that:
```
    await ProgressLoader().show(context);
    await Future<void>.delayed(Duration(seconds: 2));
    await ProgressLoader().dismiss();
```

Using your own widget for the loader is as simple as that:
```
    ProgressLoader().widgetBuilder = (context, _) => MyLoaderWidget();
```
You can also change your loader widget at runtime whenever you want!
