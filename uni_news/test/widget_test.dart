import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:uni_news/model/news_item.dart';
import 'package:uni_news/upei_news.dart';

@GenerateMocks([http.Client])
void main() {
  group('fetchAlbum', () {
    test('returns an single item if the http call completes successfully', () async {
      final client = MockClient((request) async {
        final xml = '<?xml version="1.0" encoding="utf-8"?><rss xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:content="http://purl.org/rss/1.0/modules/content/" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:og="http://ogp.me/ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:schema="http://schema.org/" xmlns:sioc="http://rdfs.org/sioc/ns#" xmlns:sioct="http://rdfs.org/sioc/types#" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" version="2.0" xml:base="https://www.upei.ca/"><channel><title>Media Releases</title><link>https://www.upei.ca/</link><description/><language>en</language><item><title>Dr. Jeff Collins gives keynote address at annual Naval Warfare Officers Symposium</title><link>https://www.upei.ca/communications/news/2022/03/dr-jeff-collins-gives-keynote-address-annual-naval-warfare-officers</link><description>Dr. Jeff Collins, adjunct professor at UPEI, gave the keynote address at the Royal Canadian Navy</description><pubDate>Fri, 11 Mar 2022 16:20:37 -0400</pubDate><dc:creator>Anna MacDonald</dc:creator><guid isPermaLink="true">https://www.upei.ca/communications/news/2022/03/dr-jeff-collins-gives-keynote-address-annual-naval-warfare-officers</guid>   </item> </channel></rss>'
        ;
        return Response(xml, 200);
      });

      UPEINewsSource source = UPEINewsSource(client: client);




      expect((await source.getNews()).length, 1);
    });

    test('In case od exception, throws an Exception', () async {
      final client = MockClient((request) async {
        return http.Response('Not Found', 404);
      });
      UPEINewsSource source = UPEINewsSource(client: client);

      // expect(await source.getNews(), throwsException);
      expect(await source.getNews(), <NewsItem> []);
    });
  });
}
