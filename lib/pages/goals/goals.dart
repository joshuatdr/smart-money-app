import 'package:flutter/material.dart';
import 'package:smart_money_app/model/goals.dart';
import 'package:smart_money_app/pages/goals/add_goal.dart';
import 'package:smart_money_app/pages/goals/edit_goal.dart';
import 'package:smart_money_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:smart_money_app/services/api.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:status_alert/status_alert.dart';

void showSuccessAlert(BuildContext context) {
  StatusAlert.show(
    context,
    duration: Duration(seconds: 2),
    title: 'Success',
    subtitle: 'Goal Deleted',
    configuration: IconConfiguration(icon: Icons.check),
    backgroundColor: Colors.lightBlue.shade600,
  );
}

// Method to show an error alert
void showErrorAlert(BuildContext context) {
  StatusAlert.show(
    context,
    duration: Duration(seconds: 2),
    title: 'Error',
    subtitle: 'Something went wrong!',
    configuration: IconConfiguration(icon: Icons.error),
  );
}

class GoalsPage extends StatefulWidget {
  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  final _key = GlobalKey<ExpandableFabState>();
  var editMode = false;
  late var isFocused = context.watch<UserProvider>().focusGoal;
  var data = {};


  setEditMode() {
    setState(() {
      editMode = !editMode;
    });
  }

  setIsFocused(goalID) {
   // if (goalID) {
      setState(() {
        isFocused = goalID;
      });
  }

  Future<void> _edit(data, userId) async {
    print(data);
    print(userId);

    var res = await UserServices().patchUser(data, userId);
    print(res.body);
  }


  Future<void> deleteGoal(int goalId, int userId) async {
    var res = await UserServices().deleteUserGoal('$userId/goals/$goalId');

    if (res.statusCode == 204) {
      if (!mounted) return;
      showSuccessAlert(context);
    } else {
      if (!mounted) return;
      showErrorAlert(context);
    }
  }

  Future promptDeleteGoal(context, data, userId) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: Center(
            child: Text(
              'Delete Goal',
              style: TextStyle(
                  color: Colors.lightBlue.shade600,
                  fontWeight: FontWeight.w800,
                  fontSize: 20),
            ),
          ),
          content: SizedBox(
            child: Column(
              children: [
                Text(
                  data.name,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: const Text('Do you want to delete this goal?'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              TextButton(
                child: const Text(
                  'Cancel',
                  textAlign: TextAlign.left,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await deleteGoal(data.goalID, userId);
                  setState(() {});
                },
              ),
            ]),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade900,
        title: Text("Goals", style: TextStyle(color: Colors.white)),
      ),
      body: _renderGoals(context, style),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: _renderFloatingActionButton(context),
    );
  }

  ExpandableFab _renderFloatingActionButton(context) {
    return ExpandableFab(
      key: _key,
      type: ExpandableFabType.up,
      childrenAnimation: ExpandableFabAnimation.none,
      distance: 70,
      childrenOffset: Offset(8, 16),
      openButtonBuilder: DefaultFloatingActionButtonBuilder(
        backgroundColor: Colors.blue.shade600,
        child: const Icon(Icons.menu, color: Colors.white),
      ),
      closeButtonBuilder: DefaultFloatingActionButtonBuilder(
        backgroundColor: Colors.blue.shade800,
        child: const Icon(Icons.close, color: Colors.white),
      ),
      overlayStyle: ExpandableFabOverlayStyle(
        color: Colors.white.withOpacity(0.6),
      ),
      children: [
        Row(
          children: [
            Text('Add Goal'),
            SizedBox(width: 20),
            FloatingActionButton.small(
              backgroundColor: Colors.blue.shade600,
              heroTag: null,
              child: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddGoalPage()),
                ).then((value) {
                  setState(() {});
                });
                final state = _key.currentState;
                // print(state);
                if (state != null) {
                  state.toggle();
                }
              },
            ),
          ],
        ),
        Row(
          children: [
            Text('Edit Goals'),
            SizedBox(width: 20),
            FloatingActionButton.small(
              backgroundColor: Colors.blue.shade600,
              heroTag: null,
              child: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                final state = _key.currentState;
                if (state != null) {
                  state.toggle();
                }
                setEditMode();
              },
            ),
          ],
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
              child: Image.asset('logo.png',
                  width: 200,
                  color: Colors.lightBlue.shade900.withOpacity(0.2)),
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
    var userId = context.watch<UserProvider>().userID;

    return Container(
      //constraints: BoxConstraints(minWidth: 0, maxWidth: 300, maxHeight: 600),
      //padding: EdgeInsets.all(0),
      width: 400,
      height: 400,
      decoration: _goalCardBody(results, index),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                width: 40,
                child: ElevatedButton(
                   onPressed: () async {
                      if (isFocused != results[index].goalID ){
                
print(isFocused);
setIsFocused(results[index].goalID);
context.read<UserProvider>().changeFocusGoal(newFocusGoal:isFocused);
 data['focus_goal'] = results[index].goalID;
 _edit(data, userId) ;

                      }
//print(context.watch<UserProvider>().changeFocusGoal);
// //context.read<UserProvider>().changeFocusGoal(newFocusGoal: isFocused)
// }).then(()=>{
//   data['focus_goal'] = results[index].goalID
// }).then(()=>{
// _edit(data, userId) 
// });
                     /* print(results[index].goalID);
                      if (results[index].goalID == isFocused) {
                        setIsFocused(0).then((value) {
                          setState(() {});
                        });
                      } else {
                        setIsFocused(results[index].goalID).then((value) {
                          setState(() {});
                        });
                      }*/
                    },

                   style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(0, 255, 255, 255)
                          .withOpacity(0.00),
                      padding: EdgeInsets.zero,
                    ),
                   
                    child: Icon(Icons.star,
                        color: (isFocused != results[index].goalID) ? Colors.white: const Color.fromARGB(255, 235, 205, 14))),
              ),
            ),

            if (editMode)
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: SizedBox(
                  width: 40,
                  child: ElevatedButton(
                      onPressed: () async {
                        await promptDeleteGoal(context, results[index], userId);
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade600,
                        padding: EdgeInsets.zero,
                      ),
                      child: Icon(Icons.close, color: Colors.white)
                      // child: const Text("Delete Goal"),
                      ),
                ),
              ),
          ]),
          SizedBox(
            height: 280,
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
                            const Color.fromARGB(160, 18, 18, 18),
                            Color.fromARGB(160, 54, 53, 53),
                          ]),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, top: 0, bottom: 0),
                          child: Text(results[index].name ??= "",
                              textAlign: TextAlign.center,
                              style: style.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(colors: [
                            const Color.fromARGB(160, 18, 18, 18),
                            Color.fromARGB(160, 54, 53, 53),
                          ]),
                        ),
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 0, bottom: 0),
                        child: Text(
                            '£${(results[index].cost ??= 0).toString()}',
                            textAlign: TextAlign.center,
                            style: style.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                  ),
                ],
              ),
            ),
          ),
          if (editMode)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                            builder: (context) => EditGoal(
                                name: results[index].name,
                                cost: results[index].cost,
                                imgUrl: results[index].imgURL,
                                desc: results[index].description,
                                goalId: results[index].goalID)),
                      )
                          .then((value) {
                        setState(() {});
                      });
                    },
                    child: const Text("Edit Goal"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilledButton.icon(
                    label: Text("Exit"),
                    icon: const Icon(Icons.edit_off_rounded),
                    iconAlignment: IconAlignment.start,
                    onPressed: () async {
                      await setEditMode();
                    },
                  ),
                ),
              ],
            ),
        ],
      ), //Column
    ); //Container
  }

  BoxDecoration _goalCardBody(List<Goals> results, int index) {
    return results[index].imgURL != ""
        ? BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.lightBlue.shade700,
              Colors.lightBlue.shade400,
            ]),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(results[index].imgURL ??= ""),
            ),
            borderRadius: BorderRadius.circular(20),
          )
        : BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.lightBlue.shade700,
              Colors.lightBlue.shade400,
            ]),
            borderRadius: BorderRadius.circular(20),
          );
  }
}
