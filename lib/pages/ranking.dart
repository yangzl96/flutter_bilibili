import 'package:flutter/material.dart';

class RankingPage extends StatefulWidget {
  RankingPage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<RankingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Text('排行'),
      ),
    );
  }
}
