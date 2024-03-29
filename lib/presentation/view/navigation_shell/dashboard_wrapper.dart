import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardWrapper extends StatefulWidget {
  const DashboardWrapper({
    required StatefulNavigationShell navigationShell,
    super.key,
  }) : _navigationShell = navigationShell;

  final StatefulNavigationShell _navigationShell;

  @override
  State<DashboardWrapper> createState() => _DashboardWrapperState();
}

class _DashboardWrapperState extends State<DashboardWrapper> {
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NavigationRail(
          labelType: NavigationRailLabelType.all,
          leading: Image.asset(
            'lib/presentation/assets/logo-short.png',
            width: 50,
          ),
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.local_bar_rounded),
              label: Text('Clubs'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.directions_run_rounded),
              label: Text('Leaves'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.school_rounded),
              label: Text('Courses'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.feed_rounded),
              label: Text('Blogs'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.casino_rounded),
              label: Text('Cards'),
            ),
          ],
          onDestinationSelected: (index) {
            widget._navigationShell.goBranch(
              index,
              initialLocation: index == widget._navigationShell.currentIndex,
            );
            _selectedIndex = widget._navigationShell.currentIndex;
          },
          selectedIndex: _selectedIndex,
          trailing: IconButton(
            onPressed: () => context.goNamed('sign in'),
            icon: Icon(Icons.logout_rounded),
            tooltip: 'Log Out',
          ),
        ),
        Expanded(child: widget._navigationShell),
      ],
    );
  }
}
