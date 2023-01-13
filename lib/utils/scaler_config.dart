class ScalerConfig {
  double Function(double) scalerV;
  double Function(double) scalerH;
  double Function(double) scalerT;

  ScalerConfig(
      {required this.scalerV, required this.scalerH, required this.scalerT});
}
