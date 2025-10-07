import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/hotel_model.dart';
import '../../data/models/location_model.dart';

// Sample data providers
final hotelsProvider = Provider<List<HotelModel>>((ref) {
  return [
    HotelModel(
      id: '1',
      name: 'Grand Palace Hotel',
      description: 'Luxury hotel in the heart of the city',
      images: ['https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800'],
      location: const LocationModel(
        latitude: 40.7128,
        longitude: -74.0060,
        address: '123 Main St',
        city: 'New York',
        country: 'USA',
      ),
      rating: 4.5,
      reviewCount: 150,
      pricePerNight: 150.0,
      currency: 'USD',
      amenities: ['WiFi', 'Pool', 'Spa', 'Restaurant'],
      category: 'luxury',
      isAvailable: true,
    ),
    HotelModel(
      id: '2',
      name: 'Seaside Resort',
      description: 'Beautiful oceanfront resort',
      images: ['https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800'],
      location: const LocationModel(
        latitude: 40.7580,
        longitude: -73.9855,
        address: '456 Beach Ave',
        city: 'New York',
        country: 'USA',
      ),
      rating: 4.8,
      reviewCount: 200,
      pricePerNight: 200.0,
      currency: 'USD',
      amenities: ['Beach Access', 'Pool', 'Restaurant', 'Spa'],
      category: 'luxury',
      isAvailable: true,
    ),
  ];
});

// Simple search provider
final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredHotelsProvider = Provider<List<HotelModel>>((ref) {
  final hotels = ref.watch(hotelsProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  
  if (searchQuery.isEmpty) return hotels;
  
  return hotels.where((hotel) =>
    hotel.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
    hotel.location.city.toLowerCase().contains(searchQuery.toLowerCase())
  ).toList();
});