import 'main.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'model/news_item.dart';

//Class responsible for displaying news details when an article is opened
class NewsDetails extends StatelessWidget
{
//Build the interface using Consumer to pass the NewsCache to the newsDetailBody
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('UPEI News Details')),
        body: Consumer<NewsCache>
          (
            builder: (context, cache, _) {
              return NewsDetailsBody(cache.myTitleList[cache.currentIndex].newsItem);
            }

        )



    );
  }

}
//NewsDetailsBody contains the article details
class NewsDetailsBody  extends StatelessWidget
{
  NewsItem newsItem;
  NewsDetailsBody(this.newsItem);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView
      (
      child: Table(
          border: TableBorder.all(color: Colors.white),
          children:[

            TableRow(children:[Container(
              padding: const EdgeInsets.all(8),
              child: (newsItem.savedOffline)?
              Image.file(File(newsItem.localPath))
                  :Image.network(newsItem.image, width: 400, height: 150, ),
              color: Colors.white,
            ),]),
            TableRow(children:[Container(
              padding: const EdgeInsets.all(8),
              child: Text(newsItem.title,
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        fontSize: 24,
                        color: Colors.black
                    )
                    ,)),
              color: Colors.white,
            ),]),
            TableRow(children:[Container(
              padding: const EdgeInsets.all(8),
              child: Text(newsItem.author,
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54
                    )
                    ,)),
              color: Colors.white,
            ),]),
            TableRow(children:[Container(
              padding: const EdgeInsets.all(8),
              child: Text(newsItem.articleDate.toString(),
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        fontSize: 12,
                        color: Colors.black45
                    )
                    ,)),
              color: Colors.white,
            ),]),
            TableRow(children:[Container(
              padding: const EdgeInsets.all(8),
              child: Text(newsItem.body,
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        fontSize: 10,
                        color: Colors.black45
                    )
                    ,)),
              color: Colors.white,
            ),]),

          ]),
    )
    ;
  }
}