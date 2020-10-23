import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:omnisaude_chatbot/app/connection/connection.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';
import 'package:omnisaude_chatbot/app/shared_widgets/avatar/avatar_widget.dart';

class SwitchContentWidget extends StatefulWidget {
  final Connection connection;
  final WsMessage message;
  final Color color;

  const SwitchContentWidget(
      {Key key,
      @required this.color,
      @required this.message,
      @required this.connection})
      : super(key: key);

  @override
  _SwitchContentWidgetState createState() => _SwitchContentWidgetState();
}

class _SwitchContentWidgetState extends State<SwitchContentWidget> {
  final CarouselController _carouselController = CarouselController();

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
            // break;
            return _gridContent(
              Axis.horizontal,
              _layout,
              _multiSelection,
              _options,
            );
          case SwitchType.SLIDE:
            // break;
            return _slideContent(_layout, _multiSelection, _options);
          case SwitchType.VERTICAL:
            // break;
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

  Widget _slideContent(
      Layout layout, bool multiSelection, List<Option> options) {
    final CarouselSlider _carouselSlider = CarouselSlider.builder(
      itemCount: options.length,
      options: CarouselOptions(
        aspectRatio: 1.0,
        viewportFraction: 0.7,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        scrollPhysics: BouncingScrollPhysics(),
      ),
      carouselController: _carouselController,
      itemBuilder: (context, index) {
        return _chooseSelectionType(layout, multiSelection, options[index]);
      },
    );
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor,
          ),
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              _carouselController.previousPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.decelerate,
              );
            },
            color: Colors.white,
          ),
        ),
        SizedBox(width: 5.0),
        Expanded(child: _carouselSlider),
        SizedBox(width: 5.0),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor,
          ),
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: IconButton(
            icon: Icon(Icons.arrow_forward_ios_rounded),
            onPressed: () {
              _carouselController.nextPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.decelerate,
              );
            },
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _searchContent() {
    return Container();
  }

  Widget _chooseSelectionType(
      Layout layout, bool multiSelection, Option option) {
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
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: FlatButton(
                color: Theme.of(context).textTheme.headline4.color,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                onPressed: () => _onSendOptionsMessage([option.id]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: IgnorePointer(
                                  ignoring: true,
                                  child: AvatarWidget(
                                    url: option.image + "",
                                    boxFit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 0.0,
                            right: 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .color
                                    .withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              margin: EdgeInsets.all(2.5),
                              child: IconButton(
                                onPressed: () => _onViewOptionDetails(option),
                                icon: Icon(Icons.info_outline_rounded),
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "${option.title}",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "${option.subtitle}",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                    SizedBox(height: 5.0),
                  ],
                ),
              ),
            ),
          ),
        ],
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

  Future<void> _onViewOptionDetails(Option option) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(20.0),
          child: Scaffold(
            body: SafeArea(
              child: Container(
                color: Colors.red,
              ),
            ),
          ),
        );
      },
    );
  }
}
