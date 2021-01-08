import '../enums/enums.dart';
import 'multi_selection_model.dart';
import 'option_model.dart';

class SwitchContent {
  SwitchType switchType;
  RenderType renderType;
  MultiSelection multiSelection;
  bool selected;
  Layout layout;
  List<Option> options;

  SwitchContent(
      {this.switchType,
        this.renderType,
        this.multiSelection,
        this.selected: false,
        this.layout,
        this.options});

  SwitchContent.fromJson(Map<String, dynamic> json) {
    switchType = switchTypeValues.map[json["switchType"]];
    renderType = renderTypeValues.map[json["renderType"]];
    multiSelection = json['multiSelection'] != null
        ? new MultiSelection.fromJson(json['multiSelection'])
        : null;
    layout = layoutValues.map[json["layout"]];
    if (json['options'] != null) {
      options = new List<Option>.empty(growable: true);
      json['options'].forEach((v) {
        options.add(new Option.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['switchType'] = switchTypeValues.reverse[this.switchType];
    data['renderType'] = renderTypeValues.reverse[this.renderType];
    data['multiSelection'] = this.multiSelection.toJson();
    data['layout'] = layoutValues.reverse[this.layout];
    if (this.options != null) {
      data['options'] = this.options.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
