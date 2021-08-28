import 'package:buy_buy/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/bids_screen.dart';
import '../screens/user_items_screen.dart';


class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Item Gallery'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Bids'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(BidsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Item'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserItemsScreen.routeName);
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext ctx) =>
                    AlertDialog(
                      title: Text('Are you sure?'),
                      content: Text('You Want to Logout?'),
                      actions: <Widget> [
                        FlatButton(
                          onPressed: () =>
                            Navigator.of(context).pop(),
                          child: Text('Cancel'),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/');
                           Navigator.of(context).pop();
                           Provider.of<Auth>(context, listen: false).logout();

                          },
                          child: Text('Ok'),
                        ),
                      ],
                    ),
              );
             // Navigator.of(context).pop();
            //  Navigator.of(context).pushReplacementNamed('/');



            },
          ),
        ],
      ),
    );
  }
}
