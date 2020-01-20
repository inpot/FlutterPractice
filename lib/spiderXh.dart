import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test1/spider.dart';

class SpiderXh extends StatelessWidget {
  final SpiderVM vm = SpiderVM();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        RaisedButton(
          child: Text("Start"),
          onPressed: () => vm.startDownload(),
        ),
        RaisedButton(
          child: Text("Download guai"),
          onPressed: () => vm.startDownloadGuai(),
        ),
        RaisedButton(
          child: Text("TestBt"),
          onPressed: () {
            var link = "红色内衣+黑色吊带丝袜";
            var splits = link.split("/");
            print(splits[0]);
          },
        ),
      ]),
    );
  }
}

class SpiderVM with ChangeNotifier {
  var prefix = "http://www.7dapei.com/tuku/";
  var listUrl = "http://www.7dapei.com/tuku/siwa.html";
  var imgPrefix = "http://www.7dapei.com/tuku/images/siwa/";

  void startDownloadGuai() async {
    var catlog = ["xiaohua", "cosplay", "xiezhen", "chemo", "zipai"];
    var host = "http://www.guaihaha.cn/";
    var listPicToken = "#leftChild > div.listPic > a";
    Directory appDocDir = await getExternalStorageDirectory();
    String path = appDocDir.path;
    var catIndex = 1;
    catlog.forEach((cat) async {
      if (catIndex != 1) {
        await Future.delayed(Duration(seconds: 300 * catIndex));
      }
      var listUrlGuai = "$host$cat/page_";
      var listSuffix = ".html";
      var listRefer = "$host$cat/page_1.html";
      var picToken =
          "#leftChild > div.b1_top > div.b1_cont.art_show.cf > div.content.contentl > p > img";
      var dio = Dio();
      dio.options.headers = headers;
      for (int i = 1; i <= 18; i++) {
        if (i != 1) {
          await Future.delayed(Duration(seconds: 120 * i));
        }
        var listPage = "$listUrlGuai$i$listSuffix";
        dio.options.headers["Referer"] = listRefer;
        var document = await downloadHtml(listPage);

        var divs = document.querySelectorAll(listPicToken);

        var j = 1;
        var lists = await divs.forEach((item) async {
          j++;
          if (j != 1) {
            await Future.delayed(Duration(seconds: 80 * j));
          }
          var link = host + item.attributes["href"];
          var title =
              item.attributes["title"].replaceAll("\n", "/").split("/")[0];
          dio.options.headers["Referer"] = link;
          var person = await downloadHtml(link);
          var picAll = person.querySelectorAll(picToken);
          picAll.forEach((item) async {
            var realUrl = item.attributes["src"];
            dio.options.headers["Referer"] = link;
            var fileName = realUrl.substring(realUrl.lastIndexOf("/") + 1);
            download2Disk(realUrl, dio, "$path/$fileName");
          });
        });
      }
    });

    print("size: ");
  }

  void startDownload() async {
    var document = await downloadHtml(listUrl);
    var divs = document
        .querySelectorAll("div.pinDaoPageImg > div > div.same > h3 > a");

    Directory appDocDir = await getExternalStorageDirectory();
    String path = appDocDir.path;
    var dio = Dio();
    dio.options.headers = headers;
    var lists = await divs.forEach((item) async {
      var link = prefix + item.attributes["href"];
      var title = item.text;
      var slash = link.lastIndexOf("/");
      var point = link.lastIndexOf(".");
      var userIndex = link.substring(slash + 1, point);
      print("$title $link");
      var header = headers;
      header["Referer"] = listUrl;
      var person = await downloadHtml(link);
      var picAll = person.querySelectorAll("#contentID > div.pageNo > a");
      var picCount = picAll.length;
      var dirName = title.split(" ")[0];
      var dirPath = "$path/$dirName";
      Directory dir = Directory(dirPath);
      // if(!await dir.exists()){
      await dir.create();
      // }
      for (var j = 1; j <= picCount; j++) {
        var referUrl = listUrl;
        if (j > 1) {
          referUrl.replaceFirst(".html", "_$j.html");
        }
        dio.options.headers["Referer"] = listUrl;
        var fileName = "$userIndex.$j.jpg";
        var realUrl = imgPrefix + fileName;
        download2Disk(realUrl, dio, "$dirPath/$fileName");
      }
    });
    print("size: ");
  }

  var headers = {
    "Referer": "http://www.8dapei.com/tuku/qingchun.html",
    "Upgrade-Insecure-Requests": "1",
    "User-Agent":
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.117 Safari/537.36",
  };

  void download2Disk(String img, Dio dio, String path) async {
    print("start download $img");
    dio.download(img, path, onReceiveProgress: (count, total) {
      var progress = count * 100 / total;
      int prg = progress.toInt();
      // print("download ${prg}%");
      if (progress >= 100) {
        print("download Success $img");
      }
    });
  }
}

class User {
  String title;
  String links;
}
