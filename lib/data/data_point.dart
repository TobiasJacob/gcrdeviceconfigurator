class DataPoint {
  final double x;
  final double y;

  DataPoint(this.x, this.y);

  Map<String, dynamic> toJSON() {
    return {"x": x, "y": y};
  }

  static DataPoint fromJSON(Map<String, dynamic> e) {
    return DataPoint(e["x"], e["y"]);
  }
}
