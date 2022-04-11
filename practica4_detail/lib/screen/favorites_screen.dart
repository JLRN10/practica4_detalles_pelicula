import 'package:flutter/material.dart';
import 'package:practica4_detail/database/database_movie.dart';
import 'package:practica4_detail/models/favorite_movies_model.dart';

class FavoriteScreen extends StatefulWidget {
  FavoriteScreen({Key? key}) : super(key: key);
  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late DatabaseMovies _databaseMovies;
  @override
  void initState() {
    super.initState();
    _databaseMovies = DatabaseMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Text("Favorite movies "),
      ),
      body: Container(
        color: Colors.black,
        child: FutureBuilder(
          future: _databaseMovies.getAllFavititesMovies(),
          builder: (BuildContext context,
              AsyncSnapshot<List<FavoriteModel>> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error"),
              );
            } else {
              if (snapshot.connectionState == ConnectionState.done) {
                return _listFavoritesMovies(snapshot.data!);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          },
        ),
      ),
    );
  }

  Widget _listFavoritesMovies(List<FavoriteModel> favoritesMovies) {
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(Duration(seconds: 1), () {
          //Refresh with setState
          setState(() {});
        });
      },
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          FavoriteModel movie = favoritesMovies[index];
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black87,
                          offset: Offset(0.0, 5.0),
                          blurRadius: 2.5)
                    ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Stack(alignment: Alignment.bottomCenter, children: [
                    Container(
                        child: FadeInImage(
                      placeholder: AssetImage('assets/loading.gif'),
                      image: NetworkImage(
                          "https://image.tmdb.org/t/p/w500/${movie.posterpath}"),
                      fadeInDuration: Duration(milliseconds: 200),
                    )),
                    Opacity(
                      opacity: 0.9,
                      child: Container(
                        padding: EdgeInsets.only(left: 15.0),
                        height: 60.0,
                        color: Colors.black,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                setState(() {
                                  _databaseMovies.delete(movie.id);
                                });
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ]),
                )),
          );
        },
        itemCount: favoritesMovies.length,
      ),
    );
  }
}
