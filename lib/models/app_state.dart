import 'package:flutter/foundation.dart';

class AppState with ChangeNotifier {
  bool _isNews = false;
  bool get isNews => _isNews;

  String get contentTitle {
    return _isNews
        ? "Esta es la página de noticas"
        : "Esta es la página de información";
  }

  void tooglePage(bool isNews) {
    _isNews = isNews;
    notifyListeners();
  }
}
