
import 'package:demo/womaty/pagination_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PagingListView<T> extends StatefulWidget {
  final PaginationController<T> controller;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget? separatorWidget;
  final Widget? emptyListWidget;
  final Widget? noInternetWidget;
  final Widget? apiFailedWidget;
  final Widget Function(VoidCallback onPressed)? retryButtonWidget;
  final Widget loadingWidget;
  final bool shrinkWrap;
  final bool reverse;
  final bool isPaginated;
  final EdgeInsetsGeometry? padding;
  final double? cacheExtent;
  final Axis scrollDirection;

  /// A widget that displays a paginated list view with support for infinite scrolling,
  /// pull-to-refresh, custom item and separator widgets, and loading/empty states.
  ///
  /// The [PagingListView] is a generic widget that works with a [PaginationController]
  /// to manage the loading and refreshing of paginated data. It provides a customizable
  /// list view that can display loading indicators, separators, and empty state widgets.
  ///
  /// Type parameter [T] is the type of items in the list.
  ///
  /// {@tool snippet}
  /// Example usage:
  /// ```dart
  /// PagingListView<MyItem>(
  ///   controller: myPaginationController,
  ///   itemBuilder: (context, item, index) => ListTile(title: Text(item.name)),
  /// )
  /// ```
  /// {@end-tool}
  ///
  /// Properties:
  ///
  /// - [controller]: The [PaginationController] responsible for managing the paginated data,
  ///   loading more items, and notifying listeners of changes.
  /// - [itemBuilder]: A function that builds each item in the list, given the [BuildContext],
  ///   the item of type [T], and its index.
  /// - [separatorWidget]: An optional widget to display between list items. If not provided,
  ///   a default vertical space is used.
  /// - [emptyListWidget]: An optional widget to display when the list is empty and not loading.
  ///   If not provided, a default "Not Found" widget is shown.
  /// - [loadingWidget]: The widget to display as a loading indicator at the bottom of the list
  ///   when more items are being loaded, or in the center when the list is initially loading.
  ///   Defaults to a centered [CircularProgressIndicator].
  /// - [shrinkWrap]: Whether the extent of the list view should be determined by the contents
  ///   being viewed. Defaults to `false`.
  /// - [padding]: Optional padding to apply around the list view.
  /// - [cacheExtent]: The number of pixels to cache before and after the visible portion of the list.
  /// - [scrollDirection]: The axis along which the list scrolls. Defaults to [Axis.vertical].
  const PagingListView({
    super.key,
    required this.controller,
    required this.itemBuilder,
    this.separatorWidget,
    this.emptyListWidget,
    this.apiFailedWidget,
    this.noInternetWidget,
    this.retryButtonWidget,
    this.loadingWidget = const Center(child: CircularProgressIndicator()),
    this.shrinkWrap = false,
    this.reverse = false,
    this.isPaginated = true,
    this.padding,
    this.cacheExtent,
    this.scrollDirection = Axis.vertical,
  });

  @override
  State<PagingListView<T>> createState() => _PagingListViewState<T>();
}

class _PagingListViewState<T> extends State<PagingListView<T>> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.controller.isPaginated = widget.isPaginated;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.addListener(_onScroll);
      widget.controller.addListener(_onUpdate);
      loadPage();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    widget.controller.removeListener(_onUpdate);
    super.dispose();
  }


  void loadPage() {
    widget.controller.loadNextPage().then((value) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (_scrollController.hasClients && _scrollController.position.maxScrollExtent <= 0 && widget.controller.hasMore && widget.isPaginated) {
          loadPage();
        }
      });
    });
  }

  void _onScroll() {
    if (!widget.isPaginated) return;
    if (widget.reverse) {
      if (_scrollController.position.pixels <= _scrollController.position.minScrollExtent + 200 && widget.controller.hasMore) {
        widget.controller.loadNextPage();
      }
    } else {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && widget.controller.hasMore) {
        widget.controller.loadNextPage();
      }
    }
  }

  void _onUpdate() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final list = widget.controller.list;

    if (list.isNotEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          await widget.controller.refresh();
        },
        child: ListView.separated(
          clipBehavior: Clip.hardEdge,
          controller: _scrollController,
          itemCount: list.length + (widget.controller.hasMore ? 1 : 0),
          physics: AlwaysScrollableScrollPhysics(),
          cacheExtent: widget.cacheExtent,
          padding: widget.padding,
          shrinkWrap: widget.shrinkWrap,
          reverse: widget.reverse,
          scrollDirection: widget.scrollDirection,
          itemBuilder: (context, index) {
            if (index < list.length) {
              final item = list[index];
              return widget.itemBuilder(context, item, index);
            } else if (list.isNotEmpty && widget.controller.hasMore && widget.controller.apiStatus != ApiStatus.success) {
              return Padding(
                padding: EdgeInsets.all(16),
                child: widget.retryButtonWidget?.call(() {
                  widget.controller.apiStatus = ApiStatus.success;
                  _onUpdate();
                  widget.controller.loadNextPage();
                }) ?? CupertinoButton(
                  onPressed: () {
                    widget.controller.apiStatus = ApiStatus.success;
                    _onUpdate();
                    widget.controller.loadNextPage();
                  },
                  color: Colors.blue.shade800,
                  child: Icon(Icons.refresh, color: Colors.white, size: 25),
                ),
              );
            } else {
              return Padding(
                padding: EdgeInsets.all(16),
                child: widget.loadingWidget,
              );
            }
          },
          separatorBuilder: (context, index) {
            if (index < list.length) {
              return widget.separatorWidget ?? SizedBox(height: 5, width: 5);
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      );
    } else {
      return LayoutBuilder(
        builder: (context, constraints) {
          if (widget.controller.isLoading) {
            return widget.loadingWidget;
          }
          return RefreshIndicator(
            onRefresh: () async {
              await widget.controller.refresh();
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                child: Center(
                  child: noDataWidget(),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  Widget noDataWidget() {
    if (widget.controller.apiStatus == ApiStatus.failed) {
      return widget.apiFailedWidget ??
          Column(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded, size: 100),
              Text(
                "Something went wrong",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ],
          );
    } else if (widget.controller.apiStatus == ApiStatus.noInternet) {
      return widget.noInternetWidget ??
          Column(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.signal_wifi_connected_no_internet_4_rounded, size: 100),
              Text(
                "No Internet",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ],
          );
    } else {
      return widget.emptyListWidget ??
          Column(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.not_interested_sharp, size: 100),
              Text(
                "Not Found",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ],
          );
    }
  }
}
