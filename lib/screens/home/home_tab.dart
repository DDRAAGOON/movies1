import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movies1/core/app_colors.dart';
import 'package:movies1/core/app_text_styles.dart';
import 'package:movies1/api/movie_service.dart';
import 'package:movies1/screens/movie_details/movie_details_screen.dart';

class HomeTab extends StatefulWidget {
  final Function(String)? onGenreSelected;
  
  const HomeTab({super.key, this.onGenreSelected});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<dynamic> availableMovies = [];
  List<dynamic> actionMovies = [];
  List<dynamic> allMovies = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController(viewportFraction: 0.8);

  @override
  void initState() {
    super.initState();
    _loadAllData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      if (!isLoading) {
        _loadMoreMovies();
      }
    }
  }

  Future<void> _loadAllData() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      // Load Available Now movies (latest)
      final availableResponse = await MovieService.getLatestMovies(limit: 10, page: 1);
      
      // Load Action movies
      final actionResponse = await MovieService.getMoviesByGenre(
        genre: 'Action',
        limit: 10,
        page: 1,
      );

      // Load all movies for grid
      final allResponse = await MovieService.getLatestMovies(
        limit: 20,
        page: currentPage,
      );

      if (availableResponse.statusCode == 200 && 
          actionResponse.statusCode == 200 && 
          allResponse.statusCode == 200) {
        
        final availableData = availableResponse.data;
        final actionData = actionResponse.data;
        final allData = allResponse.data;

        setState(() {
          if (availableData['status'] == 'ok' && availableData['data'] != null) {
            availableMovies = availableData['data']['movies'] as List<dynamic>? ?? [];
          }
          
          if (actionData['status'] == 'ok' && actionData['data'] != null) {
            actionMovies = actionData['data']['movies'] as List<dynamic>? ?? [];
          }
          
          if (allData['status'] == 'ok' && allData['data'] != null) {
            allMovies = allData['data']['movies'] as List<dynamic>? ?? [];
          }
          
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          errorMessage = 'Failed to load movies';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<void> _loadMoreMovies() async {
    if (isLoading) return;

    setState(() {
      currentPage++;
    });

    try {
      final response = await MovieService.getLatestMovies(
        limit: 20,
        page: currentPage,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data['status'] == 'ok' && data['data'] != null) {
          final newMovies = data['data']['movies'] as List<dynamic>? ?? [];
          setState(() {
            allMovies.addAll(newMovies);
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        currentPage--;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadAllData,
          color: AppColors.primary,
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading && availableMovies.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (hasError && availableMovies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              style: AppStyle.med16white,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadAllData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Available Now Section
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Available Now',
                  style: AppStyles.bold20White.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 280,
                child: availableMovies.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    : PageView.builder(
                        controller: _pageController,
                        itemCount: availableMovies.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: _buildCarouselMovieCard(availableMovies[index]),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),

        // Watch Now Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Watch Now',
              style: AppStyles.bold20White.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Action Section
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Action',
                      style: AppStyle.med20white,
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to browse with Action filter
                        if (widget.onGenreSelected != null) {
                          widget.onGenreSelected!('Action');
                        }
                      },
                      child: Text(
                        'See More →',
                        style: AppStyle.med14primary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 200,
                child: actionMovies.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: actionMovies.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: _buildHorizontalMovieCard(actionMovies[index]),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),

        // All Movies Grid
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index < allMovies.length) {
                  return _buildMovieCard(allMovies[index]);
                } else if (isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                }
                return null;
              },
              childCount: allMovies.length + (isLoading ? 2 : 0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselMovieCard(dynamic movie) {
    final String? imageUrl = movie['large_cover_image'] ?? movie['medium_cover_image'];
    final String title = movie['title'] ?? 'Unknown';
    final double rating = (movie['rating'] ?? 0.0).toDouble();

    final int movieId = movie['id'] ?? 0;
    
    return GestureDetector(
      onTap: () {
        if (movieId > 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailsScreen(movieId: movieId),
            ),
          );
        }
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
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
          // Rating Badge
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    size: 16,
                  ),
                  const SizedBox(width: 4),
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
          // Title at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              child: Text(
                title,
                style: AppStyle.med16white.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalMovieCard(dynamic movie) {
    final String? imageUrl = movie['medium_cover_image'] ?? movie['large_cover_image'];
    final String title = movie['title'] ?? 'Unknown';
    final double rating = (movie['rating'] ?? 0.0).toDouble();
    final int movieId = movie['id'] ?? 0;

    return GestureDetector(
      onTap: () {
        if (movieId > 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailsScreen(movieId: movieId),
            ),
          );
        }
      },
      child: SizedBox(
        width: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: imageUrl != null
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
                  // Rating Badge
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppColors.primary,
                            size: 12,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            rating.toStringAsFixed(1),
                            style: AppStyle.med12white.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppStyle.med14white,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieCard(dynamic movie) {
    final String? imageUrl = movie['medium_cover_image'] ?? movie['large_cover_image'];
    final String title = movie['title'] ?? 'Unknown';
    final int year = movie['year'] ?? 0;
    final double rating = (movie['rating'] ?? 0.0).toDouble();
    final int movieId = movie['id'] ?? 0;

    return GestureDetector(
      onTap: () {
        if (movieId > 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailsScreen(movieId: movieId),
            ),
          );
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
            // Movie Poster with Rating Badge
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: imageUrl != null
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
                  // Rating Badge in top left corner
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
                ],
              ),
            ),
            // Movie Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
                    Text(
                      title,
                      style: AppStyle.med14white,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Year
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
