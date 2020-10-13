import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:omnisaude_chatbot/app/core/constants/constants.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';
import 'package:omnisaude_chatbot/app/widgets/panel_send_message/panel_send_message_controller.dart';

class PanelSendMessageWidget extends StatefulWidget {
  final WsMessage message;
  final Future<void> Function(WsMessage) onSendMessage;

  const PanelSendMessageWidget(
      {Key key, @required this.message, @required this.onSendMessage})
      : super(key: key);

  @override
  _PanelSendMessageWidgetState createState() => _PanelSendMessageWidgetState();
}

class _PanelSendMessageWidgetState extends State<PanelSendMessageWidget> {
  final PanelSendMessageController _controller = PanelSendMessageController();
  final TextEditingController _messageText = TextEditingController();
  final FocusNode _messageFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _messageFocus.dispose();
    _messageText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WsMessage _message = widget.message;
    TextInputType textInputType = TextInputType.text;
    List<MaskTextInputFormatter> textInputMask;
    Map<String, RegExp> _filter;
    _controller.inputEnabled = false;

    if (_message.inputContent != null) {
      switch (_message.inputContent.keyboardType) {
        case KeyboardType.DATE:
          textInputType = TextInputType.datetime;
          break;
        case KeyboardType.EMAIL:
          _controller.inputEnabled = true;
          _messageFocus.requestFocus();
          textInputType = TextInputType.emailAddress;
          break;
        case KeyboardType.NUMBER:
          _controller.inputEnabled = true;
          _messageFocus.requestFocus();
          textInputType = TextInputType.number;
          break;
        case KeyboardType.TEXT:
          _controller.inputEnabled = true;
          _messageFocus.requestFocus();
          textInputType = TextInputType.text;
          break;
        default:
          _controller.inputEnabled = true;
          _messageFocus.requestFocus();
          textInputType = TextInputType.text;
          break;
      }
      if (_message.inputContent.mask != null) {
        switch (_message.inputContent.keyboardType) {
          case KeyboardType.NUMBER:
            _filter = filterNUMBERS;
            break;
          case KeyboardType.TEXT:
            _filter = filterLETTERS;
            break;
          default:
            _filter = null;
            break;
        }
        textInputMask = List<MaskTextInputFormatter>()
          ..add(
            MaskTextInputFormatter(
              mask: _message.inputContent.mask,
              filter: _filter,
            ),
          );
      }
    }

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.grey.shade300),
            padding: const EdgeInsets.all(10.0),
            child: Observer(
              builder: (BuildContext context) {
                return Opacity(
                  opacity: _controller.inputEnabled ? 1.0 : 0.4,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CupertinoTextField(
                        maxLines: 5,
                        minLines: 1,
                        autocorrect: true,
                        focusNode: _messageFocus,
                        controller: _messageText,
                        keyboardType: textInputType,
                        inputFormatters: textInputMask,
                        enabled: _controller.inputEnabled,
                        textInputAction: TextInputAction.send,
                        textCapitalization: TextCapitalization.sentences,
                        padding: EdgeInsets.fromLTRB(10.0, 10.0, 40.0, 10.0),
                        placeholder: "Digite sua mensagem aqui",
                        onSubmitted: (String input) async =>
                            await _onSendMessage(
                          input,
                        ),
                      ),
                      IgnorePointer(
                        ignoring: !_controller.inputEnabled,
                        child: IconButton(
                          onPressed: () async => await _onSendMessage(
                            _messageText.text,
                          ),
                          icon: const Icon(Icons.send_rounded),
                          padding: EdgeInsets.zero,
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          visualDensity: VisualDensity.compact,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSendMessage(String message) async {
    if (message.trim().isEmpty) return;
    WsMessage _message = WsMessage(
      messageContent: MessageContent(
        value: message.trim(),
      ),
    );
    widget.onSendMessage(_message).whenComplete(() {
      _messageText.clear();
    });
  }
}
