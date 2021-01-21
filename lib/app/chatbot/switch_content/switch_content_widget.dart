import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../connection/chat_connection.dart';
import '../../core/enums/enums.dart';
import '../../core/models/multi_selection_model.dart';
import '../../core/models/option_model.dart';
import '../../core/models/ws_message_model.dart';
import '../../shared/empty/empty_widget.dart';
import '../../shared/image/image_widget.dart';
import '../../shared/widgets/outline_input_border.dart';
import 'switch_content_controller.dart';

class SwitchContentWidget extends StatefulWidget {
  final ChatConnection connection;
  final WsMessage message;

  const SwitchContentWidget({
    Key key,
    @required this.message,
    @required this.connection,
  }) : super(key: key);

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
    _messageFocus.dispose();
    _messageText.dispose();
    _controller.dispose();
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(child: _widget),
        Container(
          color: Theme.of(context).textTheme.headline5.color,
          child: _btnSendMultiplesOptions(_multiSelection),
        ),
      ],
    );
  }

  Widget _btnSendMultiplesOptions(MultiSelection multiSelection) {
    return RxBuilder(builder: (_) {
      if (!multiSelection.enabled) return Container();
      final bool _enabled =
          _controller.selectedOptions.length >= multiSelection.min;
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
            _minMaxOptionsWidget(multiSelection),
          ],
        ),
      );
    });
  }

  Widget _minMaxOptionsWidget(MultiSelection multiSelection) {
    final String _label = multiSelection.min > 1 ? "opções" : "opção";
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        "* Selecione ao menos ${multiSelection.min} $_label.",
        style: TextStyle(fontSize: 10.0, fontStyle: FontStyle.italic),
      ),
    );
  }

  Widget _gridContent(Axis direction, Layout layout, List<Option> options,
      MultiSelection multiSelection) {
    double _height = 75.0;
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
        break;
      case Layout.CARD:
        break;
      case Layout.AVATAR_CARD:
        break;
      case Layout.IMAGE_CARD:
        int _crossAxisCount = 1;
        if (direction == Axis.vertical) _crossAxisCount = 2;
        return GridView.builder(
          shrinkWrap: true,
          itemCount: options.length,
          scrollDirection: direction,
          padding: const EdgeInsets.all(5.0),
          physics: const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
            childAspectRatio: 1.0,
            crossAxisCount: _crossAxisCount,
          ),
          itemBuilder: (context, index) {
            return _chooseType(layout, options[index], multiSelection);
          },
        );
    }

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
          staggeredTileBuilder: (int index) => _staggeredTile,
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
    if (layout == Layout.IMAGE_CARD) _height = 200.0;
    final CarouselSlider _carouselSlider = CarouselSlider.builder(
      itemCount: options.length,
      options: CarouselOptions(
        aspectRatio: 1.0,
        viewportFraction: 0.75,
        height: _height,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        scrollPhysics: BouncingScrollPhysics(),
      ),
      carouselController: _carouselController,
      itemBuilder: (context, index) {
        return _chooseType(layout, options[index], multiSelection);
      },
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Row(
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
                child: _carouselSlider,
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
        ),
      ],
    );
  }

  Widget _searchContent(
      Layout layout, List<Option> options, MultiSelection multiSelection) {
    final List<Option> _aux = List<Option>();
    options.forEach((option) => _aux.add(option));
    _controller.filteredOptions.clear();
    _aux.forEach((option) => _controller.filteredOptions.add(option));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 5.0),
        Flexible(
          child: RxBuilder(
            builder: (_) {
              if (_controller.filteredOptions.isEmpty) {
                return Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      EmptyWidget(
                        message: "Nenhuma resultado encontrado!",
                        padding: 10.0,
                      ),
                    ],
                  ),
                );
              }
              if (_controller.filteredOptions.isEmpty) {
                return Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Nenhuma opção encontrada",
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: _controller.filteredOptions.length,
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                physics: const BouncingScrollPhysics(
                  parent: const AlwaysScrollableScrollPhysics(),
                ),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: _chooseType(
                      layout,
                      _controller.filteredOptions[index],
                      multiSelection,
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 5.0),
        Stack(
          alignment: Alignment.centerRight,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Theme.of(context).backgroundColor,
              ),
              margin: EdgeInsets.all(5.0),
              child: TextFormField(
                autofocus: true,
                focusNode: _messageFocus,
                controller: _messageText,
                scrollPhysics: BouncingScrollPhysics(),
                onChanged: (String input) {
                  _controller.onSearchIntoOptions(options, input);
                },
                textInputAction: TextInputAction.done,
                cursorColor: Theme.of(context).primaryColor,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: "Informe a opção desejada",
                  contentPadding: const EdgeInsets.fromLTRB(
                    10.0,
                    10.0,
                    40.0,
                    10.0,
                  ),
                  border: outlineInputBorder(),
                  focusedBorder: outlineInputBorder(),
                  enabledBorder: outlineInputBorder(),
                  disabledBorder: outlineInputBorder(),
                  focusedErrorBorder: outlineInputBorder(),
                  errorBorder: outlineInputBorder(),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                if (_messageText.text.trim().isNotEmpty) {
                  _messageText.clear();
                  _controller.onSearchIntoOptions(
                    options,
                    _messageText.text.trim(),
                  );
                }
              },
              icon: Icon(Icons.arrow_drop_up_rounded),
            ),
          ],
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
          child: RxBuilder(
            builder: (_) {
              final bool _enabled = _controller.selectedOptions.contains(
                option,
              );
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
                padding: const EdgeInsets.all(15.0),
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
                              style: const TextStyle(fontSize: 18.0),
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
        RxBuilder(
          builder: (_) {
            final bool _enabled = _controller.selectedOptions.contains(option);
            return FlatButton(
              onPressed: () => _onTapOption(option, multiSelection),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 15.0,
              ),
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
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          "${option.subtitle}",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
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
        RxBuilder(
          builder: (_) {
            final bool _enabled = _controller.selectedOptions.contains(option);
            return FlatButton(
              onPressed: () => _onTapOption(option, multiSelection),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              padding: const EdgeInsets.all(15.0),
              color: _enabled
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).textTheme.headline4.color,
              textColor: _enabled ? Colors.white : null,
              child: Row(
                children: [
                  ImageWidget(
                    url: option.image,
                    width: 35.0,
                    height: 35.0,
                    radius: 10.0,
                  ),
                  const SizedBox(width: 5.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            "${option.title}",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 18.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            "${option.subtitle}",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
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
            child: RxBuilder(
              builder: (_) {
                final bool _enabled = _controller.selectedOptions.contains(
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
                    padding: const EdgeInsets.all(0.0),
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
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0),
                                        ),
                                        child: Container(
                                          color: Theme.of(context)
                                              .cardColor
                                              .withOpacity(0.5),
                                          child: ImageWidget(
                                            url: option.image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
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
      _controller.selectedOptions.add(option);
      await _controller.onSendOptionsMessage(widget.connection);
      return;
    }
    if (_controller.selectedOptions.contains(option)) {
      _controller.selectedOptions.remove(option);
    } else {
      if (multiSelection.max != null) {
        if (_controller.selectedOptions.length < multiSelection.max) {
          _controller.selectedOptions.add(option);
        } else {
          Scaffold.of(context).removeCurrentSnackBar();
          final String _label = multiSelection.max > 1 ? "opções" : "opção";
          Scaffold.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              duration: Duration(milliseconds: 2000),
              backgroundColor:
                  Theme.of(context).backgroundColor.withOpacity(0.95),
              padding: EdgeInsets.zero,
              margin: EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              content: Text(
                "É possível selecionar apenas ${multiSelection.max} $_label!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1.color,
                ),
              ),
            ),
          );
        }
      } else {
        _controller.selectedOptions.add(option);
      }
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
                          const Expanded(
                            child: const Text(
                              "Detalhes da opção",
                              style: const TextStyle(fontSize: 25),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  Theme.of(context).secondaryHeaderColor.withOpacity(0.2),
                            ),
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.close),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: Theme.of(context).textTheme.bodyText1.color,
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Theme.of(context).textTheme.headline5.color,
                        ),
                        child: ImageWidget(
                          url: option.image,
                          fit: BoxFit.cover,
                          radius: 10.0,
                          width: 200.0,
                          height: 200.0,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(top: 10.0),
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _textFormFieldDetails(
                                option.title,
                                "Título",
                              ),
                              _textFormFieldDetails(
                                option.subtitle,
                                "Subtítulo",
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
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
      margin: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        readOnly: true,
        minLines: 1,
        maxLines: 10,
        initialValue: initialValue,
        scrollPhysics: const BouncingScrollPhysics(
          parent: const AlwaysScrollableScrollPhysics(),
        ),
        textInputAction: TextInputAction.newline,
        cursorColor: Theme.of(context).primaryColor,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(height: 3.0),
          contentPadding: const EdgeInsets.fromLTRB(10.0, 35.0, 10.0, 15.0),
          border: outlineInputBorder(),
          focusedBorder: outlineInputBorder(),
          enabledBorder: outlineInputBorder(),
          disabledBorder: outlineInputBorder(),
          focusedErrorBorder: outlineInputBorder(),
          errorBorder: outlineInputBorder(),
        ),
      ),
    );
  }

  Widget _iconDetailsOption(Option option, MultiSelection multiSelection) {
    final _enabled = _controller.selectedOptions.contains(option);
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
        icon: const Icon(Icons.info_outline_rounded),
      ),
    );
  }

  Widget _btnSelectOption(Option option, MultiSelection multiSelection) {
    return RxBuilder(
      builder: (_) {
        final bool _selected = _controller.selectedOptions.contains(option);
        String _label = "Selecionar";
        if (_selected) _label = "Selecionado";
        if (!multiSelection.enabled) _label = "Enviar";
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FlatButton(
                onPressed: () async {
                  if (!multiSelection.enabled) {
                    _controller.selectedOptions.add(option);
                    await _controller.onSendOptionsMessage(widget.connection);
                    Navigator.pop(context);
                    return;
                  }
                  if (_selected) {
                    _controller.selectedOptions.remove(option);
                  } else {
                    _controller.selectedOptions.add(option);
                  }
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: _selected || !multiSelection.enabled
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).secondaryHeaderColor,
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
