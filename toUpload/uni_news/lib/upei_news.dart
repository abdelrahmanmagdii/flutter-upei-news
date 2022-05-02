import 'image_loader.dart';
import 'package:webfeed/webfeed.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'model/news_item.dart';


//main class that reads from the upei website and converts it into a NewsItem
class UPEINewsSource extends NewsSourcer
{
  static const  String siteUrl = 'https://www.upei.ca/feeds/news.rss';
  http.Client client;
  UPEINewsSource({client}): this.client = client??http.Client();

  //establishes connection with RssFeed, loops over last 20 news articles and creates newsItem object for each
  @override
  Future<List<NewsItem>> getNews() async{
    var news = <NewsItem> [];
    final url = Uri.parse(siteUrl);
    //http.get(url).then((response) => _handleResponse(response, news));
    var response = await client.get(url);
    if(response.statusCode == 200) {
      RssFeed feed = RssFeed.parse(response.body);

      var count = 0;
      for (RssItem rssItem in feed.items ?? <RssItem>[]) {
        count ++;
        if (count >= 20)
          break;
        //news article title
        try {
          var imageUrl = await MyImageLoader.getImageUrl(
              rssItem.link.toString());
          var desc = rssItem.description ?? "";
          RegExp exp = RegExp("<[^>]*>"); //reg expression to remove html tags
          desc = desc.replaceAll(exp, "");
          NewsItem item = NewsItem(rssItem.link ?? "",
            rssItem.title ?? "",
            desc,
            rssItem.dc?.creator ?? "",
            (rssItem.pubDate ?? DateTime.now()).toString(),
            imageUrl,
          );
          news.add(item);
        }
        catch (e) {
          print(e);
        }
      }
    }
    return news;
  }
}
