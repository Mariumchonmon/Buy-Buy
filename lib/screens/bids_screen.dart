
import 'package:buy_buy/providers/bids.dart' show Bids;
import 'package:buy_buy/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/bids_item.dart';



class BidsScreen extends StatefulWidget {
  static const routeName = '/bids';

  @override
  _BidsScreenState createState() => _BidsScreenState();
}

class _BidsScreenState extends State<BidsScreen> {
  late Future _bidsFuture;
  Future _obtainOrdersFuture(){
    return Provider.of<Bids>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _bidsFuture = _obtainOrdersFuture();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print('building bids');
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Bids'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _bidsFuture,
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error != null) {
                // ..
                // Do error handling stuff
                return Center(child: Text('An error occurred'),);

              } else {
                return Consumer<Bids> (builder: (ctx, orderData, child) =>  ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => BidItem(orderData.orders[i]),
                ),);
              }
            }
          },
        )
    );
  }
}
