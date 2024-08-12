class NewsArticle {
  final String title;
  final String url;
  final String urlToImage;
  final String overview;
  final String author;
  final String publishedAt;
  final String source;
  final bool oncarrusel;

  NewsArticle(
      {required this.title,
      required this.url,
      required this.urlToImage,
      required this.overview,
      required this.author,
      required this.publishedAt,
      required this.source,
      required this.oncarrusel});

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      overview: json['overview'],
      author: json['author'],
      publishedAt: json['publishedAt'],
      source: json['source']['name'],
      oncarrusel: json['oncarrusel'],
    );
  }
}
