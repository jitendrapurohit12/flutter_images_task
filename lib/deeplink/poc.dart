import 'package:flutter/material.dart';
import 'package:flutter_images_task/models/router_model.dart';
import 'package:flutter_images_task/ui/screens/dashboard.dart';
import 'package:flutter_images_task/ui/screens/image_details.dart';
import 'package:provider/provider.dart';

import 'bloc.dart';

class PocWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DeepLinkBloc _bloc = Provider.of<DeepLinkBloc>(context);
    return StreamBuilder<String>(
      stream: _bloc.state,
      builder: (context, snapshot) {
        print('snap data: ${snapshot.hasData}');
        if (!snapshot.hasData) {
          return ScreenDashboard();
        } else {
          List<String> arr = snapshot.data.split('/');
          print('id poc: ${arr[arr.length - 2]}');
          return ScreenDashboard(
              id: arr[arr.length - 2], isGrayscale: arr[arr.length - 1] == '1');
        }
      },
    );
  }
}
