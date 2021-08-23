import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import './item.dart';

class Items with ChangeNotifier {
  List<Item> _items = [
  ];
  final String? authToken;
  final String? userId;

  Items(this.authToken, this.userId, this._items);

  List<Item> get items {
    return [..._items];
  }

  List<Item> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Item findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    var url = Uri.parse('https://buy-buy-14c0a-default-rtdb.firebaseio.com/items.json?auth=$authToken&&filterString');
    try{
      final response = await http.get(url);
      dynamic extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url = Uri.parse('https://buy-buy-14c0a-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Item> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Item(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addItem(Item item) async {
    final url =
     Uri.parse('https://buy-buy-14c0a-default-rtdb.firebaseio.com/items.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': item.title,
          'description': item.description,
          'imageUrl': item.imageUrl,
          'price': item.price,
          'creatorId': userId,
        }),
      );
      final newProduct = Item(
        title: item.title,
        description: item.description,
        price: item.price,
        imageUrl: item.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Item newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
      Uri.parse('https://buy-buy-14c0a-default-rtdb.firebaseio.com/items/$id.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
    Uri.parse('https://buy-buy-14c0a-default-rtdb.firebaseio.com/$id.json?auth=$authToken');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Item? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
