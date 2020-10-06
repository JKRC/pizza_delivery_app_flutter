import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pizza_delivery/app/modules/home/controllers/home_controller.dart';
import 'package:pizza_delivery/app/modules/menu/controllers/menu_controller.dart';
import 'package:pizza_delivery/app/modules/menu/view/menu_page.dart';
import 'package:pizza_delivery/app/modules/splash/view/splash_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  static const router = '/home';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeController(),
      child: HomeContent(),
    );
  }
}

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>
    with SingleTickerProviderStateMixin {
  HomeController controller;
  @override
  void initState() {
    super.initState();
    controller = context.read<HomeController>();
    controller.tabController = TabController(vsync: this, length: 4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Theme.of(context).primaryColor,
        buttonBackgroundColor: Colors.white,
        items: [
          Image.asset(
            'assets/images/logo.png',
            width: 30,
          ),
          Icon(FontAwesome.list),
          Icon(Icons.shopping_cart),
          Icon(Icons.menu),
        ],
        onTap: (index) {
          controller.tabController.animateTo(index);
        },
      ),
      body: SafeArea(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => MenuController()..findMenu(),
            )
          ],
          child: TabBarView(
            controller: controller.tabController,
            children: [
              MenuPage(),
              Container(),
              Container(),
              FlatButton(
                onPressed: () async {
                  final sp = await SharedPreferences.getInstance();
                  sp.clear();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      SplashPage.router, (route) => false);
                },
                child: Text('Sair', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
