import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/routing_url.dart';

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
            width: 250,
            color: Colors.black,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                for (var url in routingURL)
                  ListTile(
                    title: Text(
                      url['name'] as String,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      context.go(url['path'] as String);
                    },
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
