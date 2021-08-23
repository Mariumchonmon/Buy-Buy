import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/splash_screen.dart';
import './screens/items_overview_screen.dart';
import './screens/item_details_screen.dart';
import './providers/items.dart';
import './providers/auth.dart';
import './screens/user_items_screen.dart';
import './screens/edit_item_screen.dart';
import './screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Items>(
        create: (ctx) => Items('', '', []),
        update: (ctx, auth, previousProducts) => Items(
        auth.token,
        auth.userId,
        previousProducts == null ? []
            : previousProducts.items,
        ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Buy-Buy',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
            future: auth.tryAutoLogin(),
            builder: (ctx, authResultSnapshot) =>
            authResultSnapshot.connectionState ==
                ConnectionState.waiting
                ? SplashScreen()
                : AuthScreen(),
          ),
          routes: {
            ItemDetailsScreen.routeName: (ctx) => ItemDetailsScreen(),
            UserItemsScreen.routeName: (ctx) => UserItemsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
