import 'package:flutter/cupertino.dart';
import '../modal/case_modal.dart';

class CaseFeedProvider extends ChangeNotifier {
  List<CaseModal> _caseFeed = [];

  List<CaseModal> get caseFeed {
    return [..._caseFeed];
  }

  loadNewsFeed() {
    //featch newsFeed From DB
    notifyListeners();
  }

  removeFromFeed(String postId) {
    // remove a post from feed adn DB
    notifyListeners();
  }
}
