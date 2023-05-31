
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArticlePage extends StatefulWidget {
  final String title;
  final String desc;
  final String imgUrl;
  ArticlePage({this.desc, this.title, this.imgUrl});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
            child: Text(widget.title)
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200.0,
              width: double.infinity,
              decoration: BoxDecoration(
                //let's add the height

                image: DecorationImage(
                    image: NetworkImage(widget.imgUrl), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            Divider(),
            Text(
              widget.desc,
              style: TextStyle(
                //fontWeight: FontWeight.bold,
                fontFamily: 'GothicA1',
                fontSize: 16.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}