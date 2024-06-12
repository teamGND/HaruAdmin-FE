import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haru_admin/router.dart';
import 'package:haru_admin/utils/secure_storage.dart';

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
  String? selectedURL;

  @override
  void initState() {
    super.initState();
    selectedURL = widget.state.fullPath;
  }

  Widget sideBarComponent(List<GoRoute> url) {
    return Column(children: [
      for (var index = 0; index < url.length; index++)
        ListTile(
          title: Text(
            url[index].name!,
            style: TextStyle(
              color:
                  selectedURL == url[index].path ? Colors.blue : Colors.black,
              fontSize: 14,
            ),
          ),
          onTap: () {
            setState(() {
              selectedURL = url[index].path;
            });
            context.go(url[index].path);
          },
        ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 250,
            height: MediaQuery.of(context).size.height,
            color: const Color(0xffF2F2F2),
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
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
                  sideBarComponent(sidebarRoutes['account']!),
                  const Divider(
                    thickness: 2,
                  ),
                  sideBarComponent(sidebarRoutes['data']!),
                  const Divider(
                    thickness: 2,
                  ),
                  sideBarComponent(sidebarRoutes['my']!),
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                    ),
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {
                      SecureStorage().deleteAccessToken();
                      context.go('/login');
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
