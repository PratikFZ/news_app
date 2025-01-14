
class Article {
  final String title;
  final String? description;
  final String? urlToImage;
  final String source;
  final DateTime publishedAt;

  Article({
    required this.title,
    this.description,
    this.urlToImage,
    required this.source,
    required this.publishedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      description: json['description'],
      urlToImage: json['urlToImage'],
      source: json['source']['name'] ?? 'Unknown',
      publishedAt: DateTime.parse(json['publishedAt']),
    );
  }
}