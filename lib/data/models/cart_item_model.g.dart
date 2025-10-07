// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) =>
    CartItemModel(
      id: json['id'] as String,
      itemId: json['itemId'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$ItemTypeEnumMap, json['type']),
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      selectedDate: json['selectedDate'] == null
          ? null
          : DateTime.parse(json['selectedDate'] as String),
      nights: (json['nights'] as num?)?.toInt(),
      persons: (json['persons'] as num?)?.toInt(),
      imageUrl: json['imageUrl'] as String?,
      additionalData: json['additionalData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$CartItemModelToJson(CartItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemId': instance.itemId,
      'name': instance.name,
      'type': _$ItemTypeEnumMap[instance.type]!,
      'price': instance.price,
      'currency': instance.currency,
      'quantity': instance.quantity,
      'selectedDate': instance.selectedDate?.toIso8601String(),
      'nights': instance.nights,
      'persons': instance.persons,
      'imageUrl': instance.imageUrl,
      'additionalData': instance.additionalData,
    };

const _$ItemTypeEnumMap = {
  ItemType.hotel: 'hotel',
  ItemType.restaurant: 'restaurant',
  ItemType.attraction: 'attraction',
};
