import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Auth extends StatelessWidget {
  final vm = GankVm();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("CachedImage,TabBar"),
          actions: <Widget>[
            PopupMenuButton(itemBuilder:(context){
              var result = List<PopupMenuEntry>();
              result.add(PopupMenuItem(child: IconButton(icon: Icon(Icons.category,),onPressed: ()=>print("click"),), ));
              return result;


            } ,)

          ],
        ),
        body: MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: vm),
          ],
          child: _Body(),
        ));
  }
}

class _Body extends StatelessWidget {
  final mPageController = PageController(initialPage: 0);
  TabController tabController;
  @override
  Widget build(BuildContext context) {
    return Consumer<GankVm>(
      builder: buildBody,
    );
  }

  Widget buildBody(BuildContext context, GankVm vm, Widget child) {
    print("buildBody ${vm.loading}");
    if (vm.loading == 0) {
      return Center(
        child: Column(children: [
          Text("loading"),
          RaisedButton(
            child: Text("loadData"),
            onPressed: () => loadData(vm),
          )
        ]),
      );
    } else {
      return DefaultTabController(
        length: vm.gankToday.category.length,
        child: Column(children: [
          TabBar(
            labelColor: Colors.brown,
            tabs: buildTabBar(vm.gankToday.category),
            isScrollable: true,
            onTap: (position) => mPageController.animateToPage(position,
                duration: Duration(milliseconds: 200), curve: Curves.bounceIn),
          ),
          Expanded(
            flex: 1,
            child: PageView.builder(
              controller: mPageController,
              itemCount: vm.gankToday.category.length,
              itemBuilder: (context, position) {
                if (ctx == null) {
                  ctx = context;
                }
                return buildItemPage(
                    vm.gankToday.result[vm.gankToday.category[position]]);
              },
              onPageChanged: onPageChange,
            ),
          )
        ]),
      );
    }
  }

  BuildContext ctx;

  void onPageChange(int index) {
    print("onPageChnaged $index");
    DefaultTabController.of(ctx).animateTo(index);
  }

  List<Widget> buildTabBar(List<String> cats) {
    var tabs = new List<Tab>();
    var tmp = cats.map((item) => Tab(
          text: item,
          //  icon: Icon(Icons.chat_bubble),
        ));
    tabs.addAll(tmp);
    return tabs;
  }

  Widget buildItemPage(List<GankItem> datas) {
    return ListView.separated(
      shrinkWrap: true,
      // physics: new NeverScrollableScrollPhysics(),
      separatorBuilder: (context, position) => Divider(),
      itemCount: datas.length,
      itemBuilder: (context, position) {
        var item = datas[position];
        var imgUrl;
        if (item.images.length > 0) {
          imgUrl = item.images[0];
        } else {
          if (item.url.endsWith("jpg")) {
            imgUrl = item.url;
          } else {
            imgUrl =
                "https://rs.0.gaoshouyou.com/32/f5/0c/37f57551e20c6d1cbc4d64569048a27f.jpeg";
          }
        }

        return ListTile(
          title: Text(
            item.desc,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            "${item.url}",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          leading: ClipOval(
            child: CachedNetworkImage(
              imageUrl: imgUrl,
              fit: BoxFit.fill,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              width: 60,
              height: 60,
            ),
          ),
          onTap: () async => {
            if (await canLaunch(item.url))
              {await launch(item.url)}
            else
              {throw 'Could not launch ${item.url}'}
          },
        );
      },
    );
  }

  void loadData(GankVm vm) async {
    await vm.loadData();
  }
}

class GankVm with ChangeNotifier {
  var _loading = 0;
  set loading(int value) {
    _loading = value;
    notifyListeners();
  }

  get loading => _loading;
  GankToday gankToday;

  Future loadData() async {
    var dio = Dio();
    var respons = await dio.get<String>("http://gank.io/api/today");
    gankToday = GankToday.fromJson(respons.data);
    loading = 1;
  }
}

class GankToday {
  List<String> category;
  bool error;
  Map<String, List<GankItem>> result;

  static GankToday fromJson(String content) {
    Map<String, dynamic> today = jsonDecode(content);
    var result = GankToday();
    result.category = List<String>();
    List<dynamic> ccts = today["category"];
    ccts.forEach((item) => result.category.add(item));

    result.error = today["error"];
    result.result = Map<String, List<GankItem>>();
    Map<String, dynamic> contents = today["results"];
    result.category.forEach((cat) {
      var lists = List<GankItem>();
      List<dynamic> tmp = contents[cat];

      tmp.forEach((item) => lists.add(GankItem.fromJson(item)));
      result.result[cat] = lists;
    });

    return result;
  }
}

class GankItem {
  String id;
  String createdAt;
  String desc;
  String publishedAt;
  String source;
  String type;
  String url;
  bool used;
  String who;
  List<String> images;

  static GankItem fromJson(Map<String, dynamic> map) {
    var item = GankItem();
    item.id = map["_id"];
    item.createdAt = map["createdAt"];
    item.desc = map["desc"];
    item.publishedAt = map["publishedAt"];
    item.source = map["source"];
    item.type = map["type"];
    item.url = map["url"];
    item.used = map["used"];
    item.who = map["who"];
    item.images = List<String>();
    List<dynamic> imgs = map["images"];
    imgs?.forEach((value) => item.images.add(value));
    return item;
  }
}
