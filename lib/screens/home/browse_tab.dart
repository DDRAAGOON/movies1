import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movies1/core/app_colors.dart';
import 'package:movies1/core/app_text_styles.dart';
import 'package:movies1/api/movie_service.dart';
import 'package:movies1/screens/movie_details/movie_details_screen.dart';

class BrowseTab extends StatefulWidget {
  final String? initialGenre;
  
  const BrowseTab({super.key, this.initialGenre});

  @override
  State<BrowseTab> createState() => BrowseTabState();
}

class BrowseTabState extends State<BrowseTab> {
  final List<String> genres = [
    'All',
    'Action',
    'Adventure',
    'Animation',
    'Biography',
    'Comedy',
    'Crime',
    'Documentary',
    'Drama',
    'Family',
    'Fantasy',
    'History',
    'Horror',
    'Music',
    'Musical',
    'Mystery',
    'Romance',
    'Sci-Fi',
    'Sport',
    'Thriller',
    'War',
    'Western',
  ];

  String selectedGenre = 'Action';
  List<dynamic> movies = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;

  void selectGenre(String genre) {
    if (selectedGenre != genre) {
      setState(() {
        selectedGenre = genre;
      });
      _loadMovies(isRefresh: true);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialGenre != null) {
      selectedGenre = widget.initialGenre!;
    }
    _loadMovies();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(BrowseTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialGenre != null && widget.initialGenre != oldWidget.initialGenre) {
      selectedGenre = widget.initialGenre!;
      _loadMovies(isRefresh: true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
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

  Future<void> _loadMovies({bool isRefresh = false}) async {
    if (isRefresh) {
      setState(() {
        currentPage = 1;
        movies = [];
      });
    }

    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final response = selectedGenre == 'All'
          ? await MovieService.getLatestMovies(
              limit: 20,
              page: currentPage,
            )
          : await MovieService.getMoviesByGenre(
              genre: selectedGenre,
              limit: 20,
              page: currentPage,
            );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data['status'] == 'ok' && data['data'] != null) {
          final newMovies = data['data']['movies'] as List<dynamic>? ?? [];
          setState(() {
            if (isRefresh) {
              movies = newMovies;
            } else {
              movies.addAll(newMovies);
            }
            isLoading = false;
          });
        } else {
          setState(() {
            hasError = true;
            errorMessage = data['status_message'] ?? 'Failed to load movies';
            isLoading = false;
          });
        }
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
      final response = selectedGenre == 'All'
          ? await MovieService.getLatestMovies(
              limit: 20,
              page: currentPage,
            )
          : await MovieService.getMoviesByGenre(
              genre: selectedGenre,
              limit: 20,
              page: currentPage,
            );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data['status'] == 'ok' && data['data'] != null) {
          final newMovies = data['data']['movies'] as List<dynamic>? ?? [];
          setState(() {
            movies.addAll(newMovies);
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

  void _onGenreSelected(String genre) {
    if (selectedGenre != genre) {
      setState(() {
        selectedGenre = genre;
        currentPage = 1;
        movies = [];
      });
      _loadMovies(isRefresh: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: genres.length,
                itemBuilder: (context, index) {
                  final genre = genres[index];
                  final isSelected = selectedGenre == genre;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => _onGenreSelected(genre),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            genre,
                            style: AppStyle.med14white.copyWith(
                              color: isSelected
                                  ? AppColors.black
                                  : AppColors.primary,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _loadMovies(isRefresh: true),
                color: AppColors.primary,
                child: _buildContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading && movies.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (hasError && movies.isEmpty) {
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
              onPressed: () => _loadMovies(isRefresh: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: movies.length + (isLoading ? 2 : 0),
      itemBuilder: (context, index) {
        if (index < movies.length) {
          return _buildMovieCard(movies[index]);
        } else if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }
        return null;
      },
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
