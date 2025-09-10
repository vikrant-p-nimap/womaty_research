import 'dart:async';

import 'package:demo/womaty/pagination_controller.dart';
import 'package:demo/womaty/paging_list_view.dart';
import 'package:flutter/material.dart';

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  late PaginationController paginationController;

  @override
  void initState() {
    super.initState();
    paginationController = PaginationController(limit: 10, fetchPage: completerFunc);
  }

  Future<List<dynamic>> completerFunc(int pageNumber, int pageSize) async {
    List list = [];

    final singlePost = "Post";
    final postList = "List";

    await Future.delayed(Duration(seconds: 1), () {
      list = List.generate(pageSize, (index) {
        return index.isEven ? singlePost : postList;
      });
    });

    if (pageNumber == 3) {
      return Future.error("error");
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PagingListView(
        controller: paginationController,
        scrollDirection: Axis.vertical,
        retryButtonWidget: (onPressed) {
          return IconButton(
            onPressed: onPressed,
            style: IconButton.styleFrom(
              backgroundColor: Colors.blue.shade800,
              shape: const CircleBorder(),
            ),
            icon: Icon(Icons.refresh_rounded, color: Colors.white),
          );
        },
        separatorWidget: Divider(color: Colors.black),
        itemBuilder: (context, item, index) {
          // return CircleAvatar(
          //   radius: 50,
          //   backgroundColor: Colors.redAccent,
          // );
          if (item == "Post") {
            return AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: Colors.lightBlue.shade50,
              ),
            );
          } else {
            return AspectRatio(
              aspectRatio: 1,
              child: PageView(
                children: [
                  Container(
                    color: Colors.redAccent.shade200,
                  ),
                  Container(
                    color: Colors.amber.shade200,
                  ),
                  Container(
                    color: Colors.lightBlue.shade200,
                  ),
                  Container(
                    color: Colors.lightGreen.shade200,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
