import 'package:flutter/material.dart';


@immutable
class Tile extends StatelessWidget {
  final int number;

  final double width =55;
 final double height =55;

  Tile(this.number, width, height);

Color colorForNumber() {
    switch (number) {
      case 2:
        return Colors.purple.shade50;
      case 4:
        return Colors.purple.shade100;
      case 8:
        return Colors.purple.shade200;
      case 16:
        return Colors.purple.shade300;
      case 32:
        return Colors.purple.shade400;
      case 64:
        return Colors.purple.shade500;
      case 128:
        return Colors.purple.shade600;
      case 256:
        return Colors.purple.shade700;
      case 512:
        return Colors.purple.shade800;
      case 1024:
        return Colors.purple.shade900;
    }
    return Colors.transparent;
  }

  String numberToString() {
    return number == 0 ? "" : "$number";
  }


  @override
  Widget build(BuildContext context) {

    return Container(
      child: Center(
        child: Text(
          numberToString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            shadows: [
              Shadow(
                blurRadius: 7.0,
                color: Colors.white,
                offset: Offset(0, 0),
              ),
            ],

          ),
        ),
      ),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colorForNumber(),
        borderRadius: BorderRadius.circular(6.0),
      ),
    );
  }
}

