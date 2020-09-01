import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/cutom_route.dart';
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text(' Navigate screen'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Shop"),
            onTap: () => Navigator.pushNamed(context, '/'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.credit_card),
            title: Text("Orders"),
            onTap: () =>// Navigator.pushNamed(context, OrdersScreen.routeName)
                      Navigator.of(context).push(CustomPageRoute((ctx) => OrdersScreen())),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Manage Products"),
            onTap: () =>
                Navigator.pushNamed(context, UserProductsScreen.routeName),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            onTap: () {
              // Navigator.pushNamed(context, UserProductsScreen.routeName);
              Navigator.of(context).pop();//We need to close the drawer before logging out
              Navigator.of(context).pushReplacementNamed('/');

              Provider.of<Auth>(context).logout();
            },
          ),
        ],
      ),
    );
  }
}
