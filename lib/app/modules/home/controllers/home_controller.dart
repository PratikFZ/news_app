import 'dart:async';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../data/models/article_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomeController extends GetxController {
  final articles = <Article>[].obs;
  final isLoading = true.obs;
  final selectedCategory = 'general'.obs;
  var isInternetConnected = false.obs;
  List<ConnectivityResult> connectionStatus = [ConnectivityResult.none].obs;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

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
    initConnetivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectivity);
  }

  Future<void> initConnetivity() async {
    late List<ConnectivityResult> result;

    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      // ignore: avoid_print
      print("Error : $e");
    }

    if (isClosed) {
      // ignore: null_argument_to_non_null_type
      return Future.value(null);
    }
    return _updateConnectivity(result);
  }

  Future<void> _updateConnectivity(List<ConnectivityResult> result) async {
    connectionStatus = result;
    isInternetConnected.value = result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.mobile);
    fetchNews();
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }

  Future<void> fetchNews() async {
    isLoading.value = true;

    // Fixed URL with protocol
    final url = 'https://miki696969.pythonanywhere.com/api/top-headlines';

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
        throw Exception('Failed to load news: ${response.statusCode}');
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
