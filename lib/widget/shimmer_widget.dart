import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.separated(
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Colors.grey[300],
            ),
            margin: const EdgeInsets.only(top: 20),
            height: 100,
            width: double.infinity,
          );
        },
        itemCount: 5,
        shrinkWrap: true,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
      ),
    );
  }

}