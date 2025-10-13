import 'package:equatable/equatable.dart';

enum ItemType {
  hotel,
  restaurant,
  attraction,
}

class CartItemModel extends Equatable {
  final String id;
  final String itemId;
  final String name;
  final ItemType type;
  final double price;
  final String currency;
  final int quantity;
  final DateTime? selectedDate;
  final int? nights; // for hotels
  final int? persons; // for restaurants/attractions
  final String? imageUrl;
  final Map<String, dynamic>? additionalData;

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

  double get totalPrice {
    switch (type) {
      case ItemType.hotel:
        return price * (nights ?? 1) * quantity;
      case ItemType.restaurant:
        return price * (persons ?? 1) * quantity;
      case ItemType.attraction:
        return price * (persons ?? 1) * quantity;
    }
  }

  String get formattedTotalPrice {
    return '$currency ${totalPrice.toStringAsFixed(2)}';
  }

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

  bool get isHotel => type == ItemType.hotel;
  bool get isRestaurant => type == ItemType.restaurant;
  bool get isAttraction => type == ItemType.attraction;
}