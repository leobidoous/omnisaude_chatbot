import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/core/utils/path_utils.dart';
import 'package:omnisaude_chatbot/app/shared/content_error/content_error_widget.dart';
import 'package:omnisaude_chatbot/app/shared/loading/loading_widget.dart';
import 'package:omnisaude_chatbot/app/shared/stylesheet/app_colors.dart';
import 'package:rx_notifier/rx_notifier.dart';

import 'shared_file.dart';

enum FromPDFType { URL, ASSET, FILE }

class ViewPDFService extends Disposable {
  final PageController _pageController = new PageController();
  final RxNotifier<bool> _isSharing = new RxNotifier(false);
  final ShareFile _shareFile = new ShareFile();

  PDFDocument _doc;

  void showPDFViwer(
    BuildContext context, {
    String path,
    String url,
    File file,
    String title,
    FromPDFType fromPDFType: FromPDFType.ASSET,
    Function([Status]) changeStatus,
  }) async {
    switch (fromPDFType) {
      case FromPDFType.URL:
        _fromURL(url, changeStatus);
        break;
      case FromPDFType.ASSET:
        _fromAsset(path, changeStatus);
        break;
      case FromPDFType.FILE:
        _fromFile(file, changeStatus);
        break;
    }

    await showDialog(
      context: context,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: AppColors.background,
              boxShadow: [
                BoxShadow(
                  color: AppColors.card,
                  blurRadius: 5,
                ),
              ],
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title ?? '',
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          color: AppColors.primary,
                          size: 30.0,
                        ),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        alignment: Alignment.centerRight,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _bodyPDFViwer(
                    fromPDFType: fromPDFType,
                    path: path,
                    file: file,
                    url: url,
                    status: changeStatus,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() => changeStatus(Status.NONE));
  }

  Widget _bodyPDFViwer({
    FromPDFType fromPDFType,
    String path,
    String url,
    File file,
    Function([Status]) status,
  }) {
    return RxBuilder(
      builder: (context) {
        switch (status()) {
          case Status.LOADING:
            return LoadingWidget();
          case Status.ERROR:
            return Padding(
              padding: const EdgeInsets.all(20),
              child: ContentErrorWidget(
                messageLabel: 'Ocorreu um erro ao exibir este documento!',
                buttonLabel: 'Tentar novamente',
                function: () {
                  switch (fromPDFType) {
                    case FromPDFType.URL:
                      _fromURL(url, status);
                      break;
                    case FromPDFType.ASSET:
                      _fromAsset(path, status);
                      break;
                    case FromPDFType.FILE:
                      _fromFile(file, status);
                      break;
                  }
                },
              ),
            );
          default:
            break;
        }
        return ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0),
          ),
          child: PDFViewer(
            document: _doc,
            lazyLoad: false,
            indicatorBackground: AppColors.primary,
            controller: _pageController,
            enableSwipeNavigation: true,
            navigationBuilder: (
              context,
              int pageNumber,
              int totalPages,
              void Function({int page}) jumpToPage,
              void Function({int page}) animateToPage,
            ) {
              int _page = 0;
              if (_pageController.hasClients) {
                _page = _pageController.page.round();
              }
              final GlobalKey _downloadKey = new GlobalKey();
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                  color: AppColors.card.withOpacity(0.25),
                ),
                padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ButtonBar(
                      iconData: Icons.skip_previous_rounded,
                      label: 'primeira',
                      onPressed: _page == 0
                          ? null
                          : () => _pageController.jumpToPage(0),
                    ),
                    ButtonBar(
                      iconData: Icons.keyboard_arrow_left_outlined,
                      label: 'anterior',
                      onPressed: _page == 0
                          ? null
                          : () {
                              _pageController.previousPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeIn,
                              );
                            },
                    ),
                    RxBuilder(builder: (context) {
                      return ButtonBar(
                        loading: _isSharing.value,
                        key: _downloadKey,
                        iconData: Icons.share_rounded,
                        label: 'compartilhar',
                        onPressed: () {
                          _isSharing.value = true;
                          switch (fromPDFType) {
                            case FromPDFType.URL:
                              PathUtils()
                                  .getFileFromUrl(url)
                                  .then((file) async {
                                if (file == null) return;
                                await _shareFile.file(
                                  _downloadKey.currentContext,
                                  file,
                                );
                              }).whenComplete(() => _isSharing.value = false);
                              break;
                            case FromPDFType.ASSET:
                              PathUtils()
                                  .getFileFromAssets(path)
                                  .then((file) async {
                                if (file == null) return;
                                await _shareFile.file(
                                  _downloadKey.currentContext,
                                  file,
                                );
                              }).whenComplete(() => _isSharing.value = false);
                              break;
                            case FromPDFType.FILE:
                              _shareFile
                                  .file(_downloadKey.currentContext, file)
                                  .whenComplete(() => _isSharing.value = false);
                              break;
                          }
                        },
                      );
                    }),
                    ButtonBar(
                      iconData: Icons.keyboard_arrow_right_outlined,
                      onPressed: _page + 1 == _doc.count
                          ? null
                          : () {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeIn,
                              );
                            },
                      label: 'próxima',
                    ),
                    ButtonBar(
                      iconData: Icons.skip_next_rounded,
                      label: 'última',
                      onPressed: _page == _doc.count - 1
                          ? null
                          : () => _pageController.jumpToPage(_doc.count - 1),
                    ),
                  ],
                ),
              );
            },
            showPicker: false,
          ),
        );
      },
    );
  }

  _fromAsset(String path, Function(Status) changeStatus) async {
    changeStatus(Status.LOADING);
    await PDFDocument.fromAsset(path).then(
      (file) {
        _doc = file;
        changeStatus(Status.SUCCESS);
      },
    ).catchError((onError) => changeStatus(Status.ERROR));
  }

  _fromURL(String url, Function(Status) changeStatus) async {
    changeStatus(Status.LOADING);
    await PDFDocument.fromURL(url).then(
      (file) {
        _doc = file;
        changeStatus(Status.SUCCESS);
      },
    ).catchError((onError) => changeStatus(Status.ERROR));
  }

  _fromFile(File file, Function(Status) changeStatus) async {
    changeStatus(Status.LOADING);
    await PDFDocument.fromFile(file).then(
      (file) {
        _doc = file;
        changeStatus(Status.SUCCESS);
      },
    ).catchError((onError) => changeStatus(Status.ERROR));
  }

  @override
  void dispose() {}
}

class ButtonBar extends StatelessWidget {
  final IconData iconData;
  final Function onPressed;
  final String label;
  final loading;

  const ButtonBar({
    Key key,
    this.iconData,
    this.onPressed,
    this.label,
    this.loading: false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: this.onPressed,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          disabledColor: AppColors.header,
          color: AppColors.primary,
          icon: loading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                    backgroundColor: AppColors.card.withOpacity(0.25),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                )
              : Icon(this.iconData),
        ),
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              color:
                  this.onPressed == null ? AppColors.header : AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
