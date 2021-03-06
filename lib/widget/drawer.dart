import '../provider/calendar_notifier.dart';
import 'package:provider/provider.dart';
import '../model/coordinate.dart';
import '../view/calendar_page.dart';
import '../global.dart' as global;
import '../service/map_constant.dart' as constant;
import 'package:flutter/material.dart';
import '../view/shuttle_page.dart';

class SidebarDrawer extends StatefulWidget {
  final Function(Coordinate) destination;
  SidebarDrawer({this.destination});

  @override
  _SidebarDrawerState createState() => _SidebarDrawerState();
}

class _SidebarDrawerState extends State<SidebarDrawer> {
  bool _isDisabilityOn = global.disabilityMode;

  bool isDisabilityOn() {
    return _isDisabilityOn;
  }

  Widget build(BuildContext context) {
    var user = Provider.of<CalendarNotifier>(context);
    user.getCurrentName();
    user.getCurrentAvatar();
    user.getCurrentEmail();

    return ClipRRect(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(constant.BORDER_RADIUS),
          bottomRight: Radius.circular(constant.BORDER_RADIUS)),
      child: Drawer(
        child: Column(
          children: <Widget>[
            /*
            Column and Expanded widget are needed to format the disability toggle checkbox
            at the bottom of the drawer
            */
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                      accountName: user.name,
                      accountEmail: user.email,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(147, 35, 57, 1),
                          borderRadius: BorderRadius.only(
                              topRight:
                                  Radius.circular(constant.BORDER_RADIUS))),
                      currentAccountPicture: user.avatar),
                  ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text('My Calendar'),
                    onTap: () {
                      // Update the state of the app.
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChangeNotifierProvider<CalendarNotifier>(
                                      create: (_) => CalendarNotifier(),
                                      child: MyCalendar(
                                          title: "My Calendar",
                                          destination: (destination) => {
                                                widget.destination(destination)
                                              }))));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.airport_shuttle),
                    title: Text('Shuttle Schedule'),
                    onTap: () {
                      // Update the state of the app.
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShuttlePage(
                                  weekday: DateTime.now().weekday,
                                  now: TimeOfDay.now())));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                    onTap: () {
                      // Update the state of the app.
                      Navigator.pop(context);
                    },
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    leading: Icon(Icons.message),
                    title: Text('Contact Us'),
                    onTap: () {
                      // Update the state of the app.
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text('About'),
                    onTap: () {
                      // Update the state of the app.
                      Navigator.pop(context);
                    },
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            /*
            StatefulBuilder is used because the toggle state doesnt change on the drawer when
            using just a Checkbox or CheckboxListTile
            */
            StatefulBuilder(
              builder: (context, _setState) => CheckboxListTile(
                secondary: Icon(Icons.accessible_forward),
                activeColor: constant.COLOR_CONCORDIA,
                title: Text("Disability Mode"),
                value: _isDisabilityOn,
                onChanged: (bool value) {
                  _setState(() {
                    _isDisabilityOn = value;
                    global.disabilityMode = value;
                    /*
                    TODO: replace the global variable for the disability mode for a "config" file
                    where the choice of the user will be saved even after the app restarts
                    */
                    _showDisabilityToast(context);
                    Navigator.pop(context);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDisabilityToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.removeCurrentSnackBar();
    scaffold.showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        backgroundColor:
            global.disabilityMode ? constant.COLOR_CONCORDIA : null,
        content: global.disabilityMode
            ? Text('Disability Mode turned ON')
            : Text('Disability Mode turned OFF'),
        action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              global.disabilityMode = global.disabilityMode ? false : true;
              _showDisabilityToast(context);
            }),
      ),
    );
  }
}
