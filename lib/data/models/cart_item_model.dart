// Import Equatable to compare objects easily
import 'package:equatable/equatable.dart';

// Define types of items that can be added to cart
enum ItemType {
  hotel, // Hotel booking
  restaurant, // Restaurant reservation
  attraction, // Attraction ticket
}

// Cart item data model - represents an item in the shopping cart
class CartItemModel extends Equatable {
  // Basic item information
  final String id; // Unique cart item ID
  final String itemId; // Original item ID (hotel/restaurant/attraction ID)
  final String name; // Item name
  final ItemType type; // Type of item
  
  // Pricing
  final double price; // Price per unit
  final String currency; // Currency (e.g., BDT)
  final int quantity; // Number of items
  
  // Date and booking details
  final DateTime? selectedDate; // Selected date for visit/booking
  final int? nights; // Number of nights (for hotels)
  final int? persons; // Number of persons (for restaurants/attractions)
  
  // Display information
  final String? imageUrl; // Item image
  final Map<String, dynamic>? additionalData; // Extra information

  // Constructor to create cart item object
  const CartItemModel({
    required this.id,
    required this.itemId,
    required this.name,
    required this.type,
    required this.price,
    required this.currency,
    this.quantity = 1,
    this.selectedDate,
    this.nights,
    this.persons,
    this.imageUrl,
    this.additionalData,
  });

  // Create cart item from JSON data
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      itemId: json['itemId'] as String,
      name: json['name'] as String,
      type: ItemType.values.firstWhere((e) => e.name == json['type'] as String),
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      quantity: json['quantity'] as int? ?? 1,
      selectedDate: json['selectedDate'] != null ? DateTime.parse(json['selectedDate'] as String) : null,
      nights: json['nights'] as int?,
      persons: json['persons'] as int?,
      imageUrl: json['imageUrl'] as String?,
      additionalData: json['additionalData'] as Map<String, dynamic>?,
    );
  }

  // Convert cart item to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemId': itemId,
      'name': name,
      'type': type.name,
      'price': price,
      'currency': currency,
      'quantity': quantity,
      'selectedDate': selectedDate?.toIso8601String(),
      'nights': nights,
      'persons': persons,
      'imageUrl': imageUrl,
      'additionalData': additionalData,
    };
  }

  // Properties to compare for equality
  @override
  List<Object?> get props => [
        id,
        itemId,
        name,
        type,
        price,
        currency,
        quantity,
        selectedDate,
        nights,
        persons,
        imageUrl,
        additionalData,
      ];

  // Create a copy of cart item with some fields changed
  CartItemModel copyWith({
    String? id,
    String? itemId,
    String? name,
    ItemType? type,
    double? price,
    String? currency,
    int? quantity,
    DateTime? selectedDate,
    int? nights,
    int? persons,
    String? imageUrl,
    Map<String, dynamic>? additionalData,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      name: name ?? this.name,
      type: type ?? this.type,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      quantity: quantity ?? this.quantity,
      selectedDate: selectedDate ?? this.selectedDate,
      nights: nights ?? this.nights,
      persons: persons ?? this.persons,
      imageUrl: imageUrl ?? this.imageUrl,
      additionalData: additionalData ?? this.additionalData,
    );
  }

  // Calculate total price based on item type
  double get totalPrice {
    switch (type) {
      case ItemType.hotel:
        // Hotel: price * nights * quantity
        return price * (nights ?? 1) * quantity;
      case ItemType.restaurant:
        // Restaurant: price * persons * quantity
        return price * (persons ?? 1) * quantity;
      case ItemType.attraction:
        // Attraction: price * persons * quantity
        return price * (persons ?? 1) * quantity;
    }
  }

  // Get formatted total price with currency
  String get formattedTotalPrice {
    return '$currency ${totalPrice.toStringAsFixed(2)}';
  }

  // Get item type as string
  String get typeString {
    switch (type) {
      case ItemType.hotel:
        return 'Hotel';
      case ItemType.restaurant:
        return 'Restaurant';
      case ItemType.attraction:
        return 'Attraction';
    }
  }

  // Check if item is a specific type
  bool get isHotel => type == ItemType.hotel;
  bool get isRestaurant => type == ItemType.restaurant;
  bool get isAttraction => type == ItemType.attraction;
}