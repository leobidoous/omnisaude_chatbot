import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'attendant_controller.dart';

class AttendantPage extends StatefulWidget {
  final String title;

  const AttendantPage({Key key, this.title = "Attendant"}) : super(key: key);

  @override
  _AttendantPageState createState() => _AttendantPageState();
}

class _AttendantPageState
    extends ModularState<AttendantPage, AttendantController> {
  @override
  void initState() {
    controller.onInitAndListenStream("");
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(height: 100.0, color: Colors.red, margin: EdgeInsets.only(bottom: 10.0),);
              },
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: ListView.builder(
                  physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  reverse: true,
                  itemCount: 10,
                  controller: controller.scrollController,
                  padding: EdgeInsets.all(5.0),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(height: 100.0, color: Colors.red, margin: EdgeInsets.only(bottom: 10.0),);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
