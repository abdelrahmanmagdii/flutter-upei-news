import 'routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'helpers/db_helper.dart';
import 'main.dart';
import 'model/news_item.dart';
import 'news_details.dart';


class NewsListItem extends StatefulWidget {
  NewsItem newsItem;
  int index;
  NewsCache newsCache;
  NewsListItem(this.newsItem, this.index, this.newsCache);

  @override
  State<StatefulWidget> createState() {
    return _NewsListItemState(this.newsItem, this.index, this.newsCache);
  }
}

class _NewsListItemState extends State<NewsListItem> {
  NewsItem newsItem;
  int index;
  NewsCache newsCache;
  late Color backgooundColor;

  _NewsListItemState(this.newsItem, this.index, this.newsCache)
  {
    if(newsItem.isRead)
    {
      backgooundColor = Colors.grey;
    }
    else{
      backgooundColor =(index%2 == 0)?Colors.orange:Colors.yellow;
    }
  }

  void openStoryDetails(BuildContext ctx){
    newsCache.currentIndex = index;
    newsItem.isRead = true;
    DBHelper.setRead(newsItem.link);
    setState(() { backgooundColor =  Colors.grey;});
    Navigator.of(ctx).pushNamed(  RouteGenerator.newsDetails  );

  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return DecoratedBox(decoration: BoxDecoration(color: (index%2 == 0)?Colors.orange:Colors.yellow),
        child:
        Row(children: [
          Padding( padding: const EdgeInsets.all(8.0),
            child:
            ElevatedButton.icon(
              onPressed: () => openStoryDetails(context),
              style: ElevatedButton.styleFrom(
                  primary: backgooundColor, // background (button) color
                  onPrimary: backgooundColor,
                  maximumSize: Size(width*0.7, 80)// foreground (text) color
              ),
              icon: //Image.asset('images/trump.png', width: 200, height: 50,)
              Image.network(newsItem.image, width: width*0.3, height: 50, )
              ,
              label: Text(newsItem.title,
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        fontSize: 12,
                        color: Colors.green
                    )
                    ,)),



            ),
          )
          ,


          IconButton(onPressed: () => _save( newsItem, context),
              icon: const Icon(Icons.add_box_outlined,)
          )

        ],)

    );
  }

  _save(NewsItem newsItem,BuildContext context) {
    if(!newsItem.savedOffline)
    {
      DBHelper.saveNews(newsItem);
    }
    _showDialog(context);
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Saved"),
          content: new Text("Saved to DB"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}