import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import './cart.dart';

class BidItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  BidItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Bids with ChangeNotifier {
  List<BidItem> _bids = [];
   final String? authToken;
   final String? userId;

   Bids(this.authToken, this.userId, this._bids);

  List<BidItem> get orders {
    return [..._bids];
  }

  Future<void>fetchAndSetOrders() async {
    final url = Uri.parse('https://buy-buy-14c0a-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final response = await http.get(url);
    final List<BidItem> loadedOrders = [];
   dynamic extractedData = json.decode(response.body);
   if (extractedData == null){
     return;
   }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        BidItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
           .map(
                (item) => CartItem(
            id: item['id'],
            price: item['price'],
            quantity: item['quantity'],
            title: item['title'],
          ),
          )
        .toList(),
    ),
    );
    });
    _bids = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse('https://buy-buy-14c0a-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final timestamp = DateTime.now();
   final response = await http.post(
     url,
     body: json.encode({
      'amount': total,
      'dateTime': timestamp.toIso8601String(),
      'products': cartProducts
          .map((cp) => {
        'id': cp.id,
        'title': cp.title,
        'quantity': cp.quantity,
        'price': cp.price,
      }).toList(),
    }),);

    _bids.insert(
      0,
      BidItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timestamp,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
