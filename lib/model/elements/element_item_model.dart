class ElementItemModel {
  String key;
  String label;
  String? segmentType;

  ElementItemModel({
    required this.key,
    required this.label,
    this.segmentType,
  });

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'label': label,
      'SegmentType': segmentType,
    };
  }

  factory ElementItemModel.fromJson(Map<String, dynamic> json) {
    return ElementItemModel(
      key: json['key'] is int ? json['key'].toString() : json['key'],
      label: json['label'],
      segmentType: json['SegmentType'],
    );
  }
}
