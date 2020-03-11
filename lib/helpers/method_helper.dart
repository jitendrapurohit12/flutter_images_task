import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

Future<Null> initUniLinks() async {
  // Platform messages may fail, so we use a try/catch PlatformException.
  try {
    String initialLink = await getInitialLink();
    print(initialLink);
    // Parse the link and warn the user, if it is not correct,
    // but keep in mind it could be `null`.
  } on PlatformException {
    // Handle exception by warning the user their action did not succeed
    // return?
  }
}
