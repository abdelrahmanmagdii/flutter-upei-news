
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'news_list_item.dart';


// Default class that is displayed upon running the app,  implemented as a Statefulwidget
//The createState returns the class that contains the widget list of NewsItems fetched from the upei website

class MyAppOnline extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppOnlineState();
  }

}

//Private class that creates the home page, takes cache as parameter
class _MyAppOnlineState extends State<MyAppOnline> {

  @override
  Widget build(BuildContext context) {


    return Consumer<NewsCache>
      (
        builder: (context, cache, _) {
          return HomePage(cache);
        }

    );
  }
}

//Private class that creates the home page, takes cache as parameter
class HomePage extends StatefulWidget {
  NewsCache newsCache;

//Constructor that has newsCache passed to it as a parameter
  HomePage(this.newsCache);
//returns instance of private class _HomePageState that contains list of widgets (UI)
  @override
  State<StatefulWidget> createState() {
    return _HomePageState(newsCache);
  }
}
//Private stateful widget, NewsListItem is changed depending whether the news was fetched from the upei website or the database
class _HomePageState extends State<HomePage>
{
  NewsCache newsCache;
  late Future<List<NewsListItem>> myTitleList ;
  bool offline = false;
  _HomePageState(this.newsCache);
//reload application if changes occur
  @override
  void initState() {
    super.initState();
    myTitleList = newsCache.reloadOnline();
  }
//place upei logo into appbar, use FutureBuilder (awaits for asynchronous method to be read, reload interface when done)
  @override
  Widget build(BuildContext context) {

    final Image titleImage = Image.asset("images/upei.png",fit: BoxFit.scaleDown, height: 75, width: MediaQuery.of(context).size.width);
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("                          UPEI News"),
      ),
      body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<List<NewsListItem>>(
              future: myTitleList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return  ListView(
                      children: snapshot.data!.toList(),
                    );

                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                }
                return const CircularProgressIndicator();
              } )

      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState((){
            offline = !offline;
            if(offline){
              myTitleList = newsCache.reloadOffline();
            } else {
              myTitleList = newsCache.reloadOnline();
            }
          });

        },
        label: const Text(''),
        icon: offline?new Icon(Icons.airplanemode_active):new Icon(Icons.airplanemode_inactive),
        backgroundColor: Colors.pink,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );


  }
}