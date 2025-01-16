import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../data/models/article_model.dart';

class HomeController extends GetxController {
  final articles = <Article>[].obs;
  final isLoading = true.obs;
  final selectedCategory = 'general'.obs;
  
  final categories = [
    'general',
    'business',
    'technology',
    'sports',
    'entertainment',
    'health',
    'science'
  ];

  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }

  Future<void> fetchNews() async {
    isLoading.value = true;
    const apiKey = '6fc5e32fab30444392f12ce281eb98b4';
    final url = 'https://newsapi.org/v2/top-headlines?country=us&category=${selectedCategory.value}&apiKey=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        articles.value = (jsonData['articles'] as List)
            .map((article) => Article.fromJson(article))
            .where((article) => 
                article.title != '[Removed]' && 
                (article.content != '[Removed]' || article.content != '') &&
                article.description != '[Removed]')
            .toList();
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch news: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
    fetchNews();
  }
}
