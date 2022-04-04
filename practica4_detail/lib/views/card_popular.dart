import 'package:flutter/material.dart';
import 'package:practica4_detail/models/popular_movies_model.dart';

class CardPopularView extends StatelessWidget {
  CardPopularView({Key? key, required this.popular}) : super(key: key);

  PopularModel? popular;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 5.0),
                blurRadius: 2.5)
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Hero(
              tag: '${popular!.backdropPath}',
              child: Container(
                child: FadeInImage(
                  placeholder: AssetImage('assets/activity_indicator.gif'),
                  image: NetworkImage(
                      'https://image.tmdb.org/t/p/w500/${popular!.backdropPath}'),
                  fadeInDuration: Duration(milliseconds: 500),
                ),
              ),
            ),
            Opacity(
              opacity: .5,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                height: 60,
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      popular!.title!,
                      style: TextStyle(color: Colors.white),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/detail', arguments: {
                            'title': popular!.title,
                            'image': popular!.backdropPath,
                            'overview': popular!.overview,
                            'posterpath': popular!.posterPath,
                            'id': popular!.id
                          });
                        },
                        icon: Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
