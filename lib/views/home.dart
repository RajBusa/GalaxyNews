import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:thebulletin/helper/data.dart';
import 'package:thebulletin/helper/news.dart';
import 'package:thebulletin/models/article_model.dart';
import 'package:thebulletin/models/category_model.dart';
import 'package:thebulletin/views/article_view.dart';
import 'package:thebulletin/views/category_view.dart';
import 'package:thebulletin/views/live_news.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = <CategoryModel>[];
  List<ArticleModel> articles = <ArticleModel>[];

  bool _loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categories = getCategories();
    getNews();
  }

  getNews() async {
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Galaxy',
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      'News',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ]),
              backgroundColor: Colors.black,
              bottom: TabBar(indicatorColor: Colors.green, tabs: [
                Tab(
                    child: Text('Article',
                        style: TextStyle(
                          color: Colors.white,
                        ))),
                Tab(
                    child: Text('Category',
                        style: TextStyle(
                          color: Colors.white,
                        ))),
              ]),
            ),
            body: TabBarView(
              children: [
                Container(
                  // padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  color: Colors.black,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        return BlogTile(
                          imageUrl: articles[index].urlToImage,
                          title: articles[index].title,
                          desc: articles[index].description,
                          url: articles[index].url,
                        );
                      }),
                ),
                Container(
                  height: 70,
                  color: Colors.black,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return CategoryTile(
                          imageUrl: categories[index].imageUrl,
                          categoryName: categories[index].CategoryName,
                        );
                      }),
                ),
              ],
            ),
          ),
        )
        // _loading
        //     ? Center(
        //         child: Container(
        //           child: CircularProgressIndicator(),
        //         ),
        //       )
        //     : SingleChildScrollView(
        //         child: Container(
        //             padding: EdgeInsets.symmetric(horizontal: 16),
        //             child: Column(
        //               //categories
        //               children: <Widget>[
        //                 Container(
        //                   height: 70,
        //                   child: ListView.builder(
        //                       shrinkWrap: true,
        //                       scrollDirection: Axis.horizontal,
        //                       itemCount: categories.length,
        //                       itemBuilder: (context, index) {
        //                         return CategoryTile(
        //                           imageUrl: categories[index].imageUrl,
        //                           categoryName: categories[index].CategoryName,
        //                         );
        //                       }),
        //                 ),
        //                 SizedBox(height: 15.0),
        //                 //blogs
        //                 Container(
        //                   child: ListView.builder(
        //                       shrinkWrap: true,
        //                       physics: ClampingScrollPhysics(),
        //                       itemCount: articles.length,
        //                       itemBuilder: (context, index) {
        //                         return BlogTile(
        //                           imageUrl: articles[index].urlToImage,
        //                           title: articles[index].title,
        //                           desc: articles[index].description,
        //                           url: articles[index].url,
        //                         );
        //                       }),
        //                 ),
        //               ],
        //             )),
        //       ),
        );
  }
}

class CategoryTile extends StatelessWidget {
  final imageUrl, categoryName;
  CategoryTile({required this.imageUrl, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //....................................
      onTap: () {
        if (categoryName == "Live news") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LiveNews()));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CategoryNews(
                        category: categoryName.toString().toLowerCase(),
                      )));
        }
      },
      //....................................
      child: Container(
        margin: EdgeInsets.only(top: 6, bottom: 6),
        child: Stack(
          children: <Widget>[
            Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: MediaQuery.of(context).size.width * .9,
                    height: 65,
                    fit: BoxFit.cover,
                  )),
            ),
            Center(
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * .9,
                height: 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.black38,
                ),
                child: Text(categoryName,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String imageUrl, title, desc, url;
  BlogTile(
      {required this.imageUrl,
      required this.title,
      required this.desc,
      required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ArticleView(
                      blogUrl: url,
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8, top: 8),
        child: Column(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(imageUrl)),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              desc,
              style: TextStyle(
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}
