import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(new MaterialApp(
      home: new MyHomePage(),
      ));
}

class MyHomePage extends StatefulWidget {
  MyHomePageState createState() => new MyHomePageState();
}

class RedditTable extends StatelessWidget {
  List posts;
  List containers;
  RedditTable(List posts) {
    this.posts = posts;
    this.containers = new List<Container>();

    for (var i = 0; i < posts.length; i++) {
      var post = posts[i]["data"];
      var title = post["title"];
      var subreddit = post["subreddit_name_prefixed"];
      var thumbnail = post["thumbnail"];
      var container = new Container(decoration: new BoxDecoration(color: Colors.black),
                                    padding: new EdgeInsets.only(right: 5.0,
                                                                 top: 5.0,
                                                                 bottom: 5.0),
                                    child: new Row(crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                        new Expanded(child:
                                                                new Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                                         children: [
                                                                           new Container(padding: new EdgeInsets.only(left: 5.0),
                                                                                          child: new Text(subreddit,
                                                                                                          textScaleFactor: 0.8,
                                                                                                          style: new TextStyle(color: Colors.grey, fontSize: 12.0),
                                                                                                      ),
                                                                                          ),
                                                                           new Container(padding: new EdgeInsets.only(left: 5.0),
                                                                                         child: new Text(title,
                                                                                                         textScaleFactor: 0.8,
                                                                                                         style: new TextStyle(color: Colors.white, fontSize: 14.0),
                                                                                             ),
                                                                               ),

                                                                        ],
                                                                  ),
                                                            ),
                                                        new Column(children: [
                                                                     new Image.network(thumbnail,
                                                                                       scale: 2.0,
                                                                                       fit: BoxFit.cover,
                                                                                       alignment: FractionalOffset.centerLeft),

                                                                    ],
                                                            ),

                                                  ],
                                    ),
                        );
      containers.add(container);
    }
  }

  Widget build(BuildContext context) {
    Widget list = new ListView(
        children: containers,);

    return list;
  }
}

class MyHomePageState extends State<MyHomePage> {
  Future<http.Response> _response;

  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      var extension = "top";
      extension += ".json";
      var baseURL = "https://www.reddit.com/";
      _response = http.get(baseURL + extension);
    });
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.black,
        appBar: new AppBar(
            backgroundColor: Colors.black,
            title: new Text("Fluddit"),
            ),
        body: new Center(
            child: new FutureBuilder(
                future: _response,
                builder: (BuildContext context, AsyncSnapshot<http.Response> response) {
                  if (!response.hasData)
                    return new Text('Loading...');
                  else {
                    var data = JSON.decode(response.data.body);
                    var posts = data["data"]["children"];
                    return new RedditTable(posts);
                  }
                }
            )
        ),);
  }
}

