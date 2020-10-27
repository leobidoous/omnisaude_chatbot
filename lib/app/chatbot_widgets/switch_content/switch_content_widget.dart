import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:omnisaude_chatbot/app/chatbot_widgets/switch_content/switch_content_controller.dart';
import 'package:omnisaude_chatbot/app/components/components.dart';
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
  final SwitchContentController _controller = SwitchContentController();
  final CarouselController _carouselController = CarouselController();
  final TextEditingController _messageText = TextEditingController();
  final FocusNode _messageFocus = FocusNode();

  @override
  void dispose() {
    _messageText.dispose();
    _messageFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Layout _layout = widget.message.switchContent.layout;
    final RenderType _renderType = widget.message.switchContent.renderType;
    final SwitchType _switchType = widget.message.switchContent.switchType;
    final MultiSelection _multiSelection =
        widget.message.switchContent.multiSelection;
    final List<Option> _options = widget.message.switchContent.options;

    Widget _widget = Container();

    switch (_renderType) {
      case RenderType.LIST:
        switch (_switchType) {
          case SwitchType.HORIZONTAL:
            _widget = _gridContent(
              Axis.horizontal,
              _layout,
              _options,
              _multiSelection,
            );
            break;
          case SwitchType.SLIDE:
            _widget = _slideContent(_layout, _options, _multiSelection);
            break;
          case SwitchType.VERTICAL:
            _widget = _gridContent(
              Axis.vertical,
              _layout,
              _options,
              _multiSelection,
            );
            break;
        }
        break;
      case RenderType.SEARCH:
        _widget = _searchContent(_layout, _options, _multiSelection);
    }
    return _globalWidgetContent(_widget, _multiSelection);
  }

  Widget _globalWidgetContent(Widget widget, MultiSelection multi) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(child: widget),
        Container(
          color: Theme.of(context).textTheme.headline5.color,
          child: _btnSendMultiplesOptions(multi),
        ),
      ],
    );
  }

  Widget _btnSendMultiplesOptions(MultiSelection multiSelection) {
    return Observer(
      builder: (context) {
        final bool _enabled = _controller.optionsSelecteds.isNotEmpty;
        if (!multiSelection.enabled) return Container();
        return Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FlatButton(
                onPressed: _enabled
                    ? () => _controller.onSendOptionsMessage(widget.connection)
                    : null,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                textColor: _enabled ? Colors.white : null,
                color: Theme.of(context).primaryColor,
                disabledColor: Theme.of(context).backgroundColor,
                child: Text("Enviar"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _gridContent(Axis direction, Layout layout, List<Option> options,
      MultiSelection multiSelection) {
    double _height = 75.0;
    double _childAspectRatio = 0.25;
    int _crossAxisCount = 1;
    StaggeredTile _staggeredTile = StaggeredTile.count(1, 4);
    if (direction == Axis.vertical) {
      _staggeredTile = StaggeredTile.fit(1);
      _height = null;
    } else {
      _height = 75.0;
    }

    switch (layout) {
      case Layout.BUTTON:
        // _height = 75.0;
        break;
      case Layout.CARD:
        // _height = 75.0;
        break;
      case Layout.AVATAR_CARD:
        // _height = 75.0;
        break;
      case Layout.IMAGE_CARD:
        _height = null;
        _childAspectRatio = 1.0;
        if (direction == Axis.vertical) {
          _crossAxisCount = 2;
          _staggeredTile = StaggeredTile.extent(200, 200);
          // _staggeredTile = StaggeredTile.fit(2);
        } else {
          _staggeredTile = StaggeredTile.count(2, 1);
        }
        break;
    }

    return Container(
      height: _height,
      child: GridView.builder(
        shrinkWrap: true,
        scrollDirection: direction,
        controller: ScrollController(),
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
          childAspectRatio: _childAspectRatio,
          crossAxisCount: _crossAxisCount,
        ),
        itemCount: options.length,
        padding: const EdgeInsets.all(5.0),
        itemBuilder: (context, index) {
          return _chooseType(layout, options[index], multiSelection);
        },
      ),
    );

    return Container(
      height: _height,
      child: StaggeredGridView.builder(
        shrinkWrap: true,
        scrollDirection: direction,
        controller: ScrollController(),
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverStaggeredGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
          crossAxisCount: _crossAxisCount,
          staggeredTileCount: options.length,
          staggeredTileBuilder: (int index) {
            return _staggeredTile;
          },
        ),
        itemCount: options.length,
        padding: const EdgeInsets.all(5.0),
        itemBuilder: (context, index) {
          return _chooseType(layout, options[index], multiSelection);
        },
      ),
    );
  }

  Widget _slideContent(
      Layout layout, List<Option> options, MultiSelection multiSelection) {
    double _height = 75.0;
    if (layout == Layout.IMAGE_CARD) _height = 250.0;
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
        return Column(
          children: [
            Expanded(
                child: _chooseType(layout, options[index], multiSelection)),
          ],
        );
      },
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
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
            Expanded(
              child: Container(
                height: _height,
                child: _carouselSlider,
              ),
            ),
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
        ),
      ],
    );
  }

  Widget _searchContent(
      Layout layout, List<Option> options, MultiSelection multiSelection) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 5.0),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: options.length,
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 5.0),
                child: _chooseType(layout, options[index], multiSelection),
              );
            },
          ),
        ),
        SizedBox(height: 5.0),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Theme.of(context).backgroundColor,
          ),
          margin: EdgeInsets.all(5.0),
          child: TextFormField(
            minLines: 1,
            maxLines: 5,
            autofocus: true,
            focusNode: _messageFocus,
            controller: _messageText,
            scrollPhysics: BouncingScrollPhysics(),
            textInputAction: TextInputAction.newline,
            cursorColor: Theme.of(context).primaryColor,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: "Informe a opção desejada",
              contentPadding: EdgeInsets.all(10.0),
              border: generalOutlineInputBorder(),
              focusedBorder: generalOutlineInputBorder(),
              enabledBorder: generalOutlineInputBorder(),
              disabledBorder: generalOutlineInputBorder(),
              focusedErrorBorder: generalOutlineInputBorder(),
              errorBorder: generalOutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _chooseType(
      Layout layout, Option option, MultiSelection multiSelection) {
    switch (layout) {
      case Layout.BUTTON:
        return _buttonContent(option, multiSelection);
      case Layout.CARD:
        return _cardContent(option, multiSelection);
      case Layout.AVATAR_CARD:
        return _avatarCardContent(option, multiSelection);
      case Layout.IMAGE_CARD:
        return _imageCardContent(option, multiSelection);
    }
    return Container();
  }

  Widget _buttonContent(Option option, MultiSelection multiSelection) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Observer(
            builder: (context) {
              final bool _enabled =
                  _controller.optionsSelecteds.contains(option);
              return FlatButton(
                onPressed: () => _onTapOption(option, multiSelection),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: _enabled
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).textTheme.headline4.color,
                textColor: _enabled ? Colors.white : null,
                padding: EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              "${option.title}",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                          _iconDetailsOption(option, multiSelection),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _cardContent(Option option, MultiSelection multiSelection) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Observer(
          builder: (context) {
            final bool _enabled = _controller.optionsSelecteds.contains(option);
            return FlatButton(
              onPressed: () => _onTapOption(option, multiSelection),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              color: _enabled
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).textTheme.headline4.color,
              textColor: _enabled ? Colors.white : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${option.title}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          "${option.subtitle}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _iconDetailsOption(option, multiSelection),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _avatarCardContent(Option option, MultiSelection multiSelection) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Observer(
          builder: (context) {
            final bool _enabled = _controller.optionsSelecteds.contains(option);
            return FlatButton(
              onPressed: () => _onTapOption(option, multiSelection),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              padding: EdgeInsets.all(15.0),
              color: _enabled
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).textTheme.headline4.color,
              textColor: _enabled ? Colors.white : null,
              child: Row(
                children: [
                  AvatarWidget(
                    url: option.image,
                    width: 35.0,
                    height: 35.0,
                    radius: 10.0,
                  ),
                  SizedBox(width: 5.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            "${option.title}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            "${option.subtitle}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _iconDetailsOption(option, multiSelection),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _imageCardContent(Option option, MultiSelection multiSelection) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Observer(
              builder: (context) {
                final bool _enabled = _controller.optionsSelecteds.contains(
                  option,
                );
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: FlatButton(
                    onPressed: () => _onTapOption(option, multiSelection),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: EdgeInsets.all(0.0),
                    color: _enabled
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).textTheme.headline4.color,
                    textColor: _enabled ? Colors.white : null,
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
                                        url: option.image,
                                        boxFit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 0.0,
                                right: 0.0,
                                child: Padding(
                                  padding: EdgeInsets.all(2.5),
                                  child: _iconDetailsOption(
                                    option,
                                    multiSelection,
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
                            style: TextStyle(
                              fontSize: 14.0,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        SizedBox(height: 5.0),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onTapOption(
      Option option, MultiSelection multiSelection) async {
    if (!multiSelection.enabled) {
      _controller.optionsSelecteds.add(option);
      await _controller.onSendOptionsMessage(widget.connection);
      return;
    }
    if (_controller.optionsSelecteds.contains(option)) {
      _controller.optionsSelecteds.remove(option);
    } else {
      _controller.optionsSelecteds.add(option);
    }
  }

  Future<void> _onViewOptionDetails(
      Option option, MultiSelection multiSelection) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(20.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              body: SafeArea(
                child: Container(
                  color: Theme.of(context).backgroundColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Detalhes da opção",
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                          iconButtonExit(context),
                        ],
                      ),
                      Divider(
                        color: Theme.of(context).textTheme.bodyText1.color,
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Theme.of(context).textTheme.headline5.color,
                        ),
                        child: AvatarWidget(
                          url: option.image,
                          boxFit: BoxFit.cover,
                          showIfUrlNone: false,
                          radius: 10.0,
                          width: 200.0,
                          height: 200.0,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(top: 10.0),
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _textFormFieldDetails(option.title, "Título"),
                              _textFormFieldDetails(
                                  option.subtitle, "Subtítulo"),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      _btnSelectOption(option, multiSelection),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _textFormFieldDetails(String initialValue, String labelText) {
    if (initialValue == null) return Container();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Theme.of(context).textTheme.headline4.color,
      ),
      margin: EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        readOnly: true,
        minLines: 1,
        maxLines: 10,
        initialValue: initialValue,
        scrollPhysics: BouncingScrollPhysics(),
        textInputAction: TextInputAction.newline,
        cursorColor: Theme.of(context).primaryColor,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(height: 3.0),
          contentPadding: EdgeInsets.fromLTRB(10.0, 35.0, 10.0, 15.0),
          border: generalOutlineInputBorder(),
          focusedBorder: generalOutlineInputBorder(),
          enabledBorder: generalOutlineInputBorder(),
          disabledBorder: generalOutlineInputBorder(),
          focusedErrorBorder: generalOutlineInputBorder(),
          errorBorder: generalOutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _iconDetailsOption(Option option, MultiSelection multiSelection) {
    final _enabled = _controller.optionsSelecteds.contains(option);
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _enabled
            ? Theme.of(context).primaryColor.withOpacity(0.5)
            : Theme.of(context).textTheme.headline4.color.withOpacity(0.5),
      ),
      child: IconButton(
        onPressed: () async => await _onViewOptionDetails(
          option,
          multiSelection,
        ),
        tooltip: "Detalhes",
        visualDensity: VisualDensity.compact,
        icon: Icon(Icons.info_outline_rounded),
      ),
    );
  }

  Widget _btnSelectOption(Option option, MultiSelection multiSelection) {
    return Observer(
      builder: (context) {
        final bool _selected = _controller.optionsSelecteds.contains(option);
        String _label = "Selecionar";

        if (_selected) _label = "Selecionado";
        if (!multiSelection.enabled) _label = "Enviar";
        return Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FlatButton(
                onPressed: () async {
                  if (!multiSelection.enabled) {
                    _controller.optionsSelecteds.add(option);
                    await _controller.onSendOptionsMessage(widget.connection);
                    Navigator.pop(context);
                    return;
                  }
                  if (_selected) {
                    _controller.optionsSelecteds.remove(option);
                  } else {
                    _controller.optionsSelecteds.add(option);
                  }
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: _selected || !multiSelection.enabled
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).cardColor,
                textColor: Colors.white,
                child: Text(_label),
              ),
            ],
          ),
        );
      },
    );
  }
}
