import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart';
import 'package:csslib/parser.dart' as css;
import 'package:flutter/src/widgets/text.dart' as widget;
import 'package:html/parser.dart';
import 'package:provider/provider.dart';
import 'package:test1/basevm.dart';

class SpiderPage extends StatelessWidget {
  final vm = SpiderVM();
  @override
  Widget build(BuildContext context) {
    vm.downImgs();
    return MultiProvider(
      child: _SpiderBody(vm),
      providers: [ChangeNotifierProvider.value(value: vm.imgs)],
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
          child: IconButton(
            icon: Icon(Icons.arrow_downward),
            onPressed: () => vm.downImgs(),
          ),
        );
      } else {
        return SingleChildScrollView(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: imgs.urls.map((item) {
              return ClipOval(child: InkWell(
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
                },),
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
  "User-Agent":
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.117 Safari/537.36"
};

class SpiderVM extends BaseVm {
  var imgs = Imgs();

  String url360 = "http://www.521609.com/daxuexiaohua/"; 
  var token360 = 'div.index_img.list_center > ul > li > a';
  var urlKey360 = "src";

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

Future<Document> downloadHtml(String url) async {
  if(url == null || url.isEmpty){
    return null;
  }
  var dio = Dio();
  dio.options.headers = headers;
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
      appBar: AppBar(title: widget.Text("aaaa"),),
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

  Future<String> doDownImgs(String url, token, String urlKey) async {
    var document = await downloadHtml(url);
    var res1 = document.querySelectorAll(token);
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
