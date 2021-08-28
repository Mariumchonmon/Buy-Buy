import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/items.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import './edit_item_screen.dart';

class UserItemsScreen extends StatelessWidget {
  static const routeName = '/user-items';

  Future<void>_refreshProducts(BuildContext context) async{
    await Provider.of<Items>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    print('rebuilding...');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Items'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditItemScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
        snapshot.connectionState == ConnectionState.waiting
            ? Center(
          child: CircularProgressIndicator(),
        )
            :  RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: Consumer<Items>(
            builder: (ctx, productsData, _) => Padding(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: productsData.items.length,
                itemBuilder: (_, i) => Column(
                  children: [
                    UserProductItem(
                      productsData.items[i].id!,
                      productsData.items[i].title,
                      productsData.items[i].imageUrl,
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
