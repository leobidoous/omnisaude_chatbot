class MultiSelection {
  bool enabled;
  int min;
  int max;

  MultiSelection({this.enabled: false, this.min, this.max});

  MultiSelection.fromJson(Map<String, dynamic> json) {
    enabled = json['enabled'];
    min = json['min'];
    max = json['max'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['enabled'] = this.enabled;
    data['min'] = this.min;
    data['max'] = this.max;
    return data;
  }
}
