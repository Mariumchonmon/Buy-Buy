import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/items.dart';

class ItemDetailsScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final itemId =
        ModalRoute.of(context)!.settings.arguments as String; // is the id!
    final loadedItem = Provider.of<Items>(
      context,
      listen: false,
    ).findById(itemId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedItem.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedItem.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '\$${loadedItem.price}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedItem.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
