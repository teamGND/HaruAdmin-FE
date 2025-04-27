import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haru_admin/widgets/gaps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentPageProvider = StateProvider<int>((ref) => 0);

class PaginationController extends ConsumerWidget {
  const PaginationController({
    required this.totalPages,
    required this.goToPage,
    super.key,
  });

  final int totalPages;
  final Future<void> Function(int page) goToPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the current page number from the provider
    final currentPageNumber = ref.watch(currentPageProvider);

    return SizedBox(
      width: 300,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (currentPageNumber != 0) {
                // Update the page number and call goToPage
                ref.read(currentPageProvider.notifier).state =
                    currentPageNumber - 1;
                goToPage(currentPageNumber - 1);
              }
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: currentPageNumber != 0
                  ? const Color(0xFF585858)
                  : const Color(0xFFCDCDCD),
            ),
          ),
          Gaps.h10,
          currentPageNumber == 0
              ? const SizedBox(width: 50)
              : SizedBox(
                  width: 50,
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        ref.read(currentPageProvider.notifier).state = 0;
                        goToPage(0);
                      },
                      child: const Text(
                        '1',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF585858),
                        ),
                      ),
                    ),
                  ),
                ),
          Gaps.h20,
          GestureDetector(
            onTap: () {
              goToPage(currentPageNumber);
            },
            child: Container(
              width: 35,
              height: 35,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  (currentPageNumber + 1).toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Gaps.h20,
          currentPageNumber == totalPages - 1
              ? const SizedBox(width: 50)
              : SizedBox(
                  width: 50,
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        if (currentPageNumber + 1 != totalPages) {
                          ref.read(currentPageProvider.notifier).state =
                              totalPages - 1;
                          goToPage(totalPages - 1);
                        }
                      },
                      child: Text(
                        totalPages.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF585858),
                        ),
                      ),
                    ),
                  ),
                ),
          Gaps.h10,
          IconButton(
            onPressed: () {
              if (currentPageNumber + 1 < totalPages) {
                ref.read(currentPageProvider.notifier).state =
                    currentPageNumber + 1;
                goToPage(currentPageNumber + 1);
              }
            },
            icon: Icon(
              Icons.arrow_forward_ios,
              color: currentPageNumber + 1 < totalPages
                  ? const Color(0xFF585858)
                  : const Color(0xFFCDCDCD),
            ),
          ),
        ],
      ),
    );
  }
}
