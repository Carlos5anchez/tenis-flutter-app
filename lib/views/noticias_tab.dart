import 'package:flutter/material.dart';
import '../models/news_article.dart';
import 'news_carousel.dart';
import 'news_feed.dart';
import '../services/data_loader.dart';

class NoticiasTab extends StatelessWidget {
  const NoticiasTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadAllNewsArticles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final allArticles = snapshot.data!;
            return FutureBuilder<List<NewsArticle>>(
                future: loadAllNewsArticles(),
                builder: (context, carouselSnapshot) {
                  if (carouselSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (carouselSnapshot.hasError) {
                    return Center(
                        child: Text('Error: ${carouselSnapshot.error}'));
                  } else {
                    final carouselArticles = carouselSnapshot.data!;
                    return SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          NewsCarousel(articles: carouselArticles),
                          Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: NewsFeeds(articles: allArticles),
                          ),
                        ],
                      ),
                    );
                  }
                });
          }
        });
  }
}
