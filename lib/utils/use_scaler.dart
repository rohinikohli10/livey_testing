import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:livey_testing/utils/scaler_config.dart';

double designWidth = 375;
double designHeight = 812;

ScalerConfig useScaler(BuildContext context) {
  final mediaQueryData = useRef<MediaQueryData>(MediaQuery.of(context));
  final screenWidth = useState<double>(mediaQueryData.value.size.width);
  final screenHeight = useState<double>(mediaQueryData.value.size.height);

  final ratioH = useCallback(() {
    return screenWidth.value / designWidth;
  }, []);

  final scalerH = useCallback((double size) {
    return ratioH() * size;
  }, []);

  final ratioV = useCallback(() {
    return screenHeight.value / designHeight;
  }, []);

  final scalerV = useCallback((double size) {
    return ratioV() * size;
  }, []);

  final scalerT = useCallback((double size) {
    return sqrt((pow(scalerV(size), 2) + pow(scalerH(size), 2)) / 2);
  }, []);

  return ScalerConfig(scalerH: scalerH, scalerT: scalerT, scalerV: scalerV);
}
