import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:practica4_detail/database/database_movie.dart';
import 'package:practica4_detail/models/actors_movies_model.dart';
import 'package:practica4_detail/models/favorite_movies_model.dart';
import 'package:practica4_detail/models/trailer_movie_model.dart';
import 'package:practica4_detail/network/api_popular.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({Key? key}) : super(key: key);
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late DatabaseMovies _databaseMovies;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _databaseMovies = DatabaseMovies();
  }

  @override
  Widget build(BuildContext context) {
    final apiPopular = ApiPopular();
    final movie =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    var title = movie['title'];
    var id = movie['id'];
    var overview = movie['overview'];
    var posterpath = movie['posterpath'];

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(movie['title']),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
          actions: [Favorite(id, title, posterpath, _databaseMovies)]),
      body: Container(
        color: Colors.black,
        child: ListView(
          children: [
            Hero(
              tag: '${movie['image']}',
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500/${movie['image']}',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(child: DescriptionMovie(id, overview)),
              ],
            ),
            SizedBox(height: 10.0),
            SizedBox(
              height: 200.0,
              child: getActors(id, apiPopular),
            ),
            SizedBox(height: 10.0),
            SizedBox(child: getTrailer(id, apiPopular))
          ],
        ),
      ),
    );

    /*CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 160.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(movie['title']),
              background: Hero(
                tag: '${movie['image']}',
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500/${movie['image']}',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            actions: [buttonFavorite(id, title, posterpath, _databaseMovies)]),
        SliverFillRemaining(
          child: ListView(
            padding: EdgeInsets.all(8.0),
            children: [
              Row(),
              SizedBox(height: 5),
              Row(
                children: [
                  Expanded(child: DescriptionMovie(id, overview)),
                ],
              ),
              SizedBox(height: 5),
              Row(),
              SizedBox(height: 5),
              Row(),
              SizedBox(
                height: 200.0,
                child: getActors(id, apiPopular),
              ),
              SizedBox(height: 8),
              SizedBox(height: 10),
              SizedBox(child: getTrailer(id, apiPopular))
            ],
          ),
        ),
      ],
    );*/
  }

  Widget Favorite(int id, String title, String posterpath, DatabaseMovies db) {
    return FutureBuilder(
        future: db.checkFavorite(id),
        builder: (BuildContext contex, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Fatal Error'),
            );
          } else {
            if (snapshot.connectionState == ConnectionState.done) {
              return IconButton(
                icon: snapshot.data!
                    ? Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                      ),
                onPressed: () {
                  setState(() {
                    if (snapshot.data!) {
                      db.delete(id);
                    } else {
                      FavoriteModel favoriteElement = FavoriteModel(
                        id: id,
                        title: title,
                        posterpath: posterpath,
                      );
                      db.insert(favoriteElement.toMap());
                    }
                  });
                },
              );
            } else {
              return CircularProgressIndicator();
            }
          }
        });
  }

  Widget DescriptionMovie(int id, String overview) {
    return Center(
      child: Card(
        color: Colors.black,
        child: Column(
          children: [
            Text('Description',
                style: TextStyle(color: Colors.white, fontSize: 20)),
            Divider(
              color: Colors.white,
            ),
            Text(
              overview,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.justify,
            )
          ],
        ),
      ),
    );
  }

  Widget getActors(int id, ApiPopular API) {
    return FutureBuilder(
        future: API.getActors(id),
        builder: (BuildContext contex, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Fatal Error'),
            );
          } else {
            if (snapshot.connectionState == ConnectionState.done) {
              return listActors(snapshot.data);
            } else {
              return CircularProgressIndicator();
            }
          }
        });
  }

  Widget listActors(List<ActorsMoviesModel> listActors) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: listActors.length,
        itemBuilder: (
          context,
          index,
        ) {
          ActorsMoviesModel actors = listActors[index];
          return Center(
            child: Card(
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: actors.photo == ''
                        ? NetworkImage(
                            'https://cdn-icons-png.flaticon.com/512/3409/3409455.png')
                        : NetworkImage(
                            'https://image.tmdb.org/t/p/w300/${actors.photo}'),
                  ),
                  Text(
                    actors.name!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget getTrailer(int id, ApiPopular API) {
    // Variable para el video del trailer, filtrado por type = "Trailer"
    var ListTrailers = TrailerMovieModel();

    return FutureBuilder(
        future: API.getTrailer(
            "https://api.themoviedb.org/3/movie/$id/videos?api_key=91a52cf1dd78065ff1fdf9c6c0d9194c&language=en-US"),
        builder: (BuildContext context,
            AsyncSnapshot<List<TrailerMovieModel>?> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Hay un error en la petición"));
          } else {
            if (snapshot.connectionState == ConnectionState.done) {
              snapshot.data!.forEach((trailer) {
                ListTrailers = trailer;
              });
              return WidgetTrailerMovie(context, ListTrailers);
            } else {
              return CircularProgressIndicator();
            }
          }
        });
  }

  Widget WidgetTrailerMovie(BuildContext context, TrailerMovieModel trailer) {
    return YoutubePlayer(
      aspectRatio: 16 / 9,
      controller: YoutubePlayerController(
          initialVideoId: trailer.key.toString(),
          flags:
              YoutubePlayerFlags(autoPlay: false, mute: false, forceHD: true)),
      showVideoProgressIndicator: true,
      progressColors: ProgressBarColors(
          playedColor: Colors.lightBlue, handleColor: Colors.blueAccent),
      onReady: () {
        print('Player is Ready');
      },
    );
  }
}
