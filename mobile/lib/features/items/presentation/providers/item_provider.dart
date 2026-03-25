import 'package:flutter/foundation.dart';

import '../../domain/entities/item.dart';

class ItemProvider extends ChangeNotifier {
  List<Item> _allItems = [];
  List<Item> _filteredItems = [];
  bool _loading = false;
  String? _error;
  String _searchQuery = '';

  List<Item> get items => _filteredItems;
  bool get loading => _loading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  ItemProvider() {
    _generateItems();
  }

  void _generateItems() {
    _allItems = List.generate(
      50,
      (i) => Item(
        id: i,
        title: 'Item $i',
        description: 'Description for item $i',
      ),
    );
    _filteredItems = List.from(_allItems);
  }

  Future<void> fetchItems() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      _generateItems();
      _applySearch();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void search(String query) {
    _searchQuery = query;
    _applySearch();
    notifyListeners();
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredItems = List.from(_allItems);
    } else {
      _filteredItems = _allItems
          .where((item) =>
              item.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  void deleteItem(int id) {
    _allItems.removeWhere((item) => item.id == id);
    _applySearch();
    notifyListeners();
  }
}
