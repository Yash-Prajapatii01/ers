import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../data/models/udfOptionsModel.dart';
import 'SearchService.dart';

/// Enum to define different search types
enum SearchType {
  local,
  network,
}

/// Configuration for search behavior
class SearchConfig {
  final SearchType searchType;
  final String? fieldType; // For network searches (PRJSS, RSRSS, REQSS)
  final int minQueryLength;
  final Duration debounceDelay;
  final bool caseSensitive;
  final bool exactMatch;

  const SearchConfig({
    this.searchType = SearchType.local,
    this.fieldType,
    this.minQueryLength = 0,
    this.debounceDelay = const Duration(milliseconds: 300),
    this.caseSensitive = false,
    this.exactMatch = false,
  });
}

/// Search result wrapper
class SearchResult {
  final List<UdfOptionsModel> options;
  final bool isLoading;
  final String? error;
  final SearchType sourceType;

  const SearchResult({
    required this.options,
    this.isLoading = false,
    this.error,
    this.sourceType = SearchType.local,
  });

  SearchResult copyWith({
    List<UdfOptionsModel>? options,
    bool? isLoading,
    String? error,
    SearchType? sourceType,
  }) {
    return SearchResult(
      options: options ?? this.options,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      sourceType: sourceType ?? this.sourceType,
    );
  }
}

/// Main search handler class
class UnifiedSearchHandler extends ChangeNotifier {
  final SearchConfig config;
  final List<UdfOptionsModel> _originalOptions;

  SearchResult _currentResult;
  Timer? _debounceTimer;
  String _lastQuery = '';

  UnifiedSearchHandler({
    required this.config,
    required List<UdfOptionsModel> originalOptions,
  }) : _originalOptions = List.from(originalOptions),
        _currentResult = SearchResult(options: originalOptions);

  SearchResult get currentResult => _currentResult;
  List<UdfOptionsModel> get filteredOptions => _currentResult.options;
  bool get isLoading => _currentResult.isLoading;
  String? get error => _currentResult.error;

  /// Update original options (useful when network data changes)
  void updateOriginalOptions(List<UdfOptionsModel> newOptions) {
    print("In the updateOriginalOptions");
    _originalOptions.clear();
    _originalOptions.addAll(newOptions);
    // If no active search, update current result
    if (_lastQuery.isEmpty) {
      _updateResult(SearchResult(options: newOptions));
    } else {
      // Re-run current search with new data
      search(_lastQuery);
    }
  }

  /// Main search method
  void search(String query) {
    _lastQuery = query.trim();
    // Cancel previous timer
    _debounceTimer?.cancel();
    // Handle empty query
    if (_lastQuery.isEmpty) {
      _updateResult(SearchResult(options: _originalOptions));
      return;
    }
    // Check minimum query length
    if (_lastQuery.length < config.minQueryLength) {
      _updateResult(SearchResult(options: []));
      return;
    }

    // Set loading state
    _updateResult(_currentResult.copyWith(isLoading: true, error: null));

    // Debounce the search
    _debounceTimer = Timer(config.debounceDelay, () {
      _performSearch(_lastQuery);
    });
  }

  /// Clear search and reset to original options
  void clearSearch() {
    _debounceTimer?.cancel();
    _lastQuery = '';
    _updateResult(SearchResult(options: _originalOptions));
  }

  /// Perform the actual search based on configuration
  Future<void> _performSearch(String query) async {
    try {
      List<UdfOptionsModel> results = [];

      switch (config.searchType) {
        case SearchType.local:
          results = _performLocalSearch(query);
          _updateResult(SearchResult(
            options: results,
            sourceType: SearchType.local,
          ));
          break;

        case SearchType.network:
          print('Query - ${query}');
          results = await _performNetworkSearch(query);
          _updateResult(SearchResult(
            options: results,
            sourceType: SearchType.network,
          ));
          print(results.first.name);
          break;

      }
    } catch (e) {
      _updateResult(SearchResult(
        options: [],
        error: e.toString(),
      ));
    }
  }

  /// Perform local search on original options
  List<UdfOptionsModel> _performLocalSearch(String query) {
    print("In the performLocalSearch");
    final searchQuery = config.caseSensitive ? query : query.toLowerCase();

    return _originalOptions.where((option) {
      final optionName = config.caseSensitive ? option.name : option.name.toLowerCase();

      if (config.exactMatch) {
        return optionName == searchQuery;
      } else {
        return optionName.contains(searchQuery);
      }
    }).toList();
  }

  /// Perform network search using SearchService
  Future<List<UdfOptionsModel>> _performNetworkSearch(String query) async {
    print("In the performNetworkSearch");
    if (config.fieldType == null) {
      throw Exception('Field type is required for network search');
    }

    switch (config.fieldType) {
      case 'PRJSS':
        return await SearchService.searchProject(query);
      case 'RSRSS':
        return await SearchService.searchResource(query);
      case 'REQSS':
        return await SearchService.searchRequirements(query);
      case 'TAGS':
        return await SearchService.searchTags(query);
      default:
        throw Exception('Unsupported field type: ${config.fieldType}');
    }
  }

  /// Update current result and notify listeners
  void _updateResult(SearchResult result) {
    _currentResult = result;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

/// Factory class to create search handlers for different scenarios
class SearchHandlerFactory {
  /// Create handler for local-only search
  static UnifiedSearchHandler createLocalSearch({
    required List<UdfOptionsModel> options,
    int minQueryLength = 1,
    Duration debounceDelay = const Duration(milliseconds: 300),
    bool caseSensitive = false,
    bool exactMatch = false,
  }) {
    return UnifiedSearchHandler(
      config: SearchConfig(
        searchType: SearchType.local,
        minQueryLength: minQueryLength,
        debounceDelay: debounceDelay,
        caseSensitive: caseSensitive,
        exactMatch: exactMatch,
      ),
      originalOptions: options,
    );
  }

  /// Create handler for network-only search
  static UnifiedSearchHandler createNetworkSearch({
    required String fieldType,
    List<UdfOptionsModel> initialOptions = const [],
    int minQueryLength = 2,
    Duration debounceDelay = const Duration(milliseconds: 500),
  }) {
    print('In the createNetworkSearch');
    return UnifiedSearchHandler(
      config: SearchConfig(
        searchType: SearchType.network,
        fieldType: fieldType,
        minQueryLength: minQueryLength,
        debounceDelay: debounceDelay,
      ),
      originalOptions: initialOptions,
    );
  }
}

/// Extension methods for easier integration
extension SearchHandlerHelpers on UnifiedSearchHandler {
  /// Check if handler supports the given field type
  bool supportsFieldType(String fieldType) {
    return config.fieldType == fieldType || config.searchType == SearchType.local;
  }

  /// Get grouped options (if performing field has groups)
  Map<String, List<UdfOptionsModel>> get groupedOptions {
    final grouped = <String, List<UdfOptionsModel>>{};
    final ungrouped = <UdfOptionsModel>[];

    for (final option in filteredOptions) {
      final group = option.performing?.trim();
      if (group != null && group.isNotEmpty) {
        grouped.putIfAbsent(group, () => []).add(option);
      } else {
        ungrouped.add(option);
      }
    }

    if (ungrouped.isNotEmpty) {
      grouped[''] = ungrouped;
    }

    return grouped;
  }

  /// Check if results are empty but not due to loading
  bool get hasNoResults => filteredOptions.isEmpty && !isLoading && error == null;
}