import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haru_admin/router.dart';
import 'package:haru_admin/widgets/gaps.dart';

class UpperArea extends StatelessWidget {
  const UpperArea({super.key, required this.state});

  final GoRouterState state;

  SidebarModel getCurrentPage() {
    return sidebarRoutes.firstWhere(
      (e) => e.route.path == state.fullPath,
      orElse: () =>
          sidebarChildRoutes.firstWhere((e) => e.route.path == state.fullPath),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  getCurrentPage().icon,
                  Gaps.h8,
                  Text(
                    getCurrentPage().label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              Gaps.v8,
              Text(
                getCurrentPage().route.name ?? '',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // search bar
            ],
          ),
          // const TitleSearchBar(),
        ],
      ),
    );
  }
}

class TitleSearchBar extends StatelessWidget {
  const TitleSearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 200,
      ),
      child: TextField(
        decoration: InputDecoration(
          label: const Icon(
            Icons.search,
            color: Color(0xFF9C9C9C),
          ),
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          hintText: 'Search',
          hintStyle: const TextStyle(
            color: Color(0xFF9C9C9C),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF9C9C9C),
              // color: Color(0xFFD9D9D9),
              width: 1,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        onChanged: (value) {
          // Handle search input
        },
      ),
    );
  }
}
