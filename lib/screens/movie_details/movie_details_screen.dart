import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movies1/core/app_colors.dart';
import 'package:movies1/core/app_text_styles.dart';
import 'package:movies1/api/movie_service.dart';
import 'package:movies1/api/wishlist_service.dart';
import 'package:movies1/api/history_service.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  dynamic movieData;
  List<dynamic> similarMovies = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _loadMovieDetails();
    _checkBookmarkStatus();
  }

  Future<void> _checkBookmarkStatus() async {
    final isBooked = await WishListService.isInWishList(widget.movieId);
    setState(() {
      isBookmarked = isBooked;
    });
  }

  Future<void> _addToHistory(dynamic movie) async {
    try {
      final String title =
          movie['title_english'] ?? movie['title'] ?? 'Unknown';
      final String? imageUrl =
          movie['large_cover_image'] ?? movie['medium_cover_image'];
      final int year = movie['year'] ?? 0;
      final double rating = (movie['rating'] ?? 0.0).toDouble();

      await HistoryService.addToHistory(
        movieId: widget.movieId,
        title: title,
        imageUrl: imageUrl,
        year: year,
        rating: rating,
      );
    } catch (e) {}
  }

  Future<void> _loadMovieDetails() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final detailsResponse = await MovieService.getMovieDetails(
        movieId: widget.movieId,
        withImages: true,
        withCast: true,
      );

      final suggestionsResponse = await MovieService.getMovieSuggestions(
        movieId: widget.movieId,
      );

      if (detailsResponse.statusCode == 200 && detailsResponse.data != null) {
        final detailsData = detailsResponse.data;
        if (detailsData['status'] == 'ok' && detailsData['data'] != null) {
          final movie = detailsData['data']['movie'];
          setState(() {
            movieData = movie;
            isLoading = false;
          });

          _addToHistory(movie);
        } else {
          setState(() {
            hasError = true;
            errorMessage = 'Failed to load movie details';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          hasError = true;
          errorMessage = 'Failed to load movie details';
          isLoading = false;
        });
      }

      if (suggestionsResponse.statusCode == 200 &&
          suggestionsResponse.data != null) {
        final suggestionsData = suggestionsResponse.data;
        if (suggestionsData['status'] == 'ok' &&
            suggestionsData['data'] != null) {
          setState(() {
            similarMovies =
                suggestionsData['data']['movies'] as List<dynamic>? ?? [];
          });
        }
      }
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : hasError
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    errorMessage,
                    style: AppStyle.med16white,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadMovieDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : movieData == null
          ? const Center(
              child: Text(
                'Movie not found',
                style: TextStyle(color: AppColors.white),
              ),
            )
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: AppColors.black,
                  pinned: true,
                  leading: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.gray,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  title: Text('Movie Details', style: AppStyle.med20white),
                  actions: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.gray,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: AppColors.primary,
                        ),
                        onPressed: () async {
                          if (movieData == null) return;

                          if (isBookmarked) {
                            await WishListService.removeFromWishList(
                              widget.movieId,
                            );
                          } else {
                            final String title =
                                movieData['title_english'] ??
                                movieData['title'] ??
                                'Unknown';
                            final String? imageUrl =
                                movieData['large_cover_image'] ??
                                movieData['medium_cover_image'];
                            final int year = movieData['year'] ?? 0;
                            final double rating = (movieData['rating'] ?? 0.0)
                                .toDouble();

                            await WishListService.addToWishList(
                              movieId: widget.movieId,
                              title: title,
                              imageUrl: imageUrl,
                              year: year,
                              rating: rating,
                            );
                          }
                          setState(() {
                            isBookmarked = !isBookmarked;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                SliverToBoxAdapter(child: _buildMoviePoster()),

                SliverToBoxAdapter(child: _buildMovieTitle()),

                SliverToBoxAdapter(child: _buildWatchButton()),

                SliverToBoxAdapter(child: _buildStatistics()),

                SliverToBoxAdapter(child: _buildScreenShots()),

                SliverToBoxAdapter(child: _buildSimilarMovies()),

                SliverToBoxAdapter(child: _buildSummary()),

                SliverToBoxAdapter(child: _buildCast()),

                SliverToBoxAdapter(child: _buildGenres()),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
    );
  }

  Widget _buildMoviePoster() {
    final String? imageUrl =
        movieData['large_cover_image'] ??
        movieData['medium_cover_image'] ??
        movieData['background_image'];

    return Stack(
      alignment: Alignment.center,
      children: [
        imageUrl != null
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                width: double.infinity,
                height: 400,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 400,
                  color: AppColors.gray,
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 400,
                  color: AppColors.gray,
                  child: const Icon(
                    Icons.movie,
                    color: Colors.white54,
                    size: 64,
                  ),
                ),
              )
            : Container(
                height: 400,
                color: AppColors.gray,
                child: const Icon(Icons.movie, color: Colors.white54, size: 64),
              ),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.play_arrow, color: AppColors.white, size: 48),
        ),
      ],
    );
  }

  Widget _buildMovieTitle() {
    final String title = movieData['title'] ?? 'Unknown';
    final int year = movieData['year'] ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppStyles.bold20White.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (year > 0) ...[
            const SizedBox(height: 8),
            Text(
              year.toString(),
              style: AppStyle.med14white.copyWith(color: Colors.white70),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWatchButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.red,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Watch',
            style: AppStyle.med16white.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildStatistics() {
    final int likes = movieData['like_count'] ?? 0;
    final int runtime = movieData['runtime'] ?? 0;
    final double rating = (movieData['rating'] ?? 0.0).toDouble();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(Icons.favorite, AppColors.primary, likes.toString()),
          _buildStatItem(Icons.access_time, AppColors.primary, '$runtime'),
          _buildStatItem(
            Icons.star,
            AppColors.primary,
            rating.toStringAsFixed(1),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, Color color, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.gray,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(value, style: AppStyle.med14white),
        ],
      ),
    );
  }

  Widget _buildScreenShots() {
    final List<dynamic> screenshots = movieData['screenshots'] ?? [];

    if (screenshots.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            'Screen Shots',
            style: AppStyles.bold20White.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: screenshots.length,
            itemBuilder: (context, index) {
              final String imageUrl = screenshots[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 300,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 300,
                      color: AppColors.gray,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 300,
                      color: AppColors.gray,
                      child: const Icon(
                        Icons.image,
                        color: Colors.white54,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSimilarMovies() {
    if (similarMovies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            'Similar',
            style: AppStyles.bold20White.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: similarMovies.length > 4 ? 4 : similarMovies.length,
            itemBuilder: (context, index) {
              return _buildSimilarMovieCard(similarMovies[index]);
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSimilarMovieCard(dynamic movie) {
    final String? imageUrl =
        movie['medium_cover_image'] ?? movie['large_cover_image'];
    final String title = movie['title'] ?? 'Unknown';
    final double rating = (movie['rating'] ?? 0.0).toDouble();

    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailsScreen(movieId: movie['id'] ?? 0),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.gray,
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
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
                          size: 32,
                        ),
                      ),
                    )
                  : Container(
                      color: AppColors.gray,
                      child: const Icon(
                        Icons.movie,
                        color: Colors.white54,
                        size: 32,
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
                    const Icon(Icons.star, color: AppColors.primary, size: 12),
                    const SizedBox(width: 2),
                    Text(
                      rating.toStringAsFixed(1),
                      style: AppStyle.med12white.copyWith(
                        fontWeight: FontWeight.bold,
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

  Widget _buildSummary() {
    final String description =
        movieData['description_full'] ??
        movieData['description_intro'] ??
        movieData['synopsis'] ??
        'No description available.';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Summary',
            style: AppStyles.bold20White.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: AppStyle.med14white.copyWith(
              height: 1.6,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCast() {
    final List<dynamic> cast = movieData['cast'] ?? [];

    if (cast.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cast',
            style: AppStyles.bold20White.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...cast.take(4).map((actor) => _buildCastItem(actor)).toList(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCastItem(dynamic actor) {
    final String name = actor['name'] ?? 'Unknown';
    final String character = actor['character_name'] ?? 'Unknown';
    final String? imageUrl = actor['url_small_image'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.gray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 60,
                      height: 60,
                      color: AppColors.black,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 60,
                      height: 60,
                      color: AppColors.black,
                      child: const Icon(
                        Icons.person,
                        color: Colors.white54,
                        size: 32,
                      ),
                    ),
                  )
                : Container(
                    width: 60,
                    height: 60,
                    color: AppColors.black,
                    child: const Icon(
                      Icons.person,
                      color: Colors.white54,
                      size: 32,
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name : $name',
                  style: AppStyle.med14white.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Character : $character',
                  style: AppStyle.med12white.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenres() {
    final List<dynamic> genres = movieData['genres'] ?? [];

    if (genres.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Genres',
            style: AppStyles.bold20White.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: genres.map((genre) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gray,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(genre.toString(), style: AppStyle.med14white),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
