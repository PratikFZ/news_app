import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../data/models/article_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart' show rootBundle;
// import 'package:shared_preferences/shared_preferences.dart';

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
    loadSavedNews();
    fetchNews();
    initConnetivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectivity);
  }

  Future<void> loadSavedNews() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/fallback_news.json';
      final file = File(filePath);

      if (await file.exists()) {
        // Load news from the updated JSON file
        final savedNews = await file.readAsString();
        final jsonData = json.decode(savedNews);
        articles.value = (jsonData['articles'] as List)
            .map((article) => Article.fromJson(article))
            .toList();
      } else {
        // Fallback to the original JSON file in assets
        final fallbackData =
            await rootBundle.loadString('assets/fallback_news.json');
        final jsonData = json.decode(fallbackData);
        articles.value = (jsonData['articles'] as List)
            .map((article) => Article.fromJson(article))
            .toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load saved news: $e');
    }
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

    try {
      // Load news from the fallback JSON file
      final fallbackData =
          await rootBundle.loadString('assets/fallback_news.json');
      final jsonData = json.decode(fallbackData);
      articles.value = (jsonData['articles'] as List)
          .map((article) => Article.fromJson(article))
          .toList();

      // Update the JSON file with the fetched news
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/fallback_news.json';
      final file = File(filePath);

      // Write the updated news data to the file
      await file.writeAsString(json.encode({'articles': articles}));

      Get.snackbar('Notice', 'News data updated in JSON file.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to load or update news: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
    fetchNews();
  }
}
