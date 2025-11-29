class ApiEndPoints {
  static final String login = 'auth/signin';

  static final String register = 'auth/signup';

  static final String forgetPassword = 'auth/forget-password';

  static final String reset_password =
      'auth/reset-password';

  static final String addFavourite = 'favorites/add';

  static final String getAllFavourites = 'favorites/all';

  static final String deleteMovie =
      'favorites/remove';
  static final String movieIsFavourite = 'favorites/is-favorite';

  static final String profile = 'profile';

  static final String listMovies = 'list_movies.json';
  static final String movieDetails = 'movie_details.json';
  static final String movieSuggestions = 'movie_suggestions.json';
  static final String movieParentalGuides = 'movie_parental_guides.json';
}
