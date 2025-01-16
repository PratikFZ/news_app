import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../data/models/article_model.dart';

class NewsSearchController extends GetxController {
  final articles = <Article>[].obs;
  final isLoading = true.obs;
  final selectedCategory = 'All'.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }

  Future<void> fetchNews() async {
    isLoading.value = true;
    const apiKey = '6fc5e32fab30444392f12ce281eb98b4';
    String url;
    
    if (searchQuery.value.isEmpty) {
      url = 'https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey';
      if (selectedCategory.value.toLowerCase() != 'all') {
        url += '&category=${selectedCategory.value.toLowerCase()}';
      }
    } else {
      url = 'https://newsapi.org/v2/everything?q=${searchQuery.value}&apiKey=$apiKey';
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        articles.value = (jsonData['articles'] as List)
            .map((article) => Article.fromJson(article))
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

  void search(String query) {
    searchQuery.value = query;
    fetchNews();
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
    searchQuery.value = '';
    fetchNews();
  }
}
