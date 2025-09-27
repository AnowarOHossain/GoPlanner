import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/cart_item_model.dart';

part 'cart_provider.g.dart';

@riverpod
class CartNotifier extends _$CartNotifier {
  @override
  List<CartItemModel> build() {
    return [];
  }

  void addItem(CartItemModel item) {
    // Check if item already exists
    final existingIndex = state.indexWhere(
      (cartItem) => cartItem.itemId == item.itemId && cartItem.type == item.type,
    );

    if (existingIndex != -1) {
      // Update quantity if item exists
      final existingItem = state[existingIndex];
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + item.quantity,
      );
      
      state = [
        ...state.sublist(0, existingIndex),
        updatedItem,
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      // Add new item
      state = [...state, item];
    }
  }

  void removeItem(String itemId) {
    state = state.where((item) => item.id != itemId).toList();
  }

  void updateItemQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeItem(itemId);
      return;
    }

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

  void clearCart() {
    state = [];
  }

  double get totalAmount {
    return state.fold(0.0, (total, item) => total + item.totalPrice);
  }

  int get itemCount {
    return state.fold(0, (total, item) => total + item.quantity);
  }

  Map<ItemType, List<CartItemModel>> get itemsByType {
    final Map<ItemType, List<CartItemModel>> grouped = {};
    
    for (final item in state) {
      if (!grouped.containsKey(item.type)) {
        grouped[item.type] = [];
      }
      grouped[item.type]!.add(item);
    }
    
    return grouped;
  }

  String formattedTotalAmount(String currency) {
    return '${currency} ${totalAmount.toStringAsFixed(2)}';
  }
}

// Cart summary provider
@riverpod
CartSummary cartSummary(CartSummaryRef ref) {
  final cart = ref.watch(cartNotifierProvider);
  
  final hotelItems = cart.where((item) => item.type == ItemType.hotel).toList();
  final restaurantItems = cart.where((item) => item.type == ItemType.restaurant).toList();
  final attractionItems = cart.where((item) => item.type == ItemType.attraction).toList();
  
  return CartSummary(
    totalItems: cart.length,
    totalAmount: cart.fold(0.0, (sum, item) => sum + item.totalPrice),
    hotelCount: hotelItems.length,
    restaurantCount: restaurantItems.length,
    attractionCount: attractionItems.length,
    hotelCost: hotelItems.fold(0.0, (sum, item) => sum + item.totalPrice),
    restaurantCost: restaurantItems.fold(0.0, (sum, item) => sum + item.totalPrice),
    attractionCost: attractionItems.fold(0.0, (sum, item) => sum + item.totalPrice),
  );
}

class CartSummary {
  final int totalItems;
  final double totalAmount;
  final int hotelCount;
  final int restaurantCount;
  final int attractionCount;
  final double hotelCost;
  final double restaurantCost;
  final double attractionCost;

  const CartSummary({
    required this.totalItems,
    required this.totalAmount,
    required this.hotelCount,
    required this.restaurantCount,
    required this.attractionCount,
    required this.hotelCost,
    required this.restaurantCost,
    required this.attractionCost,
  });

  String formattedTotalAmount(String currency) {
    return '${currency} ${totalAmount.toStringAsFixed(2)}';
  }

  String formattedHotelCost(String currency) {
    return '${currency} ${hotelCost.toStringAsFixed(2)}';
  }

  String formattedRestaurantCost(String currency) {
    return '${currency} ${restaurantCost.toStringAsFixed(2)}';
  }

  String formattedAttractionCost(String currency) {
    return '${currency} ${attractionCost.toStringAsFixed(2)}';
  }
}