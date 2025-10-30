// Import Flutter widgets
import 'package:flutter/material.dart';

// Widget to load and display images from network with loading and error states
class ImageLoader extends StatelessWidget {
  final String imageUrl; // URL of the image to load
  final double? width; // Image width
  final double? height; // Image height
  final BoxFit fit; // How image should fit in the box
  final BorderRadius? borderRadius; // Rounded corners
  final Widget? placeholder; // Custom loading placeholder
  final Widget? errorWidget; // Custom error widget

  const ImageLoader({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // Apply rounded corners
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Container(
        width: width,
        height: height,
        child: Image.network(
          imageUrl,
          width: width,
          height: height,
          fit: fit,
          // Show placeholder while loading
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child; // Image loaded
            return placeholder ?? _buildDefaultPlaceholder();
          },
          // Show error widget if image fails to load
          errorBuilder: (context, error, stackTrace) {
            return errorWidget ?? _buildDefaultErrorWidget();
          },
        ),
      ),
    );
  }

  // Default loading indicator widget
  Widget _buildDefaultPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D5A)),
        ),
      ),
    );
  }

  // Default error display widget
  Widget _buildDefaultErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            size: 40,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            'Image not available',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Helper class for loading images in Container decorations
class DecorationImageLoader {
  // Create a DecorationImage from network URL
  static DecorationImage network(
    String imageUrl, {
    BoxFit fit = BoxFit.cover,
    Widget? errorWidget,
  }) {
    return DecorationImage(
      image: NetworkImage(imageUrl),
      fit: fit,
      // Handle image load errors
      onError: (exception, stackTrace) {
        print('Failed to load image: $imageUrl');
      },
    );
  }

  // Create a Container with background image and fallback
  static Widget networkContainer({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    Widget? child,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: Colors.grey[200],
      ),
      child: Stack(
        children: [
          // Fallback background - shows if image fails
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: Colors.grey[200],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image,
                  size: 40,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 8),
                Text(
                  'Image',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Actual image - loads on top of fallback
          ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.zero,
            child: Image.network(
              imageUrl,
              width: width,
              height: height,
              fit: fit,
              // If error, show nothing (fallback will be visible)
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox.shrink();
              },
            ),
          ),
          // Optional child widget overlay
          if (child != null) child,
        ],
      ),
    );
  }
}