import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// A controller that manages paginated data fetching and state.
///
/// [PaginationController] handles loading data in pages, tracking the current page,
/// loading state, and whether more data is available. It notifies listeners when
/// the data or loading state changes, making it suitable for use with Flutter widgets.
///
/// Type parameter [T] is the type of items in the paginated list.
///
/// Example usage:
/// ```dart
/// final controller = PaginationController<MyItem>(
///   limit: 20,
///   fetchPage: (page, size) => myApi.fetchItems(page, size),
/// );
/// ```
///
/// Properties:
/// - [limit]: The number of items to fetch per page.
/// - [fetchPage]: A function that fetches a page of data given a page number and page size.
/// - [isLoading]: Whether a page is currently being loaded.
/// - [hasMore]: Whether there are more pages to load.
/// - [list]: The accumulated list of loaded items.
///
/// Methods:
/// - [loadNextPage]: Loads the next page of data if not already loading and if more data is available.
/// - [refresh]: Clears the current data and reloads from the first page.
class PaginationController<T> extends ChangeNotifier {
  final int limit;
  final Future<List<T>> Function(int pageNumber, int pageSize) fetchPage;

  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  bool isPaginated = true;
  final List<T> list = [];
  ApiStatus apiStatus = ApiStatus.success;

  PaginationController({
    required this.limit,
    required this.fetchPage,
  });

  bool get isLoading => _isLoading;

  bool get hasMore => _hasMore;

  Future<void> loadNextPage() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newList = await fetchPage(_currentPage, limit);
      if (newList.length < limit) {
        _hasMore = false;
      }
      list.addAll(newList);
      _currentPage++;
      apiStatus = ApiStatus.success;
    } catch (e, s) {
      if ((e is DioException && e.type == DioExceptionType.connectionError) || e is SocketException) {
        apiStatus = ApiStatus.noInternet;
      } else {
        apiStatus = ApiStatus.failed;
      }
      debugPrint("😵 Something went wrong while fetching the data");
      debugPrint("🛑 Error Message => $e");
      debugPrint("🫆 Stack Trace => $s");
    } finally {
      _isLoading = false;
      if (isPaginated == false) {
        _hasMore = false;
      }
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    list.clear();
    _currentPage = 1;
    _hasMore = true;
    apiStatus = ApiStatus.success;
    await loadNextPage();
  }
}

enum ApiStatus { success, failed, noInternet }
