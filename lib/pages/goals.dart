import 'package:flutter/material.dart';
import 'package:smart_money_app/model/goals.dart';
import 'package:smart_money_app/pages/add_goal_page.dart';
import 'package:smart_money_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:smart_money_app/services/api.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class GoalsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.orange,
        title: Text("Goals", style: TextStyle(color: Colors.white)),
      ),
      body: _renderGoals(context, style),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: _renderFloatingActionButton(context),
    );
  }

  ExpandableFab _renderFloatingActionButton(context) {
    return ExpandableFab(
      openButtonBuilder: DefaultFloatingActionButtonBuilder(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.menu),
      ),
      closeButtonBuilder: DefaultFloatingActionButtonBuilder(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.close),
      ),
      overlayStyle: ExpandableFabOverlayStyle(
        color: Colors.white.withOpacity(0.4),
      ),
      children: [
        FloatingActionButton.small(
          backgroundColor: Colors.orange,
          heroTag: null,
          child: const Icon(Icons.edit),
          onPressed: () {},
        ),
        FloatingActionButton.small(
          backgroundColor: Colors.orange,
          heroTag: null,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddGoalPage()),
            );
          },
        ),
        FloatingActionButton.small(
          backgroundColor: Colors.orange,
          heroTag: null,
          child: const Icon(Icons.remove),
          onPressed: () {},
        ),
      ],
    );
  }

  FutureBuilder<Object?> _renderGoals(BuildContext context, TextStyle style) {
    return FutureBuilder(
      future:
          UserServices().getAllUserGoals(context.watch<UserProvider>().userID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var results = snapshot.data as List<Goals>;
          if (results.length >= 2) {
            return Center(
              child: Swiper(
                itemWidth: 400,
                itemHeight: 400,
                loop: true,
                duration: 300,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return _goalCard(results, index, style);
                },
                itemCount: results.length,
                layout: SwiperLayout.STACK,
              ),
            );
          } else if (results.isNotEmpty) {
            return Center(
              child: _goalCard(results, 0, style),
            );
          } else {
            return Center(
              child: Text("You haven't added any goals yet!"),
            );
          }
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  // ignore: sort_child_properties_last
                  child: CircularProgressIndicator(),
                  width: 30,
                  height: 30,
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Container _goalCard(List<Goals> results, int index, TextStyle style) {
    return Container(
        width: 400,
        height: 400,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.orange,
            Colors.orange.shade800,
          ]),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(results[index].imgURL ??= ""),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(colors: [
                        Colors.orange,
                        const Color.fromARGB(131, 224, 18, 18),
                      ]),
                    ),
                    child: Text(results[index].name ??= "",
                        textAlign: TextAlign.center,
                        style: style.copyWith(fontWeight: FontWeight.bold))),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(colors: [
                        Colors.orange,
                        const Color.fromARGB(131, 224, 18, 18),
                      ]),
                    ),
                    child: Text('£${(results[index].cost ??= 0).toString()}',
                        textAlign: TextAlign.center,
                        style: style.copyWith(fontWeight: FontWeight.bold))),
              ),
            ],
          ),
        ));
  }
}
