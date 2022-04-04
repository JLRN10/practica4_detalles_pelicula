import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:practica4_detail/models/actors_movies_model.dart';
import 'package:practica4_detail/models/popular_movies_model.dart';
import 'package:practica4_detail/models/trailer_movie_model.dart';

class ApiPopular {
  var URL = Uri.parse(
      "https://api.themoviedb.org/3/movie/popular?api_key=91a52cf1dd78065ff1fdf9c6c0d9194c&language=es-MX&page=1");

  Future<List<PopularModel>?> getAllPopular() async {
    final response = await http.get(URL);
    if (response.statusCode == 200) {
      var popular = jsonDecode(response.body)['results'] as List;
      List<PopularModel> listaPopular =
          popular.map((movie) => PopularModel.fromMap(movie)).toList();
      return listaPopular;
    } else {
      return null;
    }
  }

  Future<List<ActorsMoviesModel>?> getActors(int id) async {
    var urlActors = Uri.parse(
        'https://api.themoviedb.org/3/movie/$id/credits?api_key=1d8d186bb102fcd996e5506e5ec4e30f&language=es-ES');
    final response = await http.get(urlActors);
    if (response.statusCode == 200) {
      var actors = jsonDecode(response.body)['cast'] as List;
      List<ActorsMoviesModel> listActors =
          actors.map((actor) => ActorsMoviesModel.fromMap(actor)).toList();
      return listActors;
    } else {
      return null;
    }
  }

  Future<List<TrailerMovieModel>?> getTrailer(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var trailers = jsonDecode(response.body)['results'] as List;
      List<TrailerMovieModel> listaTrailers =
          trailers.map((movie) => TrailerMovieModel.fromMap(movie)).toList();
      //TrailerMovieModel? trailer = listaTrailers.first;
      return listaTrailers;
    } else {
      return null;
    }
  }
}
