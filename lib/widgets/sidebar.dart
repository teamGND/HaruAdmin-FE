import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/routing_url.dart';

class SideBar extends StatefulWidget {
  const SideBar({
    Key? key,
    required this.state,
    required this.child,
    // required this.sidebar,
  }) : super(key: key);

  final GoRouterState state;
  final Widget child;
  // final bool sidebar; // 사이드바 있없 여부

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  int selectedIndex = 0; // Initially, no item is selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 250,
            color: const Color(0xffF2F2F2),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  "HaruHangeul\nAdmin Page",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                for (var index = 0; index < routingURL.length; index++)
                  ListTile(
                    title: Text(
                      routingURL[index].getName,
                      style: TextStyle(
                        color:
                            selectedIndex == index ? Colors.blue : Colors.black,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                      context.go(routingURL[index].getPath);
                    },
                  ),
              ],
            ),
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
