

import 'package:flutter/cupertino.dart';

abstract class BaseListVm<T> with ChangeNotifier{

  List<T> datas = List<T>();
  ListStatus status;
  bool hasMore = true;
  int ids = 0;
  int page = 0;
  var pageSize = 15;
  bool refreshing = false;


  void load(int page) async {
    if (this.page == page && status == ListStatus.LOADING) {
      return;
    }
    this.page = page;
    if (page == 0) {
      datas.clear();
      notifyListeners();
    }
    status  = ListStatus.LOADING;
    var tmp = await doReload(page);
    hasMore = tmp.length >= pageSize;
    datas.addAll(tmp);
    status  = ListStatus.IDLE;
    refreshing = false;
    notifyListeners();
  }

  void loadNextPage() {
    if (hasMore) {
      load(page + 1);
    }
    print("hasMore $hasMore");
  }

  Future<List<T>> doReload(int page);

  Future refresh() async {
    hasMore = true;
    refreshing = true;
    load(page);
  }



}
enum ListStatus {
  IDLE,
  LOADING,
  EMPTY,
  ERROR,
}