// Import Flutter widgets
import 'package:flutter/material.dart';
// Import cached network image for efficient image loading
import 'package:cached_network_image/cached_network_image.dart';
// Import Riverpod for state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Import app colors and theme
import '../../core/constants/app_colors.dart';
import '../../presentation/theme/app_theme.dart';
// Import cart item model
import '../../data/models/cart_item_model.dart';
// Import favorites provider
import '../providers/favorites_provider.dart';

// Reusable card widget for displaying hotels, restaurants, and attractions
// Shows image, name, rating, price, location with favorite button
class ItemCard extends ConsumerWidget {
  final String id; // Item unique ID
  final String name; // Item name
  final String imageUrl; // Image URL
  final double rating; // Rating out of 5
  final int reviewCount; // Number of reviews
  final String priceText; // Price display text
  final String category; // Category (luxury, budget, etc.)
  final String location; // Location text
  final List<String> tags; // Feature tags
  final VoidCallback? onTap; // When card is tapped
  final VoidCallback? onAddToCart; // When add to cart is tapped
  final ItemType itemType; // Type (hotel, restaurant, attraction)

  const ItemCard({
    super.key,
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.priceText,
    required this.category,
    required this.location,
    required this.tags,
    required this.itemType,
    this.onTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check if item is in favorites
    final isFavorite = ref.watch(favoritesNotifierProvider.notifier).isFavorite(id, itemType);

    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section with favorite button overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 180,
                      color: AppColors.grey200,
                      child: const Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 180,
                      color: AppColors.grey200,
                      child: const Icon(Icons.image_not_supported, size: 50, color: AppColors.grey500),
                    ),
                  ),
                ),
                // Favorite button overlay on top-right corner
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withValues(alpha: 0.9),
                    radius: 20,
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : AppColors.grey600,
                        size: 20,
                      ),
                      // Toggle favorite status when pressed
                      onPressed: () => _toggleFavorite(ref),
                    ),
                  ),
                ),
                // Category badge overlay on top-left corner showing item type
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      category,
                      style: AppTextStyles.labelSmall.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            // Content section with item details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Item name and rating in a row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: AppTextStyles.heading4,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      RatingWidget(rating: rating, reviewCount: reviewCount),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Location display with pin icon
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: AppColors.grey600),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: AppTextStyles.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Feature tags (show maximum 3 tags)
                  if (tags.isNotEmpty)
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: tags.take(3).map((tag) => TagChip(label: tag)).toList(),
                    ),
                  const SizedBox(height: 12),
                  // Bottom row with price and add to cart button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price display in primary color
                      Text(
                        priceText,
                        style: AppTextStyles.heading4.copyWith(color: AppColors.primary),
                      ),
                      // Show add to budget button only if callback is provided
                      if (onAddToCart != null)
                        ElevatedButton.icon(
                          onPressed: onAddToCart,
                          icon: const Icon(Icons.analytics, size: 16),
                          label: const Text('Add to Budget'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Toggle favorite status - add or remove from favorites
  void _toggleFavorite(WidgetRef ref) {
    final favoritesNotifier = ref.read(favoritesNotifierProvider.notifier);
    
    if (favoritesNotifier.isFavorite(id, itemType)) {
      // Remove from favorites if already favorited
      favoritesNotifier.removeFromFavorites(id, itemType);
    } else {
      // Add to favorites if not yet favorited
      // This would require importing the appropriate model
      // favoritesNotifier.addToFavorites(favoriteItem);
    }
  }

  // Get color for category badge based on item type
  Color _getCategoryColor() {
    switch (itemType) {
      case ItemType.hotel:
        return AppColors.hotel; // Blue for hotels
      case ItemType.restaurant:
        return AppColors.restaurant; // Orange for restaurants
      case ItemType.attraction:
        return AppColors.attraction; // Green for attractions
    }
  }
}

// Rating display widget showing star icon, rating number, and review count
class RatingWidget extends StatelessWidget {
  final double rating; // Rating value (0-5)
  final int reviewCount; // Number of reviews
  final double size; // Icon size

  const RatingWidget({
    super.key,
    required this.rating,
    required this.reviewCount,
    this.size = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Gold star icon
        Icon(
          Icons.star,
          size: size,
          color: AppColors.ratingGold,
        ),
        const SizedBox(width: 2),
        // Rating number with 1 decimal place
        Text(
          rating.toStringAsFixed(1),
          style: AppTextStyles.labelMedium.copyWith(
            fontSize: size * 0.9,
            fontWeight: FontWeight.w600,
          ),
        ),
        // Review count in parentheses
        Text(
          ' ($reviewCount)',
          style: AppTextStyles.labelSmall.copyWith(
            fontSize: size * 0.8,
            color: AppColors.grey600,
          ),
        ),
      ],
    );
  }
}

// Tag chip widget for displaying feature tags like "WiFi", "Pool", etc.
class TagChip extends StatelessWidget {
  final String label; // Tag text
  final Color? backgroundColor; // Optional background color
  final Color? textColor; // Optional text color

  const TagChip({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    // Container with rounded background for the tag
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.grey200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: textColor ?? AppColors.grey700,
        ),
      ),
    );
  }
}

// Search bar widget with filter button for searching items
class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller; // Text input controller
  final String hintText; // Placeholder text
  final VoidCallback? onFilterTap; // Filter button callback
  final ValueChanged<String>? onChanged; // Text change callback
  final VoidCallback? onClear; // Clear button callback

  const SearchBarWidget({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
    this.onFilterTap,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Search text field
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                prefixIcon: const Icon(Icons.search, color: AppColors.grey500),
                // Show clear button only when text is not empty
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.grey500),
                        onPressed: () {
                          controller.clear();
                          onClear?.call();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.grey100,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
          ),
          // Show filter button if callback is provided
          if (onFilterTap != null) ...[
            const SizedBox(width: 12),
            CircleAvatar(
              backgroundColor: AppColors.primary,
              child: IconButton(
                icon: const Icon(Icons.tune, color: Colors.white),
                onPressed: onFilterTap,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Horizontal scrolling row of filter chips for category selection
class FilterChipRow extends StatelessWidget {
  final List<FilterOption> options; // Available filter options
  final List<String> selectedValues; // Currently selected values
  final ValueChanged<String> onChanged; // Selection change callback

  const FilterChipRow({
    super.key,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Horizontal scrolling list of filter chips
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: options.map((option) {
          // Check if this option is currently selected
          final isSelected = selectedValues.contains(option.value);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            // Filter chip with selection state
            child: FilterChip(
              selected: isSelected,
              label: Text(option.label),
              onSelected: (_) => onChanged(option.value),
              backgroundColor: AppColors.grey200,
              selectedColor: AppColors.primary,
              checkmarkColor: Colors.white,
              // Change text color based on selection
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.grey700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Filter option data class for filter chips
class FilterOption {
  final String value; // Internal value
  final String label; // Display text

  const FilterOption({
    required this.value,
    required this.label,
  });
}

// Loading widget with circular progress indicator and optional message
class LoadingWidget extends StatelessWidget {
  final String? message; // Optional loading message

  const LoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circular loading spinner
          const CircularProgressIndicator(color: AppColors.primary),
          // Show message if provided
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

// Error widget with icon, message, and optional retry button
class ErrorWidget extends StatelessWidget {
  final String message; // Error message to display
  final VoidCallback? onRetry; // Optional retry callback

  const ErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error icon
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            // Error title
            const Text(
              'Oops! Something went wrong',
              style: AppTextStyles.heading3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Error message
            Text(
              message,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            // Show retry button if callback is provided
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}