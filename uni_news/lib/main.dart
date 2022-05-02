import 'routes.dart';
import 'upei_news.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'helpers/db_helper.dart';
import 'news_list_item.dart';
import 'model/news_item.dart';


void main() {
  runApp( MyAppRoutes());
}
//MyAppRoutes is the default page run at start up, it handles navigation to the homepage and calls the class generateRoute when navigating

class MyAppRoutes extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {

    return Provider<NewsCache>(
      create: (context) => NewsCache(),
      child: MaterialApp(
        onGenerateTitle: (context) => "Random App",
        initialRoute: RouteGenerator.homePage,
        onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );

  }

}

//NewsCache is where we stash all the news items we fetch

class NewsCache
{
  List<NewsListItem> myTitleList = [];
  List<NewsItem>? myOnlineNewsList;
  var currentIndex = 0;

  //reloadOnline is where we get the news from the upei website
  Future<List<NewsListItem>> reloadOnline() async
  {
    if(myOnlineNewsList == null) {
      var myFutureList = await UPEINewsSource().getNews();
      myOnlineNewsList = myFutureList;
    }
    return _process(myOnlineNewsList??<NewsItem>[]);
  }

//reloadOffline to get news from site and from db
  Future<List<NewsListItem>> reloadOffline() async
  {
    var myFutureList = await DBHelper.getNews();
    return _process(myFutureList);
  }


//process is a method called by both reloadOnline & reloadOffline that creates the list of widgets after fetching the news

  Future<List<NewsListItem>> _process(List<NewsItem> myFutureList) async
  {
    myTitleList.clear();
    int i =0;
    for(NewsItem  news in myFutureList)
    {
      myTitleList.add(NewsListItem(news, i, this));
      i++;
    }
    List<String> readList= await DBHelper.getNewsReadItems();

    for (NewsListItem item in myTitleList)
    {
      if(readList.contains(item.newsItem.link)) {
        item.newsItem.isRead = true;
      }
    }
    return myTitleList;
  }
}



