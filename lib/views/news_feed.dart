import 'package:flutter/material.dart';
import '../models/news_article.dart';

class NewsFeeds extends StatelessWidget {
  final List<NewsArticle> articles;
  const NewsFeeds({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: articles.map((article) => NewsCard(article: article)).toList(),
    );
  }
}

class NewsCard extends StatelessWidget {
  final NewsArticle article;
  const NewsCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 50,
        height: 400,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  side: BorderSide(
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                    width: 0.9,
                  ),
                ),
                child: SampleCard(article: article),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SampleCard extends StatelessWidget {
  final NewsArticle article;
  const SampleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: <Widget>[
          Flexible(
            flex: 7, // 70% del espacio
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(article.urlToImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 3, // 30% del espacio
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    flex: 8, // 80% del espacio restante
                    child: Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Flexible(
                    flex: 2, // 20% del espacio restante
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Text(article.source),
                        ),
                        Expanded(
                          child: Text(article.publishedAt),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
