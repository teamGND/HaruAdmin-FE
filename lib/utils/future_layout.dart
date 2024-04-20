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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      margin: const EdgeInsets.all(20),
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          titleRow,
          const Divider(
            color: Colors.grey,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder(
                future: future,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return childRow(snapshot.data);
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Container(
                    width: 100,
                    height: 100,
                    padding: const EdgeInsets.all(30),
                    child: const CircularProgressIndicator(color: Colors.blue),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
