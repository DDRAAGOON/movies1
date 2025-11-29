import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movies1/core/app_colors.dart';
import 'package:movies1/core/app_text_styles.dart';
import 'package:movies1/api/wishlist_service.dart';
import 'package:movies1/screens/movie_details/movie_details_screen.dart';

class WishListContent extends StatefulWidget {
  final VoidCallback onRefresh;

  const WishListContent({super.key, required this.onRefresh});

  @override
  State<WishListContent> createState() => _WishListContentState();
}

class _WishListContentState extends State<WishListContent> {
  List<Map<String, dynamic>> wishList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWishList();
  }

  Future<void> _loadWishList() async {
    setState(() {
      isLoading = true;
    });

    final movies = await WishListService.getWishList();
    setState(() {
      wishList = movies;
      isLoading = false;
    });
  }

  Future<void> _removeFromWishList(int movieId) async {
    await WishListService.removeFromWishList(movieId);
    _loadWishList();
    widget.onRefresh(); // Refresh count
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (wishList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/edit/popcorn.png',
              width: 124,
              height: 124,
            ),
            const SizedBox(height: 24),
            Text(
              'Your wish list is empty',
              style: AppStyle.med16white.copyWith(
                color: Colors.white54,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadWishList,
      color: AppColors.primary,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: wishList.length,
        itemBuilder: (context, index) {
          return _buildWishListMovieCard(wishList[index]);
        },
      ),
    );
  }

  Widget _buildWishListMovieCard(Map<String, dynamic> movie) {
    final int movieId = movie['id'] ?? 0;
    final String title = movie['title'] ?? 'Unknown';
    final String? imageUrl = movie['imageUrl'];
    final int year = movie['year'] ?? 0;
    final double rating = (movie['rating'] ?? 0.0).toDouble();

    return GestureDetector(
      onTap: () {
        if (movieId > 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailsScreen(movieId: movieId),
            ),
          ).then((_) {
            _loadWishList();
            widget.onRefresh();
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.gray,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            placeholder: (context, url) => Container(
                              color: AppColors.gray,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: AppColors.gray,
                              child: const Icon(
                                Icons.movie,
                                color: Colors.white54,
                                size: 48,
                              ),
                            ),
                          )
                        : Container(
                            color: AppColors.gray,
                            child: const Icon(
                              Icons.movie,
                              color: Colors.white54,
                              size: 48,
                            ),
                          ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppColors.primary,
                            size: 14,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            rating.toStringAsFixed(1),
                            style: AppStyle.med12white.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => _removeFromWishList(movieId),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: AppColors.red,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: AppStyle.med14white,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (year > 0)
                      Text(
                        year.toString(),
                        style: AppStyle.med12white.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

