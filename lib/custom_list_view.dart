import 'package:demo/womaty/pagination_controller.dart';
import 'package:flutter/material.dart';

class CustomListView<T> extends StatefulWidget {
  final PaginationController<T> controller;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget? separatorWidget;
  final Widget? emptyListWidget;
  final Widget? noInternetWidget;
  final Widget? apiFailedWidget;
  final Widget loadingWidget;
  final bool shrinkWrap;
  final bool reverse;
  final bool isPaginated;
  final double? cacheExtent;
  final Axis scrollDirection;
  final List<Widget> slivers;

  const CustomListView({
    super.key,
    required this.controller,
    required this.itemBuilder,
    this.separatorWidget,
    this.emptyListWidget,
    this.apiFailedWidget,
    this.noInternetWidget,
    this.loadingWidget = const Center(child: CircularProgressIndicator()),
    this.shrinkWrap = false,
    this.reverse = false,
    this.isPaginated = true,
    this.cacheExtent,
    this.scrollDirection = Axis.vertical,
    this.slivers = const [],
  });

  @override
  State<CustomListView<T>> createState() => _CustomListViewState();
}

class _CustomListViewState<T> extends State<CustomListView<T>> {
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
        child: CustomScrollView(
          reverse: widget.reverse,
          controller: _scrollController,
          shrinkWrap: widget.shrinkWrap,
          physics: AlwaysScrollableScrollPhysics(),
          cacheExtent: widget.cacheExtent,
          scrollDirection: widget.scrollDirection,
          slivers: [
            ...widget.slivers,
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: list.length + (widget.controller.hasMore ? 1 : 0),
                (context, index) {
                  if (index < list.length) {
                    final item = list[index];
                    return widget.itemBuilder(context, item, index);
                  } else {
                    return Padding(
                      padding: EdgeInsets.all(16),
                      child: widget.loadingWidget,
                    );
                  }
                },
              ),
            )
          ],
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
                  child: widget.emptyListWidget ??
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
                      ),
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
