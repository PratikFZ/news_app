import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/article_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DetailsView extends StatelessWidget {
  final Article article = Get.arguments;

  DetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.all(20),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (DateTime.now().difference(article.publishedAt).inHours <= 42)? 
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    )
                    : const SizedBox(height: 20),
                  const SizedBox(height: 8),
                  Text(
                    article.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // const SizedBox(height: 8),
                  Row(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        // reverse: true,
                        child: Text(
                          article.author ?? "Pratik",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '•',
                        style: TextStyle(color: Colors.white70, fontSize: 8),
                      ),
                      const SizedBox(width: 8),
                      Text( (DateTime.now().difference(article.publishedAt).inHours <= 42)?
                            "${DateTime.now().difference(article.publishedAt).inHours} hours ago"
                            :DateFormat('dd/MM/yyyy').format(article.publishedAt),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              background: Hero(
                tag: article.url,
                child: article.urlToImage != null
                    ? Stack(
                        children: [
                          Image.network(
                            article.urlToImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  const Color.fromARGB(57, 2, 2, 2),
                                  const Color.fromARGB(186, 0, 0, 0),
                                  const Color.fromARGB(255, 0, 0, 0),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.error),
                      ),
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 0, 0)
                ),
                // padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      topLeft: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 8,),
                              CircleAvatar(
                                backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                                radius: 20,
                                backgroundImage: NetworkImage(
                                  'https://www.google.com/s2/favicons?sz=64&domain_url=${article.url}',
                                ),
                              ),
                              SizedBox(width: 8,),
                              SizedBox(
                                child: Text(
                                  article.source,
                                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          ValueListenableBuilder(
                            valueListenable: Hive.box<Article>('favorites').listenable(),
                            builder: (context, box, _) {
                              final isFavorite = box.values.any((a) => a.url == article.url);
                              return IconButton(
                                onPressed: () {
                                  final box = Hive.box<Article>('favorites');
                                  if (isFavorite) {
                                    box.values.firstWhere((a) => a.url == article.url).delete();
                                  } else {
                                    box.add(article);
                                  }
                                },
                                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.grey[600]),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (article.description != null)
                        Text(
                          article.description!,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal
                          )
                        ),
                      const SizedBox(height: 16),
                      Text(
                        article.content,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal
                        )
                      ),
                    ],
                  ),
                )
              ),
            ),
        ],
      ),
    );
  }
}
