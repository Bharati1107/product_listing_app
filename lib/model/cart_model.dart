import 'dart:convert';
import 'product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  Map<String, dynamic> toMap() => {
        'product': product.toMap(),
        'quantity': quantity,
      };

  factory CartItem.fromMap(Map<String, dynamic> map) => CartItem(
        product: Product.fromMap(Map<String, dynamic>.from(map['product'])),
        quantity: map['quantity'],
      );

  static String encodeList(List<CartItem> items) =>
      json.encode(items.map((e) => e.toMap()).toList());

  static List<CartItem> decodeList(String jsonStr) {
    final List<dynamic> decoded = json.decode(jsonStr);
    return decoded.map((item) => CartItem.fromMap(item)).toList();
  }
}
