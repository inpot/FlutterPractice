import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart';
import 'package:flutter/src/widgets/text.dart' as widgets;
import 'package:html/parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:test1/basevm.dart';

class SpiderPage extends StatelessWidget {
  final vm = SpiderVM();
  @override
  Widget build(BuildContext context) {
    // vm.downImgs();
    return MultiProvider(
      child: _SpiderBody(vm),
      providers: [
        ChangeNotifierProvider.value(value: vm.imgs),
        ChangeNotifierProvider.value(value: vm),
        ],
    );
  }
}

class _SpiderBody extends StatelessWidget {
  _SpiderBody(this.vm);
  SpiderVM vm;
  @override
  Widget build(BuildContext context) {
    return Consumer<Imgs>(builder: (context, imgs, widget) {
      if (imgs.urls.length <= 0) {
        return Center( 
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Consumer<SpiderVM>(builder: (context, value,child)=> widgets.Text("Progress ${value.totalProgress}")),
              IconButton(
                icon: Icon(Icons.arrow_downward),
                onPressed: () => vm.downloadAllImgs(),
              ),
            ],
          ),
        );
      } else {
        return SingleChildScrollView(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: imgs.urls.map((item) {
              return ClipOval(
                child: InkWell(
                  child: Image.network(
                    item.thumb,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    headers: headers,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => DetailPic(item.detailLink)));
                  },
                ),
              );
            }).toList(),
          ),
        );
      }
    });
  }
}

var headers = {
  "accept": "*/*",
  "accept-language": "en-US,en;q=0.9,zh-CN;q=0.8,zh;q=0.7",
  "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.117 Safari/537.36"
};

class SpiderVM extends BaseVm with ChangeNotifier {
  var imgs = Imgs();

  String url360 = "http://www.521609.com/daxuexiaohua/";
  var token360 = 'div.index_img.list_center > ul > li > a';
  var urlKey360 = "src";
  var urlPre = "http://www.521609.com/zhuankexiaohua/list7";
  var urlFix = ".html";
  DetailPicVM detailPicVM = DetailPicVM();
  var tokenBig = "#bigimg";
  var totalProgress = "0.00";
  var path = "";

  Future<String> downloadAllImgs() async {
    var imgLinks = List<String>();
    var dir = await getApplicationSupportDirectory(); 
    var downloadDir = new Directory(dir.path + Platform.pathSeparator + "imgs");
    if(! await downloadDir.exists()){
      await downloadDir.create(recursive: true);
    }
    path =downloadDir.path;
    if(path == null || path.isEmpty){
      print("Path == null");
      return "Path == null";
    } 
    print("Path: $path");
    var dio = Dio();
    dio.options.headers = headers;
    var pageCount = 34;
    for (int i = 1; i < pageCount; i++) {
      String url = urlPre + i.toString() + urlFix;
      print("Page :$i url =  $url");
      List<Pic> page = await doDownImgs(url, token360, urlKey360);
      page.forEach((pic) async {
        String str = await detailPicVM.doDownImgs(pic.detailLink, tokenBig, "src");
        print("Page :$i url =  $url BigImg $str");
        if(str != null && str.isNotEmpty){
            imgLinks.add(str); 
            download2Disk(str, dio, path);
        }
      });
      totalProgress = (100 * i / pageCount).toStringAsFixed(2);
      notifyListeners();
    }
    return "success";
  }

  void download2Disk(String img, Dio dio, String path)async{

      print("start Download Success $img");
      int last = img.lastIndexOf("/");
      var fileName = img.substring(last + 1);
      var file = "$path/$fileName";
      dio.download(img, file, onReceiveProgress: (count, total ){
          var progress = count* 100 /total;
          int prg = progress.toInt();
          print("download ${prg}%");
          if(progress >= 100){ 
              print("download Success $img"); 
          } 
      });
  }

  void downImgs() async {
    var mz2 = await doDownImgs(url360, token360, urlKey360);
    imgs.add(mz2);
  }

  Future<List<Pic>> doDownImgs(String url, token, String urlKey) async {
    var document = await downloadHtml(url);
    var res1 = document.querySelectorAll(token);
    print("res1  ${res1.length}");
    var urls = List<Pic>();
    res1.forEach((item) {
      var img = item.getElementsByTagName("img");
      if (img == null || img.isEmpty) {
        return;
      }
      var thumb = img[0].attributes[urlKey];
      thumb = AddPrefixIfNeed(thumb);
      var link = item.attributes["href"];
      link = AddPrefixIfNeed(link);
      urls.add(Pic(thumb, link));
    });
    return urls;
  }
}

Future<Document> downloadHtml(String url,{ Map<String,String> header}) async {
  if (url == null || url.isEmpty) {
    return null;
  }
  var dio = Dio();
  if(header == null){ 
  dio.options.headers = headers;
  }else{ 
  dio.options.headers = header;
  }
  Response<String> response = await dio.get(url);
  print("statusCode ${response.statusCode}");
  if (response.statusCode != 200) {
    return null;
  }
  return parse(response.data);
}

class Imgs with ChangeNotifier {
  List<Pic> urls = List();
  void add(List<Pic> data) {
    if (data != null && data.isNotEmpty) {
      urls.addAll(data);
    }
    notifyListeners();
  }

  void setData(List<Pic> data) {
    urls.clear();
    add(data);
  }
}

class Pic {
  Pic(this.thumb, this.detailLink);
  String detailLink;
  String thumb;
}

class DetailPic extends StatelessWidget {
  DetailPic(this.link);
  final String link;
  DetailPicVM vm = DetailPicVM();

  @override
  Widget build(BuildContext context) {
    vm.loaded = false;
    vm.loadImg(link);
    return Scaffold(
        appBar: AppBar(
          title: widgets.Text("aaaa"),
        ),
        body: MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: vm,
            )
          ],
          child: _DetailBody(),
        ));
  }
}

class _DetailBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DetailPicVM>(
      builder: (ctx, value, child) {
        if (!value.loaded) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Image.network(
            value.imgUrl,
            fit: BoxFit.cover,
            headers: headers,
          );
        }
      },
    );
  }
}

class DetailPicVM with ChangeNotifier {
  bool loaded = false;
  String imgUrl = null;
  var token = "#bigimg";
  void loadImg(String url) async {
    imgUrl = await doDownImgs(url, token, "src");
    print("BigImgLink $imgUrl");
    loaded = true;
    notifyListeners();
  }

  Future<String> doDownImgs(String url, String token, String urlKey) async {
    var document = await downloadHtml(url);
    var res1 = document.querySelectorAll(token);
    if(res1.isEmpty){
    print("download failed url:${url} token=$token urlKey=$urlKey");
      return null;
    }
    print("res1  ${res1.length}");
    var urls = List<String>();
    res1.forEach((item) {
      var link = item.attributes["src"];
      link = AddPrefixIfNeed(link);
      urls.add(link);
    });
    return urls[0];
  }
}

var prefix = "http://www.521609.com";
String AddPrefixIfNeed(String path) {
  if (!path.startsWith("http")) {
    path = prefix + path;
  }
  return path;
}
