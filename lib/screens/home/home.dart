import 'package:flutter/material.dart';
import 'package:library_app/screens/create/create_score.dart';
import 'package:library_app/screens/home/button_card.dart';
import 'package:library_app/screens/search/search.dart';
import 'package:library_app/shared/appbar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppBar(title: '34ID Band Library'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ButtonCard(
                title: "Add",
                icon: Icon(Icons.add, size: 36),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => const CreateScore()),
                  );
                },
              ),
              ButtonCard(
                title: "Search",
                icon: Icon(Icons.search, size: 36),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => const Search()),
                  );
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ButtonCard(
                title: "Checkout",
                icon: Icon(Icons.shopping_basket_outlined, size: 36),
                onPressed: () {},
              ),
              ButtonCard(
                title: "Return",
                icon: Icon(Icons.assignment_return_outlined, size: 36),
                onPressed: () {},
              ),
            ],
          ),
          Expanded(child: SizedBox()),
          Image.asset(
            'assets/img/cute_redbull.png',
            height: height * 0.25,
            alignment: Alignment.bottomRight,
          ),
        ],
      ),
    );
  }
}
