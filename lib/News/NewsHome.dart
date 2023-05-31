import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Widgets/Loading.dart';
import 'CategoryModel.dart';
import 'News.dart';
import 'NewsCategoryCard.dart';
import 'NewsTile.dart';

class NewsHome extends StatefulWidget {

  @override
  _NewsHomeState createState() => _NewsHomeState();
}

class _NewsHomeState extends State<NewsHome> {

  List<CategorieModel> categories = List<CategorieModel>();
  var newslist;
  bool _loading ;

  @override
  void initState() {
    _loading = true;
    super.initState();
    categories = getCategories();
    getNews();
  }

  void getNews() async {
    News news = News();
    await news.getNews();
    newslist = news.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "MMC News",
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            // Text(
            //   " News",
            //   style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            // )
          ],
        ),
        actions: <Widget>[
          Opacity(
              opacity:0,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.share,)))
        ],
        backgroundColor: Colors.green[800],
        //backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: categories!=null && newslist !=null ?SingleChildScrollView(
        child:Column(
          children:<Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                height: 70,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return CategoryCard(
                        imageAssetUrl: categories[index].imageAssetUrl,
                        categoryName: categories[index].categorieName,
                      );
                    }),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 16),
              child: ListView.builder(
                  itemCount: newslist.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return NewsTile(
                      imgUrl: newslist[index].urlToImage ?? "",
                      title: newslist[index].title ?? "",
                      desc: newslist[index].description ?? "",
                      content: newslist[index].content ?? "",
                      posturl: newslist[index].articleUrl ?? "",
                    );
                  }),
            )
          ],
        )
      ):
       Align(
       alignment: Alignment.center,
       child: Loading(),
      ),
    );
  }
}