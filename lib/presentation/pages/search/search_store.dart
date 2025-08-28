import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:mobx/mobx.dart';
part 'search_store.g.dart';


class SearchStore = _SearchStore with _$SearchStore;

abstract class _SearchStore with Store {
  /// Controllers
  TextEditingController? _textEditingController;
  TextEditingController get textEditingController {
    _textEditingController ??= TextEditingController();
    return _textEditingController!;
  }

  /// Debounce timer
  Timer? _debounceTimer;
  static const Duration _debounceDelay = Duration(milliseconds: 500);

  /// Check if store is initialized
  bool get isInitialized => _textEditingController != null;

  ///
  @observable
  String searchText = '';
  @observable
  bool hasText = false;
  @observable
  bool isSearching = false;

  ///
  /// Init
  ///
  Future<void> init() async {
    _textEditingController ??= TextEditingController();

    try {
      _textEditingController!.removeListener(_onSearchTextChanged);
    } catch (e) {
      _textEditingController = TextEditingController();
    }
    
    _textEditingController!.addListener(_onSearchTextChanged);
  }

  ///
  /// Handle search text changes with debounce
  ///
  void _onSearchTextChanged() {
    if (_textEditingController == null) return;
    
    final text = _textEditingController!.text;
    _debounceTimer?.cancel();
    searchText = text;
    hasText = text.isNotEmpty;

    if (text.isNotEmpty) {
      _debounceTimer = Timer(_debounceDelay, () {
        _performSearch(text);
      });
    }
  }

  ///
  /// Perform actual search
  ///
  void _performSearch(String query) {
    if (query.isEmpty) return;
    isSearching = true;

    Future.delayed(const Duration(milliseconds: 300), () {
      isSearching = false;
    });
  }

  ///
  /// Clear search
  ///
  void clearSearch() {
    if (_textEditingController != null) {
      _textEditingController!.clear();
    }
    searchText = '';
    hasText = false;
    isSearching = false;
    _debounceTimer?.cancel();
  }

  ///
  /// Dispose
  ///
  void disposeAll() {
    _debounceTimer?.cancel();
    if (_textEditingController != null) {
      _textEditingController!.removeListener(_onSearchTextChanged);
    }
  }

  ///
  /// Full dispose - call this only when the app is shutting down
  ///
  void dispose() {
    _debounceTimer?.cancel();
    if (_textEditingController != null) {
      _textEditingController!.removeListener(_onSearchTextChanged);
      _textEditingController!.dispose();
      _textEditingController = null;
    }
  }
}