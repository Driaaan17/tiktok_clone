import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category_model.dart';

class VideoProvider with ChangeNotifier {
  final supabase = Supabase.instance.client;
  List<Category> _categories = [];
  String _selectedCategory = 'semua';
  bool _isLoading = false;
  String? _errorMessage;

  List<Category> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await supabase.from('categories').select('*');
      _categories = [
        Category(id: 0, name: 'Semua', slug: 'semua', isActive: true),
        ...response.map((e) => Category.fromJson(e)).toList(),
      ];
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load categories';
    }

    _isLoading = false;
    notifyListeners();
  }

  void selectCategory(String slug) {
    _selectedCategory = slug;
    notifyListeners();
  }
}