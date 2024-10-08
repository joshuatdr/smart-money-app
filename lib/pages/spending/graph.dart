import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class SpendingPage extends StatefulWidget {
  const SpendingPage({super.key});

  @override
  State<SpendingPage> createState() => _SpendingPageState();
}

class _SpendingPageState extends State<SpendingPage> {
  final _key = GlobalKey<ExpandableFabState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Placeholder(),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: _renderFloatingActionButton(context),
    );
  }

  ExpandableFab _renderFloatingActionButton(BuildContext context) {
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
            Text('Add Purchase'),
            SizedBox(width: 20),
            FloatingActionButton.small(
              backgroundColor: Colors.blue.shade600,
              heroTag: null,
              onPressed: () {
                Navigator.pushNamed(context, '/addtransaction').then(
                  (value) {
                    setState(() {});
                  },
                );
                final state = _key.currentState;
                if (state != null) {
                  state.toggle();
                }
              },
              child: Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
        Row(
          children: [
            Text('View History'),
            SizedBox(width: 20),
            FloatingActionButton.small(
              backgroundColor: Colors.blue.shade600,
              heroTag: null,
              onPressed: () {
                Navigator.pop(context);
                final state = _key.currentState;
                if (state != null) {
                  state.toggle();
                }
              },
              child: Icon(Icons.receipt_long, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
