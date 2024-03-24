import 'package:flutter/material.dart';
import 'package:haru_admin/widgets/data_search_area.dart';

class ChapterCatalogTable extends StatelessWidget {
  const ChapterCatalogTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RequiredInfoName('레벨'),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  )),
              InfoName('사이클'),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  )),
            ],
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RequiredInfoName(
                  '타이틀',
                ),
                const textformfield(),
                InfoName('회차'),
                const textformfield(),
              ],
            )),
      ],
    );
  }
}
