import 'package:buy_buy/providers/auth.dart';
import 'package:buy_buy/providers/bids.dart';
import 'package:buy_buy/providers/cart.dart';
import 'package:buy_buy/screens/bids_screen.dart';
import 'package:buy_buy/screens/edit_item_screen.dart';
import 'package:buy_buy/screens/items_overview_screen.dart';
import 'package:buy_buy/screens/user_items_screen.dart';
import 'package:flutter/material.dart';
import '../providers/items.dart';
import 'package:provider/provider.dart';
import './screens/splash_screen.dart';

import './screens/cart_screen.dart';
import '../screens/auth_screen.dart';
import './helpers/custom_routes.dart';
import './screens/item_details_screen.dart';


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
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Bids>(
          create: (ctx) => Bids('', '', []),
          update: (ctx, auth, previousProducts) => Bids(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.orders),
        ),
      ],
      child:Consumer<Auth>(
        builder: (ctx, auth, _) =>
            MaterialApp(
              title: 'Item Gallery',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  primarySwatch: Colors.purple,
                  accentColor: Colors.deepOrange,
                  pageTransitionsTheme: PageTransitionsTheme(builders: {
                    TargetPlatform.android: CustomPageTransitionBuilder(),
                    TargetPlatform.iOS: CustomPageTransitionBuilder(),
                  })

              ),
              home: auth.isAuth
                  ? ItemsOverviewScreen()
                  : FutureBuilder(
                future: auth.tryAutoLogin(),
                builder:  (ctx, authResultSnapshot) =>
                authResultSnapshot.connectionState ==
                    ConnectionState.waiting
                    ? SplashScreen()
                    : AuthScreen(),
              ),
              routes: {
                ItemDetailsScreen.routeName: (ctx) => ItemDetailsScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
                BidsScreen.routeName: (ctx) => BidsScreen(),
                UserItemsScreen.routeName: (ctx) => UserItemsScreen(),
                EditItemScreen.routeName: (ctx) => EditItemScreen(),
              },
            ),
      ),
    );
  }
}
