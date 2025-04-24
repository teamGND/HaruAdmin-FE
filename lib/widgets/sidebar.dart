import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haru_admin/router.dart';
import 'package:haru_admin/utils/secure_storage.dart';
import 'package:haru_admin/widgets/gaps.dart';

class SideBar extends StatefulWidget {
  const SideBar({
    super.key,
    required this.state,
    required this.child,
  });

  final GoRouterState state;
  final Widget child;

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  bool isFolded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: isFolded ? 60 : 250,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(isFolded ? 8 : 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                right: BorderSide(
                  color: Color(0xFF9C9C9C),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                // fold icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        isFolded
                            ? Icons.keyboard_double_arrow_right
                            : Icons.keyboard_double_arrow_left,
                        size: 20,
                        color: const Color(0xFF656565),
                      ),
                      onPressed: () {
                        setState(() {
                          isFolded = !isFolded; // Toggle fold state
                        });
                      },
                    ),
                  ],
                ),
                isFolded ? Gaps.v32 : Gaps.v10,
                Image.asset(
                  isFolded
                      ? 'assets/images/small_logo.png'
                      : 'assets/images/logo.png',
                  width: isFolded ? 40 : 100, // Smaller logo when folded
                ),
                Gaps.v40,
                ...sidebarRoutes.where((e) => e.isStudyMenu).map((sidebar) {
                  return SideBarTile(
                    icon: sidebar.icon,
                    label: sidebar.label,
                    routePath: sidebar.route.path,
                    isSelected: widget.state.fullPath == sidebar.route.path,
                    isFolded: isFolded,
                  );
                }).toList(),
                const Spacer(),
                ...sidebarRoutes.where((e) => !e.isStudyMenu).map((sidebar) {
                  return SideBarTile(
                    icon: sidebar.icon,
                    label: sidebar.label,
                    routePath: sidebar.route.path,
                    isSelected: widget.state.fullPath == sidebar.route.path,
                    isFolded: isFolded,
                  );
                }).toList(),
                SideBarTile(
                  icon: const Icon(Icons.logout),
                  label: 'Logout',
                  routePath: '/login',
                  isFolded: isFolded,
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

class SideBarTile extends StatelessWidget {
  const SideBarTile({
    super.key,
    required this.icon,
    required this.label,
    required this.routePath,
    this.isSelected = false,
    required this.isFolded,
  });

  final Widget icon;
  final String label;
  final String routePath;
  final bool isSelected;
  final bool isFolded;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.grey[300] : null,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        leading: icon,
        title: isFolded
            ? null // Hide label when folded
            : Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.black87 : Colors.black,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
        onTap: () {
          if (label == 'Logout') {
            SecureStorage().deleteAccessToken();
          }
          context.go(routePath);
        },
        contentPadding: EdgeInsets.symmetric(
          horizontal: isFolded ? 8 : 16, // Smaller padding when folded
        ),
        selected: isSelected,
        selectedColor: Colors.black87,
        hoverColor: Colors.grey[100],
        minLeadingWidth: isFolded ? 0 : 40,
      ),
    );
  }
}
