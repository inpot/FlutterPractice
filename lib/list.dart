import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test1/baselist.dart';

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ListVM listVm = ListVM();
     listVm.refresh();
    return Scaffold(
      appBar: AppBar(title: Text("List Test")),
      body: MultiProvider(
        child: _ListBody(),
        providers: [
          ChangeNotifierProvider.value(value: listVm),
        ],
      ),
    );
  }
}

class _ListBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ListVM vm, child) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        child: RefreshIndicator(
          semanticsLabel: "LAALAAA",
          onRefresh: () async {
            print("onRefresh");
            await Future.delayed(
              Duration(seconds: 1),
            );
            await vm.refresh();
          },
          child: buildContent(vm),
        ),
      );
    });
  }

  String emptyMsg = "Initial....";
  Widget buildContent(ListVM vm) {
    if (vm.datas.isEmpty) {
      switch (vm.status) {
        case ListStatus.IDLE:
          emptyMsg = "Pull down to Refresh...";
          break;
        case ListStatus.LOADING:
          emptyMsg = "Loading...";
          break;
        case ListStatus.EMPTY:
          emptyMsg = "No Content Here";
          break;
        case ListStatus.ERROR:
          emptyMsg = "Loading Error, try it later";
          break;
        case ListStatus.NO_NETWORK:
          emptyMsg = "No Network, pleas check Network settings";
          break;
        default:
        emptyMsg = "No Initial...";
      break;
      }

      return CustomScrollView(
        slivers: <Widget>[
          SliverFillRemaining(
            child: Center(child: Text(emptyMsg)),
          ),
        ],
      );
    }
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(),
      itemCount: (vm.datas.length + 1),
      itemBuilder: (BuildContext ctxt, int index) {
        if (index == vm.datas.length) {
          if (!vm.hasMore) {
            return new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Center(
                child: Text("没有更多数据了"),
              ),
            );
          } else {
            vm.loadNextPage();
            return new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Center(
                child: new Opacity(
                  child: new CircularProgressIndicator(),
                  opacity: 1,
                ),
              ),
            );
          }
        } else {
          User item = vm.datas[index];
          return ListTile(
            trailing: Icon(Icons.chevron_right),
            leading: SizedBox(
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  item.icon,
                ),
                child: Text("aaaa"),
              ),
              width: 60,
              height: 60,
            ),
            //ClipOval( child: CachedNetworkImage(imageUrl: item.icon,width: 60,height: 60,fit: BoxFit.cover,) ,
            title: Text("${item.id} ${item.name}"),
            subtitle: Text("${item.addr}"),
            onTap: () {
              print("onTap index:$index");
            },
          );
        }
      },
    );
  }
}

class ListVM extends BaseListVm {
  @override
  Future<List<User>> doReload(int page) {
    var request = Future.delayed(Duration(seconds: 3), () {
      List<User> tmp = List<User>();
      var fakeSize = pageSize;
      if (page > 3) {
        fakeSize = 10;
      }
      for (int i = 0; i < fakeSize; i++) {
        User item = User("test", ids, "aa${ids}a@bb.com", "xxStr xx Stat",
            "https://pic4.zhimg.com/v2-702f448c8eebd8e4a6ae19901f1305e5_1200x500.jpg");
        tmp.add(item);
        ids++;
      }
      return tmp;
    });
    return request;
  }
}

class User {
  String name;
  int id;
  String email;
  String addr;
  String icon;

  User(this.name, this.id, this.email, this.addr, this.icon);
}
