class Localisation {
  String? date;
  int? id;
  double? latitude;
  double? longitude;

  Localisation({this.date, this.id, this.latitude, this.longitude});

  Localisation.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    id = json['id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['id'] = this.id;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
