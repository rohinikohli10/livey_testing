import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:livey_testing/utils/colors.dart';
import 'package:livey_testing/utils/use_scaler.dart';

TextStyle headingStyle(BuildContext context) {
  final scaler = useScaler(context);
  return GoogleFonts.b612(
      fontWeight: FontWeight.w700, fontSize: scaler.scalerT(20));
}

TextStyle expandedHeadingStyle(BuildContext context) {
  final scaler = useScaler(context);
  return GoogleFonts.b612(
      color: ProjectColors.white,
      fontWeight: FontWeight.w700,
      fontSize: scaler.scalerT(50));
}

TextStyle widgetHeadingStyle(BuildContext context) {
  final scaler = useScaler(context);
  return GoogleFonts.b612(
      color: ProjectColors.black,
      fontWeight: FontWeight.w700,
      fontSize: scaler.scalerT(30));
}

Color randomColor() {
  return Colors.primaries[Random().nextInt(Colors.primaries.length)].shade200;
}

Color randomColor1() {
  return Colors.primaries[Random().nextInt(Colors.accents.length)];
}
