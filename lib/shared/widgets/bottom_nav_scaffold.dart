import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BottomNavScaffold extends StatelessWidget {
  const BottomNavScaffold({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(PhosphorIconsBold.house),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIconsBold.arrowsLeftRight),
            label: 'Pay',
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIconsBold.sparkle),
            label: 'Pia',
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIconsBold.clockCounterClockwise),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIconsBold.dotsThreeOutline),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
