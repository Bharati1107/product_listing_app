import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/cart_model.dart';
import '../../model/product_model.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  static const _cartKey = 'cartItems';

  CartNotifier() : super([]) {
    _loadCart();
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString(_cartKey);
    if (cartJson != null) {
      try {
        state = CartItem.decodeList(cartJson);
      } catch (_) {
        state = [];
      }
    }
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = CartItem.encodeList(state);
    await prefs.setString(_cartKey, encoded);
  }

  void addToCart(Product product) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == index)
            CartItem(product: product, quantity: state[i].quantity + 1)
          else
            state[i],
      ];
    } else {
      state = [...state, CartItem(product: product)];
    }
    _saveCart();
  }

  void decreaseQuantity(Product product) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      final currentQty = state[index].quantity;
      if (currentQty > 1) {
        state = [
          for (int i = 0; i < state.length; i++)
            if (i == index)
              CartItem(product: product, quantity: currentQty - 1)
            else
              state[i],
        ];
      } else {
        removeFromCart(product);
        return;
      }
      _saveCart();
    }
  }

  void removeFromCart(Product product) {
    state = state.where((item) => item.product.id != product.id).toList();
    _saveCart();
  }

  void clearCart() {
    state = [];
    _saveCart();
  }

  int get totalItems => state.fold(0, (sum, item) => sum + item.quantity);
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>(
  (ref) => CartNotifier(),
);
