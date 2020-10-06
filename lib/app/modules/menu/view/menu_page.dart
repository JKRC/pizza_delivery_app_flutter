import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:pizza_delivery/app/models/menu_item_model.dart';
import 'package:pizza_delivery/app/models/menu_model.dart';
import 'package:pizza_delivery/app/modules/menu/controllers/menu_controller.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildMenu(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.none,
                    image: AssetImage(
                      'assets/images/topoCardapio.png',
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  height: 200,
                  child: Image.asset('assets/images/logo.png'),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildMenu(BuildContext context) {
    return Consumer<MenuController>(
      builder: (_, controller, __) {
        if (controller.loading) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!isNull(controller.error)) {
          return Text(controller.error);
        }

        final menu = controller.menu;
        return Column(
          children: menu.map<Widget>((MenuModel groupItems) {
            return _buildGroup(context, groupItems.name, groupItems.items);
          }).toList(),
        );
      },
    );
  }

  Widget _buildGroup(
      BuildContext context, String name, List<MenuItemModel> items) {
    var formaterPrice = NumberFormat('###.00', 'pt_br');
    return Column(
      children: [
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          child: Text(
            name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Divider(),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final menuItem = items[index];
            return ListTile(
              title: Text(
                menuItem.name,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text('R\$ ${formaterPrice.format(menuItem.price)}'),
              trailing: IconButton(
                icon: Icon(
                  FontAwesome.plus_square,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
