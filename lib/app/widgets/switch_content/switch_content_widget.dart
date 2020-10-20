import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:omnisaude_chatbot/app/connection/connection.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';
import 'package:omnisaude_chatbot/app/widgets/avatar/avatar_widget.dart';

class SwitchContentWidget extends StatefulWidget {
  final Connection connection;
  final WsMessage message;
  final Color color;

  const SwitchContentWidget(
      {Key key,
      @required this.message,
      @required this.color,
      @required this.connection})
      : super(key: key);

  @override
  _SwitchContentWidgetState createState() => _SwitchContentWidgetState();
}

class _SwitchContentWidgetState extends State<SwitchContentWidget> {
  @override
  Widget build(BuildContext context) {
    final Layout _layout = widget.message.switchContent.layout;
    final RenderType _renderType = widget.message.switchContent.renderType;
    final SwitchType _switchType = widget.message.switchContent.switchType;
    final bool _multiSelection = widget.message.switchContent.multiSelection;
    final List<Option> _options = widget.message.switchContent.options;

    switch (_renderType) {
      case RenderType.LIST:
        switch (_switchType) {
          case SwitchType.HORIZONTAL:
            return _gridContent(
              Axis.horizontal,
              _layout,
              _multiSelection,
              _options,
            );
          case SwitchType.SLIDE:
            return _slideContent();
          case SwitchType.VERTICAL:
            return _gridContent(
              Axis.vertical,
              _layout,
              _multiSelection,
              _options,
            );
        }
        break;
      case RenderType.SEARCH:
        return _searchContent();
    }
    return Container();
  }

  Widget _gridContent(Axis direction, Layout layout, bool multiSelection,
      List<Option> options) {
    double _maxHeight = 100.0;
    switch (layout) {
      case Layout.AVATAR_CARD:
        _maxHeight = 200.0;
        break;
      case Layout.BUTTON:
        _maxHeight = 75.0;
        break;
      case Layout.CARD:
        _maxHeight = 200.0;
        break;
      case Layout.IMAGE_CARD:
        _maxHeight = 200.0;
        break;
    }

    return Container(
      constraints: BoxConstraints(maxHeight: _maxHeight),
      color: Colors.red,
      child: new StaggeredGridView.countBuilder(
        crossAxisCount: 1,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
        itemCount: options.length,
        scrollDirection: direction,
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.all(5.0),
        staggeredTileBuilder: (int index) => const StaggeredTile.count(1, 3),
        itemBuilder: (BuildContext context, int index) {
          return _chooseSelectionType(layout, multiSelection, options[index]);
        },
      ),
    );
  }

  Widget _slideContent() {
    return Container();
  }

  Widget _searchContent() {
    return Container();
  }

  Widget _chooseSelectionType(
    Layout layout,
    bool multiSelection,
    Option option,
  ) {
    switch (layout) {
      case Layout.AVATAR_CARD:
        return _avatarCardContent(option);
      case Layout.BUTTON:
        return _buttonContent(option);
      case Layout.CARD:
        return _cardContent(option);
      case Layout.IMAGE_CARD:
        return _imageCardContent(option);
    }
    return Container();
  }

  Widget _buttonContent(Option option) {
    return FlatButton(
      onPressed: () => _onSendOptionsMessage([option.id]),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.all(5.0),
        child: Text(
          "${option.title}",
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          maxLines: 3,
        ),
      ),
    );
  }

  Widget _cardContent(Option option) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("title"),
          Text("subtitle"),
        ],
      ),
    );
  }

  Widget _avatarCardContent(Option option) {
    return Container(
      child: Row(
        children: [
          AvatarWidget(
            width: 30.0,
            height: 30.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("title"),
                Text("subtitle"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageCardContent(Option option) {
    return FlatButton(
      onPressed: () => _onSendOptionsMessage([option.id]),
      child: Container(
        constraints: BoxConstraints(maxWidth: 100.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: AvatarWidget(url: option.image, width: 100.0,)),
            Text("${option.title}"),
            Text("${option.subtitle}"),
          ],
        ),
      ),
    );
  }

  Future<void> _onSendOptionsMessage(List<String> options) async {
    try {
      final MessageContent _messageContent = MessageContent(extras: {
        "options": options,
      });
      final WsMessage _message = WsMessage(messageContent: _messageContent);
      await widget.connection.onSendMessage(_message);
    } catch (e) {
      print("erro ao enviar uma option message: $e");
    }
  }
}
