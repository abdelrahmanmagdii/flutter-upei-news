import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;


//fetching images from the upei website
class MyImageLoader
{
  //The method that takes html article link and fetches the image link
  static Future<String> getImageUrl(String link) async
  {
    final response = await http.get(Uri.parse(link));

    if(response.statusCode == 200) {
      var document = parse(response.body); //fetches actual html
      dom.Element? link = document.getElementsByClassName("medialandscape")[0] //search for image element
          .querySelector('img');
      String imageLink = link != null ? link.attributes['src']??"" : ""; //if image link != null
      imageLink = "https://upei.ca/"+imageLink; //return as image link
      return imageLink;
    }

    return ""; //else if response code != 200 (error), return empty string
  }
}