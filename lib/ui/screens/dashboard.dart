import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_images_task/constants/constants.dart';
import 'package:flutter_images_task/enums/notofier_state.dart';
import 'package:flutter_images_task/notifiers/images_notofier.dart';
import 'package:flutter_images_task/ui/common/basic_scaffold.dart';
import 'package:flutter_images_task/ui/common/tab_selection.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class ScreenDashboard extends StatefulWidget {
  @override
  _ScreenDashboardState createState() => _ScreenDashboardState();
}

class _ScreenDashboardState extends State<ScreenDashboard> {
  bool _grayScaleSelected = false;
  int _pageNo = 1;
  StreamController<String> _errorController = StreamController();

  @override
  void dispose() {
    _errorController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasicScaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 56, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TabSelection(
                    isSelected: !_grayScaleSelected,
                    label: kColor,
                    callback: () => setState(() => _grayScaleSelected = false),
                  ),
                  TabSelection(
                    isSelected: _grayScaleSelected,
                    label: kGrayScale,
                    callback: () => setState(() => _grayScaleSelected = true),
                  ),
                ],
              ),
            ),
          ),
          Consumer<ImagesNotifier>(
            builder: (_, notifier, __) {
              if (notifier.list.isEmpty) {
                notifier.getImages(
                  _pageNo,
                  (e) => _errorController.add(e.message),
                );
              }
              switch (notifier.state) {
                case NotifierState.loaded:
                  return getList(notifier);
                default:
                  return _pageNo == 1
                      ? SliverToBoxAdapter(
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : getList(notifier);
              }
            },
          ),
          SliverToBoxAdapter(
            child: Consumer<ImagesNotifier>(
              builder: (_, notifier, __) {
                return Column(
                  children: <Widget>[
                    SizedBox(height: 36),
                    notifier.state == NotifierState.loading
                        ? SizedBox(
                            height: 60,
                            width: 60,
                            child: CircularProgressIndicator(),
                          )
                        : RaisedButton(
                            color: Colors.blue,
                            child: Text('Load More'),
                            onPressed: () => notifier.getImages(
                              ++_pageNo,
                              (e) => _errorController.add(e.message),
                            ),
                          ),
                    SizedBox(height: 36)
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget getList(ImagesNotifier notifier) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Card(
            margin: EdgeInsets.all(4),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: _grayScaleSelected
                        ? notifier.list[index].grayscaleDownloadUrl
                        : notifier.list[index].downloadUrl,
                    height: 300,
                    width: 300,
                    placeholder: (_, __) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (_, __, ___) =>
                        Icon(Icons.error_outline, color: Colors.red, size: 100),
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('by ${notifier.list[index].author}'),
                      RaisedButton(
                        onPressed: () =>
                            Share.share('checkout Flutter Image app'),
                        color: Colors.blue,
                        child: Text(
                          'Share',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
        childCount: notifier.list.length,
      ),
    );
  }
}
