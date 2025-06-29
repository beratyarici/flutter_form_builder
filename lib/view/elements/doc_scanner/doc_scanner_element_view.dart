import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_form_builder/constants/dimensions.dart';
import 'package:flutter_form_builder/model/elements/doc_scanner/doc_scanner_element_model.dart';

class DocScannerElementView extends StatefulWidget {
  const DocScannerElementView({super.key, required this.docScannerElement});

  final DocScannerElementModel docScannerElement;

  @override
  State<DocScannerElementView> createState() => _DocScannerElementViewState();
}

class _DocScannerElementViewState extends State<DocScannerElementView> {
  String? _base64Image;

  Future<String?> scanDocumentAsImage() async {
    try {
      final dynamic scannedDocumentPath = await FlutterDocScanner()
          .getScannedDocumentAsImages(page: 1);

      if (scannedDocumentPath != null) {
        late File imageFile;

        if (scannedDocumentPath is String) {
          imageFile = File(scannedDocumentPath);
        } else if (scannedDocumentPath is List<dynamic>) {
          if (scannedDocumentPath.isEmpty) return null;

          imageFile = File((scannedDocumentPath).first);
        } else if (scannedDocumentPath is Map) {
          if (scannedDocumentPath.isEmpty) return null;

          final String? path = scannedDocumentPath['Uri'] as String?;
          if (path == null || path.isEmpty) return null;

          final regex = RegExp(r'file://[^}]+');
          final match = regex.firstMatch(path);
          final filePath = match?.group(0);

          if (filePath == null || filePath.isEmpty) return null;

          imageFile = File(Uri.parse(filePath).toFilePath());
        } else {
          return null;
        }

        final List<int> imageBytes = await imageFile.readAsBytes();
        final String base64Image = base64Encode(imageBytes);

        setState(() {
          _base64Image = base64Image;
        });

        return base64Image;
      }
    } catch (e) {
      debugPrint("Belge tarama hatası: $e");
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      initialValue: widget.docScannerElement.value,
      validator: (value) {
        if (widget.docScannerElement.required &&
            (value == null || (value is String && value.isEmpty))) {
          return widget.docScannerElement.validation ??
              'Bu alan boş bırakılamaz!'; // TODO l10n
        }

        return null;
      },
      onSaved: (value) {
        widget.docScannerElement.value = value;
      },
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.docScannerElement.label != null) ...[
              Text(
                widget.docScannerElement.label!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: Dimensions.spacing),
            ],
            Material(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(Dimensions.borderRadius),
                ),
                side: BorderSide(
                  color: state.hasError
                      ? Theme.of(context).colorScheme.error
                      : Colors.grey.withValues(alpha: 0.5),
                  width: state.hasError
                      ? Dimensions.borderWidth
                      : Dimensions.borderWidth / 2,
                ),
              ),
              child: _base64Image != null
                  ? Padding(
                      padding: const EdgeInsets.all(Dimensions.padding),
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/gallery_check.svg',
                            package: 'form_builder',
                            width: Dimensions.iconSize * 2,
                            height: Dimensions.iconSize * 2,
                            colorFilter: ColorFilter.mode(
                              Colors.green,
                              BlendMode.srcIn,
                            ),
                          ),
                          Text(
                            'Resim yüklendi', // TODO l10n
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: Dimensions.padding / 2,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextButton.icon(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .error
                                          .withValues(alpha: 0.15),
                                      foregroundColor: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _base64Image = null;

                                        widget.docScannerElement.value = null;

                                        state.didChange(null);
                                      });
                                    },
                                    label: Text(
                                      'Sil', // TODO l10n
                                    ),
                                    icon: Icon(
                                      Icons.delete,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: Dimensions.spacing),
                                Expanded(
                                  child: TextButton.icon(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.green.withValues(
                                        alpha: 0.15,
                                      ),
                                      foregroundColor: Colors.green,
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        _base64Image = null;

                                        widget.docScannerElement.value = null;

                                        state.didChange(null);
                                      });

                                      final image = await scanDocumentAsImage();

                                      if (image != null) {
                                        widget.docScannerElement.value = image;

                                        state.didChange(image);
                                      }
                                    },
                                    label: Text(
                                      'Tekrar Çek', // TODO l10n
                                    ),
                                    icon: Icon(
                                      Icons.refresh,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : InkWell(
                      onTap: () async {
                        final image = await scanDocumentAsImage();

                        if (image != null) {
                          widget.docScannerElement.value = image;

                          state.didChange(image);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(Dimensions.padding),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/doc_scan.svg',
                              package: 'form_builder',
                              width: Dimensions.iconSize * 1.5,
                              height: Dimensions.iconSize * 1.5,
                              colorFilter: const ColorFilter.mode(
                                Colors.grey,
                                BlendMode.srcIn,
                              ),
                            ),
                            Text(
                              'Belge Tara', // TODO l10n
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(
                  top: Dimensions.padding / 3,
                  left: Dimensions.padding,
                ),
                child: Text(
                  state.errorText ?? '',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
