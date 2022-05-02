import 'package:equatable/equatable.dart';

//Simple class to represent NewsItems
class NewsItem extends Equatable{
  //key will be the link of the RSS
  int id = 0;
  final String link;
  final String title;
  final String body;
  final String author;
  final String articleDate;
  //image url
  final String image;


  //has the article been saved?
  bool savedOffline;
  //has the article been read?
  bool isRead;

  String localPath;


  ///construct a news item
  NewsItem(
      this.link,
      this.title,
      this.body,
      this.author,
      this.articleDate,
      this.image,
      {
        this.isRead = false,
        this.savedOffline = false,
        this.localPath = ""
      });



  //return a copy of the newsItem but with the read flag set to true


  //properties involved in the override for == and hashCode
  @override
  List<Object?> get props => [title, body, author, articleDate, isRead];

  //Equatable library convert this object to a string
  bool get stringify => true;

  Map<String, Object?> toMap() {
    if(id != 0) {
      return {
        'id': id,
        'link': link,
        'title': title,
        'body': body,
        'author': author,
        'article_date': articleDate,
        'image': image,
        'is_read': (isRead)?1:0,
        'saved_offline': (savedOffline)?1:0,
        'local_path': localPath
      };
    }
    else {
      return {
        'link': link,
        'title': title,
        'body': body,
        'author': author,
        'article_date': articleDate,
        'image': image,
        'is_read': (isRead)?1:0,
        'saved_offline': (savedOffline)?1:0,
        'local_path': localPath
      };
    }
  }
//Special constructor that creates the NewsItem object from the map retrieved from the database
  NewsItem.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        link = res["link"],
        title = res["title"],
        body = res["body"],
        author = res["author"],
        articleDate =   res["article_date"],
        image = res["image"],
        isRead = (res["is_read"]==1)? true:false ,
        savedOffline = (res["saved_offline"]==1)? true:false ,
        localPath = res["local_path"];

}

//Abstract class with the abstract method getNews, which returns a Future list of NewsItem objects
abstract class NewsSourcer {

  Future<List<NewsItem>> getNews();

}
