import 'package:flutter/material.dart';
import 'package:progress_loader_overlay/progress_loader_overlay.dart';

class WillPopScopeLoaderPage extends MaterialPageRoute<Null> {
  WillPopScopeLoaderPage() : super(builder: (context) => _PageContent());
}

class _PageContent extends StatefulWidget {
  _PageContent({Key key}) : super(key: key);

  @override
  _PageContentState createState() => _PageContentState();
}

class _PageContentState extends State<_PageContent> {
  bool willPopScope = true;
  bool allowPopWhenLoading = false;
  bool dismissProgressLoaderWhenPopping = false;

  void showDefaultLoader() async {
    await ProgressLoader().show(context);
    await Future<void>.delayed(Duration(seconds: 5));
    await ProgressLoader().dismiss();
  }

  Widget buildButtons() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            child: Text('Toggle allowPopWhenLoading'),
            onPressed: () => setState(() {
              allowPopWhenLoading = !allowPopWhenLoading;
              dismissProgressLoaderWhenPopping = false;
            }),
          ),
          ElevatedButton(
            child: Text('Toggle dismissProgressLoaderWhenPopping'),
            onPressed: !allowPopWhenLoading
                ? null
                : () => setState(() => dismissProgressLoaderWhenPopping =
                    !dismissProgressLoaderWhenPopping),
          ),
          ElevatedButton(
            child: Text('Toggle willPopScope'),
            onPressed: () => setState(() => willPopScope = !willPopScope),
          ),
          ElevatedButton(
            child: Text('Show loader'),
            onPressed: showDefaultLoader,
          ),

          /// like Flutter's [WillPopScope], [WillPopScopeLoader] does not prevent navigation from code using [Navigator.pop].
          ElevatedButton(
            child: Text('Back'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );

  Widget buildTexts() => Text.rich(
        TextSpan(
          children: <InlineSpan>[
            TextSpan(
              text: 'allowPopWhenLoading = ',
            ),
            TextSpan(
              text: '$allowPopWhenLoading:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: '\nBack navigation by the user when loading is ',
            ),
            if (!willPopScope)
              TextSpan(
                text: 'disabled because willPopScope is true.',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            else
              TextSpan(
                text: '${allowPopWhenLoading ? 'enabled' : 'disabled'}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            TextSpan(
              text: '\n\ndismissProgressLoaderWhenPopping = ',
            ),
            TextSpan(
              text: '$dismissProgressLoaderWhenPopping:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            if (!allowPopWhenLoading)
              TextSpan(
                text:
                    '\n(allowPopWhenLoading must be true for this to be set to true)',
              ),
            TextSpan(
              text: '\nWhen navigating back, the loader ',
            ),
            TextSpan(
              text: '${dismissProgressLoaderWhenPopping ? 'will' : 'will not'}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: ' be dismissed',
            ),
            TextSpan(
              text: '\n\nwillPopScope = ',
            ),
            TextSpan(
              text: '$willPopScope:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: '\nBack navigation by the user is ',
            ),
            TextSpan(
              text: '${willPopScope ? 'enabled' : 'disabled'}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            /// NOTE: [WillPopScope] is a bit broken in Flutter on iOS, and will prevent users from navigating back even if
            /// onWillPop returns true. This widget relies on [WillPopScope] and suffers from the same issue.
            /// See here for more: https://github.com/flutter/flutter/issues/14203
            TextSpan(
              text:
                  '\n\n\n\nPlay with the parameters above then press the "Show loader" button and try to pop the '
                  'page with the default back navigation of your platform (e.g back button on Android...). '
                  '\n\nNote that the standard swipe left to right from edge of screen to navigate back on iOS is '
                  'broken in Flutter when using WillPopScope and you won\'t be able to navigate back from here using '
                  'this gesture. See code for more info.',
            ),
          ],
        ),
        style: TextStyle(fontWeight: FontWeight.normal),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: WillPopScopeLoader(
            /// This onWillPop is behaving the same as Flutter's [WillPopScope.onWillPop].
            onWillPop: () async => willPopScope,
            allowPopWhenLoading: allowPopWhenLoading,
            dismissProgressLoaderWhenPopping: dismissProgressLoaderWhenPopping,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      buildButtons(),
                      Padding(padding: const EdgeInsets.only(top: 64)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: buildTexts(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
