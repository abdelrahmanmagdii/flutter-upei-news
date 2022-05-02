import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';
import '/model/news_item.dart';
//responsible for the handling, saving and fetching of read news items AND items that get saved to the offline screen
class DBHelper {

  static const _newsTable = "news_item";
  static const _readTable = "news_read";
  //Attempts to establish connection with the database to fetch articles that have been read
  // If no database exists, onCreate is executed and a database is created
  static Future<Database> databaseRead() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, '$_readTable.db'),
        onCreate: (db, version)  {
          db.execute(
              'CREATE TABLE $_readTable( '
                  'link PRIMARY KEY, '
                  'is_read INTEGER) ');
        }, version: 1);
  }

  //Attemps to establish connection when saving an
  static Future<Database> databaseSave() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, '$_newsTable.db'),
        onCreate: (db, version)  {
          db.execute(
              'CREATE TABLE $_newsTable( '
                  'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
                  'link TEXT NOT NULL,'
                  'is_read INTEGER,'
                  'title TEXT,body TEXT, '
                  'author TEXT, '
                  'article_date TEXT, '
                  'image TEXT, '
                  'saved_offline TEXT,  '
                  'local_path TEXT)');
        }, version: 1);
  }
//insert a new column into database (using the link as a key) and adds is_read = 1 by default
  static Future<int> insertNewsRead(String key) async {
    final db = await DBHelper.databaseRead();
    var data = {"link": key, "is_read": 1};
    return db.insert(_readTable, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

  }
//checks if the article has a "is_read" column, if not it calls the previous method insertNewsRead
  static void setRead(String key) async {
    var isArticleRead = await isRead( key);
    if(isArticleRead == true) {
      return;
    }
    else
    {
      insertNewsRead( key);
    }
  }
//Checks to see if an article has been opened and returns true if it has been opened
  static Future<bool> isRead(String key) async {
    final db = await DBHelper.databaseRead();
    List<Map<String, Object?>> queryResult =
    await db.query(_readTable, where: "link = ?", whereArgs: [key], limit: 1);
    if(queryResult.isEmpty)//the article was not read
        {
      return false;
    }
    return true;
  }

  // Read all read items
  static Future<List<String>> getNewsReadItems() async {
    final db = await DBHelper.databaseRead();
    List<Map<String, Object?>> queryResult = await db.query(_readTable);
    List<String> links = [];
    for(Map<String, Object?> news in  queryResult)
    {
      links.add((news["link"] ??"")as String);
    }
    return links;
  }


//checks if the newsitem has been saved, if so nothing happens
  //else, the method converts the NewsItem object to a map, and the map is saved into the database using conflictAlgorithim if exists, replace.
  //finally, the id that is generated is read, auto incremented and set into newsItem
  static Future<void> saveNews(NewsItem news)  async {
    final db = await DBHelper.databaseSave();

    List<Map<String, Object?>> queryResult =
    await db.query(_newsTable, where: "link = ?", whereArgs: [news.link], limit: 1);
    if(queryResult.isNotEmpty)//the article was not read
        {
    }
    else{
      var data = news.toMap();
      int id = await db.insert(_newsTable, data,
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
      news.id = id;
    }
  }

  //if NewsItem doesnt exist returns null, otherwise transfers the map returned by the database into a newsitem object
  static Future<NewsItem?> getNewsItem(String key) async {
    final db = await DBHelper.databaseSave();
    List<Map<String, Object?>> queryResult =
    await db.query(_newsTable, where: "link = ?", whereArgs: [key], limit: 1);
    if(queryResult.isEmpty)//the article was not read
        {
      return null;
    }
    //only return the first because the link is a unique key, so only 1 item may be returned
    return NewsItem.fromMap(queryResult.first);
  }

  // Read all news items
  static Future<List<NewsItem>> getNews() async {
    final db = await DBHelper.databaseSave();
    List<NewsItem> result = [];
    List<Map<String, Object?>> queryResult =
    await db.query(_newsTable);
    for(Map<String, Object?> news in  queryResult)
    {
      result.add(NewsItem.fromMap(news));
    }
    return result;
  }


}
