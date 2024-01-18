import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key, required this.state, required this.child});

  final GoRouterState state;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 300.0,
            color: Colors.black,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ListTile(
                  onTap: () => context.go('/login'),
                  title: const Text('LOGIN',
                      style: TextStyle(color: Colors.white)),
                ),
                ListTile(
                  onTap: () => context.go('/signup'),
                  title: const Text('SIGNUP',
                      style: TextStyle(color: Colors.white)),
                ),
                ListTile(
                  onTap: () => context.go('/home'),
                  title:
                      const Text('HOME', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
