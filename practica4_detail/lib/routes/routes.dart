import 'package:flutter/material.dart';
import 'package:practica4_detail/screen/detail_screen.dart';
import 'package:practica4_detail/screen/favorites_screen.dart';
import 'package:practica4_detail/screen/popular_screen.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/movies': (BuildContext context) => PopularScreen(),
    '/detail': (BuildContext context) => DetailScreen(),
    '/favorites': (BuildContext context) => FavoriteScreen(),
  };
}
