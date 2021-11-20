import 'package:flutter/material.dart';
import 'package:news_api_flutter_package/model/article.dart';
import 'package:news_api_flutter_package/model/error.dart';
import 'package:news_api_flutter_package/news_api_flutter_package.dart';
import '../config.dart';
import 'package:screenshot/screenshot.dart';

void main() {
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News API Demo',
      home: HomePage(),
    );
  }
}

// ignore: use_key_in_widget_constructors
class HomePage extends StatelessWidget {
  final NewsAPI _newsAPI = NewsAPI(API_KEY);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildTopHeadlinesTabView(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("News API Demo"),
    );
  }

  Widget _buildTopHeadlinesTabView() {
    return FutureBuilder<List<Article>>(
        future: _newsAPI.getTopHeadlines(country: "jp"),
        builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? snapshot.hasData
              ? _buildArticleListView(snapshot.data!)
              : _buildError(snapshot.error as ApiError)
              : _buildProgress();
        });
  }


  Widget _buildArticleListView(List<Article> articles) {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        Article article = articles[index];
        return Card(
          child: ListTile(
            title: Text(article.title!, maxLines: 2),
            subtitle: Text(article.description ?? "", maxLines: 3),
            trailing: article.urlToImage == null
                ? null
                : Image.network(article.urlToImage!),
          ),
        );
      },
    );
  }
  Widget _buildProgress() {
    // ignore: prefer_const_constructors
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildError(ApiError error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              error.code ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 4),
            Text(error.message!, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}