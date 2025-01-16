import 'package:hive/hive.dart';

part 'article_model.g.dart';

@HiveType(typeId: 0)
class Article extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String? description;

  @HiveField(2)
  final String? urlToImage;

  @HiveField(3)
  final String source;

  @HiveField(4)
  final DateTime publishedAt;

  @HiveField(5)
  final String content;

  @HiveField(6)
  final String url;

  @HiveField(7)
  final String? author;

  Article({
    required this.title,
    this.description,
    this.urlToImage,
    required this.source,
    required this.publishedAt,
    required this.content,
    required this.url,
    this.author,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      description: json['description'],
      urlToImage: json['urlToImage'],
      source: json['source']['name'] ?? 'Unknown',
      publishedAt: DateTime.parse(json['publishedAt']),
      content: json['content'] ?? '',
      url: json['url'] ?? '',
      author: json['author'],
    );
  }
}
