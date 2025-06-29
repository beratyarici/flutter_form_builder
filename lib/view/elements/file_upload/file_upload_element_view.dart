import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_form_builder/constants/dimensions.dart';
import 'package:flutter_form_builder/model/elements/upload/file_upload_element_model.dart';

class FileUploadElementView extends StatefulWidget {
  const FileUploadElementView({super.key, required this.uploadElement});

  final FileUploadElementModel uploadElement;

  @override
  State<FileUploadElementView> createState() => _FileUploadElementViewState();
}

class _FileUploadElementViewState extends State<FileUploadElementView> {
  File? _selectedFile;
  bool _isUploading = false;

  Future<void> pickFile() async {
    setState(() {
      _isUploading = true;
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpeg',
        'jpg',
        'png',
        'gif',
        'docx',
        'xls',
        'xlsx',
        'pptx',
      ],
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      int fileSize = await file.length();

      if (fileSize > 512 * 1024 * 1024) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Dosya Boyutu'), // TODO l10n
              content: Text(
                'Dosya boyutu 512 MB\'dan büyük olamaz.',
              ), // TODO l10n
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Tamam'), // TODO l10n
                ),
              ],
            ),
          );
        }

        setState(() {
          _isUploading = false;
        });

        return;
      }

      setState(() {
        _selectedFile = file;
        _isUploading = false;
      });
    } else {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      initialValue: widget.uploadElement.value,
      validator: (value) {
        if (widget.uploadElement.required &&
            (value == null || (value is String && value.isEmpty))) {
          return widget.uploadElement.validation ??
              'Bu alan boş bırakılamaz!'; // TODO l10n
        }

        return null;
      },
      onSaved: (value) {
        widget.uploadElement.value = value;
      },
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.uploadElement.label != null) ...[
              Text(
                widget.uploadElement.label!,
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
              child: InkWell(
                onTap: _isUploading
                    ? null
                    : () async {
                        await pickFile();

                        if (_selectedFile != null) {
                          widget.uploadElement.value = _selectedFile!.path;

                          state.didChange(_selectedFile!.path);
                        }
                      },
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.padding),
                  child: _isUploading
                      ? Column(
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: Dimensions.spacing),
                            Text(
                              'Dosya yükleniyor...', // TODO l10n
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : _selectedFile != null
                      ? Column(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/file_check.svg',
                              package: 'form_builder',
                              width: Dimensions.iconSize * 2,
                              height: Dimensions.iconSize * 2,
                              colorFilter: ColorFilter.mode(
                                Colors.green,
                                BlendMode.srcIn,
                              ),
                            ),
                            Text(
                              'Dosya yüklendi', // TODO l10n
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: Dimensions.spacing),
                            Row(
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
                                        _selectedFile = null;
                                        _isUploading = false;

                                        widget.uploadElement.value = null;

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
                                    onPressed: _isUploading
                                        ? null
                                        : () async {
                                            await pickFile();

                                            if (_selectedFile != null) {
                                              widget.uploadElement.value =
                                                  _selectedFile!.path;

                                              state.didChange(
                                                _selectedFile!.path,
                                              );
                                            }
                                          },
                                    label: Text(
                                      'Yeniden Yükle', // TODO l10n
                                    ),
                                    icon: Icon(
                                      Icons.refresh,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/upload.svg',
                              package: 'form_builder',
                              width: Dimensions.iconSize * 1.5,
                              height: Dimensions.iconSize * 1.5,
                              colorFilter: const ColorFilter.mode(
                                Colors.grey,
                                BlendMode.srcIn,
                              ),
                            ),
                            Text(
                              'Dosya Yükle', // TODO l10n
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
