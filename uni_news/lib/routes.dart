import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'my_app_online.dart';
import 'news_details.dart';


//The route generator that handles navigation throughout the app

class RouteGenerator
{
  static const String homePage ='/'; //the default home page
  static const String newsDetails = '/newsDetails'; //News details route

  RouteGenerator._() {}

  //generateRoute method decides which page to open depending on the path provided to the navigator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePage:
        return MaterialPageRoute(builder: (_) =>  MyAppOnline(),);
      case newsDetails:
        return MaterialPageRoute(builder: (_) =>  NewsDetails(),);
      default:
        throw FormatException("Route not found");
    }
  }

}