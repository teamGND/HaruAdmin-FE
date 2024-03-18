import 'package:flutter/material.dart';

class DefaultFutureBuilder extends StatelessWidget {
  const DefaultFutureBuilder({
    Key? key,
    required this.future,
    required this.titleRow,
    required this.childRow,
    this.height = 200,
  }) : super(key: key);

  final Future<dynamic> future;
  final Widget titleRow;
  final Widget Function(dynamic) childRow;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        titleRow,
        const Divider(),
        SizedBox(
          height: height,
          child: SingleChildScrollView(
            child: FutureBuilder(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return childRow(snapshot.data[index]);
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return const Center(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(color: Colors.blue),
                  ),
                );
              },
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
