import 'package:dio/dio.dart';
import 'api_const.dart';

class MovieService {
  static final Dio _ytsDio = Dio(
    BaseOptions(
      baseUrl: ApiConst.movieBaseUrl,
      receiveDataWhenStatusError: true,
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  static Future<Response> listMovies({
    int? limit,
    int? page,
    String? quality,
    int? minimumRating,
    String? queryTerm,
    String? genre,
    String? sortBy,
    String? orderBy,
    bool? withRtRatings,
  }) async {
    final Map<String, dynamic> queryParams = {};
    
    if (limit != null) queryParams['limit'] = limit;
    if (page != null) queryParams['page'] = page;
    if (quality != null) queryParams['quality'] = quality;
    if (minimumRating != null) queryParams['minimum_rating'] = minimumRating;
    if (queryTerm != null && queryTerm.isNotEmpty) queryParams['query_term'] = queryTerm;
    if (genre != null && genre != 'All') queryParams['genre'] = genre;
    if (sortBy != null) queryParams['sort_by'] = sortBy;
    if (orderBy != null) queryParams['order_by'] = orderBy;
    if (withRtRatings != null) queryParams['with_rt_ratings'] = withRtRatings;

    return await _ytsDio.get(
      'list_movies.json',
      queryParameters: queryParams,
    );
  }

  static Future<Response> getMovieDetails({
    int? movieId,
    String? imdbId,
    bool? withImages,
    bool? withCast,
  }) async {
    final Map<String, dynamic> queryParams = {};
    
    if (movieId != null) {
      queryParams['movie_id'] = movieId;
    } else if (imdbId != null) {
      queryParams['imdb_id'] = imdbId;
    }
    
    if (withImages != null) queryParams['with_images'] = withImages;
    if (withCast != null) queryParams['with_cast'] = withCast;

    return await _ytsDio.get(
      'movie_details.json',
      queryParameters: queryParams,
    );
  }


  static Future<Response> getMovieSuggestions({
    required int movieId,
  }) async {
    return await _ytsDio.get(
      'movie_suggestions.json',
      queryParameters: {'movie_id': movieId},
    );
  }

  static Future<Response> getMovieParentalGuides({
    required int movieId,
  }) async {
    return await _ytsDio.get(
      'movie_parental_guides.json',
      queryParameters: {'movie_id': movieId},
    );
  }

  static Future<Response> searchMovies({
    required String query,
    int? limit,
    int? page,
    String? sortBy,
    String? orderBy,
  }) async {
    return await listMovies(
      queryTerm: query,
      limit: limit,
      page: page,
      sortBy: sortBy ?? 'date_added',
      orderBy: orderBy ?? 'desc',
    );
  }

  static Future<Response> getTrendingMovies({
    int? limit,
    int? page,
  }) async {
    return await listMovies(
      limit: limit ?? 20,
      page: page ?? 1,
      sortBy: 'download_count',
      orderBy: 'desc',
    );
  }

  static Future<Response> getLatestMovies({
    int? limit,
    int? page,
  }) async {
    return await listMovies(
      limit: limit ?? 20,
      page: page ?? 1,
      sortBy: 'date_added',
      orderBy: 'desc',
    );
  }

  static Future<Response> getMoviesByGenre({
    required String genre,
    int? limit,
    int? page,
    String? sortBy,
  }) async {
    return await listMovies(
      genre: genre,
      limit: limit ?? 20,
      page: page ?? 1,
      sortBy: sortBy ?? 'date_added',
      orderBy: 'desc',
    );
  }

  static Future<Response> getMoviesByQuality({
    required String quality,
    int? limit,
    int? page,
  }) async {
    return await listMovies(
      quality: quality,
      limit: limit ?? 20,
      page: page ?? 1,
      sortBy: 'date_added',
      orderBy: 'desc',
    );
  }
}

