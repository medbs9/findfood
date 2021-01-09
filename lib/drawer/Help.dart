import 'package:find_food/drawer/Acheter.dart';
import 'package:find_food/drawer/Vendre.dart';
import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  static String id = 'Help';
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            centerTitle: true,
            title: Text(
              'Comment ça marche',
              style: TextStyle(color: Colors.black),
            ),
            bottom: TabBar(
                unselectedLabelColor: Colors.blueAccent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.blueAccent, Colors.lightBlue[300]]),
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.blueAccent),
                tabs: [
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Vendre"),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Acheter"),
                    ),
                  ),
                ]),
          ),
          body: TabBarView(children: [
            Vendre(),
            Acheter(),
          ]),
        ));
  }
}
