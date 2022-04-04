import 'package:flutter/material.dart';
import 'package:practica4_detail/models/popular_movies_model.dart';
import 'package:practica4_detail/network/api_popular.dart';
import 'package:practica4_detail/views/card_popular.dart';

class PopularScreen extends StatefulWidget {
  PopularScreen({Key? key}) : super(key: key);

  @override
  _PopularScreenState createState() => _PopularScreenState();
}

class _PopularScreenState extends State<PopularScreen> {
  ApiPopular? apiPopular;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiPopular = ApiPopular();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Popular Movies"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/favorites').whenComplete(() {
                setState(() {});
              });
            },
            icon: Icon(
              Icons.favorite,
              textDirection: TextDirection.ltr,
            ),
          )
        ],
      ),
      body: FutureBuilder(
          future: apiPopular!.getAllPopular(),
          builder: (BuildContext context,
              AsyncSnapshot<List<PopularModel>?> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Faild Conection'),
              );
            } else {
              if (snapshot.connectionState == ConnectionState.done) {
                return _listPopularMovies(snapshot.data);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          }),
    );
  }

  Widget _listPopularMovies(List<PopularModel>? movies) {
    return Container(
      color: Colors.black,
      child: ListView.separated(
        itemBuilder: (context, index) {
          PopularModel popular = movies![index];
          return CardPopularView(popular: popular);
        },
        separatorBuilder: (_, __) => Divider(height: 10),
        itemCount: movies!.length,
      ),
    );
  }
}
