import 'package:flutter/material.dart';
import 'package:progress_loader_overlay/progress_loader_overlay.dart';

class PopScopeLoaderPage extends MaterialPageRoute<Null> {
  PopScopeLoaderPage() : super(builder: (context) => _PageContent());
}

class _PageContent extends StatefulWidget {
  _PageContent({Key? key}) : super(key: key);

  @override
  _PageContentState createState() => _PageContentState();
}

class _PageContentState extends State<_PageContent> {
  bool canPop = true;
  bool allowPopWhenLoading = false;
  bool dismissProgressLoaderWhenPopping = false;

  @override
  void initState() {
    ProgressLoader().widgetBuilder = null;
    super.initState();
  }

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
            child: Text('Toggle canPop'),
            onPressed: () => setState(() => canPop = !canPop),
          ),
          ElevatedButton(
            child: Text('Show loader'),
            onPressed: showDefaultLoader,
          ),

          /// like Flutter's [PopScope], [PopScopeLoader] does not prevent navigation from code using [Navigator.pop].
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
            if (!canPop)
              TextSpan(
                text: 'disabled because canPop is true.',
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
              text: '\n\ncanPop = ',
            ),
            TextSpan(
              text: '$canPop:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: '\nBack navigation by the user is ',
            ),
            TextSpan(
              text: '${canPop ? 'enabled' : 'disabled'}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            if (canPop && !allowPopWhenLoading)
              TextSpan(
                text: ' except when loading',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

            /// NOTE: [PopScope] only recognize system back gestures. On iOS there is not consistency for back gestures,
            /// and therefore there is no system back gesture. This can lead to issues if you create your own loader widget
            /// and your widget is intercepting the swipe gesture. Check [_DefaultProgressLoaderWidget] in the code to
            /// learn more about the issue and see the proposed work-around.
            TextSpan(
              text:
                  '\n\n\n\nPlay with the parameters above then press the "Show loader" button and try to pop the '
                  'page with the default back navigation of your platform (e.g back button on Android...). '
                  '\n\nNOTE: On iOS there is no system back gesture. This can lead to issues if you create your own loader widget '
                  'and your widget is intercepting the swipe gesture. Check [_DefaultProgressLoaderWidget] in the plugin code to '
                  'learn more about the issue and see the proposed work-around.',
            ),
          ],
        ),
        style: TextStyle(fontWeight: FontWeight.normal),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: PopScopeLoader(
            /// This onPopInvoked is behaving the same as Flutter's [PopScope.onPopInvoked].
            onPopInvoked: (didPop, wasLoading) {
              if (!canPop) {
                print(
                    'onPopInvoked: The page should NOT pop because canPop is false.');
              } else if (wasLoading) {
                if (!allowPopWhenLoading) {
                  print(
                      'onPopInvoked: The page should NOT pop because allowPopWhenLoading is false.');
                } else if (dismissProgressLoaderWhenPopping) {
                  print(
                      'onPopInvoked: The page should pop and the progress loader dismiss because dismissProgressLoaderWhenPopping is true.');
                } else {
                  print(
                      'onPopInvoked: The page should pop BUT the progress loader should stay because dismissProgressLoaderWhenPopping is false.');
                }
              } else {
                print('onPopInvoked: The page should pop.');
              }
            },
            canPop: canPop,
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
