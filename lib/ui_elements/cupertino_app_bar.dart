import 'package:flutter/cupertino.dart';

class CupertinoAppBar extends StatelessWidget {
  final CupertinoButton? button;
  final String largeTitle;
  final Widget body;
  final String previousPageTitle;
  final double padding;
  const CupertinoAppBar({
    required this.largeTitle,
    this.button,
    super.key,
    required this.body,
    required this.previousPageTitle,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        CupertinoSliverNavigationBar(
            stretch: true,
            previousPageTitle: previousPageTitle,
            largeTitle: Text(largeTitle),
            border: const Border(),
            trailing: button),
        SliverToBoxAdapter(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding), child: body),
        ),
      ],
    );
  }
}
