class Distance {
  double? distance;

  Distance({
    this.distance,
  });

  Distance.fromJson(Map<String, dynamic> json) {
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['distance'] = distance;
    return data;
  }
}
