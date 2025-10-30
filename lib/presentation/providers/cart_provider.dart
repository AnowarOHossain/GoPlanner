// Import Riverpod for state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Import cart item model
import '../../data/models/cart_item_model.dart';

// Main cart provider - manages list of cart items
// StateNotifier allows us to update the cart state
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItemModel>>((ref) {
  return CartNotifier();
});

// Provider to calculate total price of all items in cart
final cartTotalProvider = Provider<double>((ref) {
  final cartItems = ref.watch(cartProvider);
  // Add up all item total prices
  return cartItems.fold(0.0, (total, item) => total + item.totalPrice);
});

// Provider to count total number of items in cart
final cartItemCountProvider = Provider<int>((ref) {
  final cartItems = ref.watch(cartProvider);
  // Add up all item quantities
  return cartItems.fold(0, (total, item) => total + item.quantity);
});

// Cart state manager - handles all cart operations
class CartNotifier extends StateNotifier<List<CartItemModel>> {
  // Initialize with empty cart
  CartNotifier() : super([]);

  // Add item to cart or update quantity if already exists
  void addItem(CartItemModel item) {
    // Check if item already exists in cart
    final existingIndex = state.indexWhere(
      (cartItem) => cartItem.itemId == item.itemId && cartItem.type == item.type,
    );

    if (existingIndex != -1) {
      // Item exists - increase quantity
      final existingItem = state[existingIndex];
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + item.quantity,
      );

      // Update state with new quantity
      state = [
        ...state.sublist(0, existingIndex),
        updatedItem,
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      // Item doesn't exist - add to cart
      state = [...state, item];
    }
  }

  // Remove item from cart by ID
  void removeItem(String itemId) {
    state = state.where((item) => item.id != itemId).toList();
  }

  // Update quantity of specific item
  void updateQuantity(String itemId, int quantity) {
    // Remove item if quantity is 0 or negative
    if (quantity <= 0) {
      removeItem(itemId);
      return;
    }

    // Find item and update quantity
    final index = state.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      final updatedItem = state[index].copyWith(quantity: quantity);
      state = [
        ...state.sublist(0, index),
        updatedItem,
        ...state.sublist(index + 1),
      ];
    }
  }

  // Remove all items from cart
  void clearCart() {
    state = [];
  }

  // Calculate total amount in cart
  double get totalAmount {
    return state.fold(0.0, (total, item) => total + item.totalPrice);
  }

  // Get total number of items in cart
  int get itemCount {
    return state.fold(0, (total, item) => total + item.quantity);
  }
}