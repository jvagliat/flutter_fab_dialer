part of flutter_fab_dialer;

class FabDialer extends StatefulWidget {
  // AnimationStyle is an optional parameter to avoid breaking changes
  const FabDialer(this.fabMiniMenuItemList, this.fabColor, this.fabIcon,
      [this.fabAnimationStyle = AnimationStyle.defaultAnimation]);

  final List<FabMiniMenuItem> fabMiniMenuItemList;
  final Color fabColor;
  final Icon fabIcon;
  final AnimationStyle fabAnimationStyle;

  @override
  FabDialerState createState() => new FabDialerState(
        fabMiniMenuItemList: fabMiniMenuItemList,
        fabColor: fabColor,
        fabIcon: fabIcon,
        fabAnimationStyle: fabAnimationStyle,
      );
}

class FabDialerState extends State<FabDialer> with TickerProviderStateMixin {
  FabDialerState(
      {required this.fabMiniMenuItemList,
      required this.fabColor,
      required this.fabIcon,
      required this.fabAnimationStyle});

  int angle = 90;
  bool isRotated = true;
  final List<FabMiniMenuItem> fabMiniMenuItemList;
  final Color fabColor;
  final Icon fabIcon;
  final AnimationStyle fabAnimationStyle;
  late List<FabMenuMiniItemWidget> fabMenuItems;

  late AnimationController controller;

  @override
  void initState() {
    controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    controller.reverse();

    setFabMenu(this.fabMiniMenuItemList);
    super.initState();
  }

  void setFabMenu(List<FabMiniMenuItem> fabMenuList) {
    List<FabMenuMiniItemWidget> fabMenuItems = [];
    for (int i = 0; i < fabMiniMenuItemList.length; i++) {
      fabMenuItems.add(new FabMenuMiniItemWidget(
        tooltip: fabMiniMenuItemList[i].tooltip,
        text: fabMiniMenuItemList[i].text!,
        elevation: fabMiniMenuItemList[i].elevation,
        icon: fabMiniMenuItemList[i].icon,
        image: fabMiniMenuItemList[i].image,
        index: i,
        onPressed: fabMiniMenuItemList[i].onPressed,
        textColor: fabMiniMenuItemList[i].textColor,
        fabColor: fabMiniMenuItemList[i].fabColor,
        chipColor: fabMiniMenuItemList[i].chipColor,
        controller: controller,
        animationStyle: fabAnimationStyle,
        itemCount: fabMiniMenuItemList.length,
        // Send item count to each item to help animation calc
        hideWidget: fabMiniMenuItemList[i].hideOnClick == false ? null : rotate,
      ));
    }

    this.fabMenuItems = fabMenuItems;
  }

  void rotate() {
    setState(() {
      if (isRotated) {
        angle = 45;
        isRotated = false;
        controller.forward();
      } else {
        angle = 90;
        isRotated = true;
        controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: new EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: fabMenuItems,
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new FloatingActionButton(
                    child: new RotationTransition(
                      turns: new AlwaysStoppedAnimation(angle / 360),
                      child: fabIcon,
                    ),
                    backgroundColor: fabColor,
                    onPressed: rotate)
              ],
            ),
          ],
        ));
  }
}
