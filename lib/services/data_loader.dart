import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/news_article.dart';

Future<List<NewsArticle>> loadAllNewsArticles() async {
  final String response = await rootBundle.loadString('assets/news_data.json');
  final data = await json.decode(response);
  List<NewsArticle> articles = (data['arrticles'] as List)
      .map((articleJson) => NewsArticle.fromJson(articleJson))
      .toList();

  // Ordenar los artículos por fecha de publicación (del más reciente al más antiguo)
  articles.sort((a, b) =>
      DateTime.parse(b.publishedAt).compareTo(DateTime.parse(a.publishedAt)));

  return articles;
}

Future<List<NewsArticle>> loadCarouselNewsArticles() async {
  final String response = await rootBundle.loadString('assets/news_data.json');
  final data = await json.decode(response);
  return (data['arrticles'] as List)
      .map((articleJson) => NewsArticle.fromJson(articleJson))
      .where((article) => article.oncarrusel)
      .toList();
}
