import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_form_builder/constants/dimensions.dart';
import 'package:flutter_form_builder/model/elements/camera/camera_element_model.dart';
import 'package:image_picker/image_picker.dart';

class CameraElementView extends StatefulWidget {
  const CameraElementView({super.key, required this.cameraElement});

  final CameraElementModel cameraElement;

  @override
  State<CameraElementView> createState() => _CameraElementViewState();
}

class _CameraElementViewState extends State<CameraElementView> {
  final ImagePicker _picker = ImagePicker();
  String? _base64Image;

  Future<String?> _capturePhoto(bool useFrontCamera) async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: useFrontCamera
            ? CameraDevice.front
            : CameraDevice.rear,
      );

      if (photo != null) {
        final File imageFile = File(photo.path);
        final bytes = await imageFile.readAsBytes();
        final String base64Image = base64Encode(bytes);

        setState(() {
          _base64Image = base64Image;
        });

        debugPrint("Base64 Image: $_base64Image");

        return base64Image;
      }
    } catch (e) {
      debugPrint("Fotoğraf çekme hatası: $e");

      return null;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      initialValue: widget.cameraElement.value,
      validator: (value) {
        if (widget.cameraElement.required &&
            (value == null || (value is String && value.isEmpty))) {
          return widget.cameraElement.validation ??
              'Bu alan boş bırakılamaz!'; // TODO l10n
        }

        return null;
      },
      onSaved: (value) {
        widget.cameraElement.value = value;
      },
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.cameraElement.label != null) ...[
              Text(
                widget.cameraElement.label!,
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
                            'Fotoğraf Yüklendi', // TODO l10n
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

                                        widget.cameraElement.value = null;

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

                                        widget.cameraElement.value = null;

                                        state.didChange(null);
                                      });

                                      final image = await _capturePhoto(
                                        widget.cameraElement.cameraType ==
                                            CameraType.front,
                                      );

                                      if (image != null) {
                                        widget.cameraElement.value = image;

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
                        final image = await _capturePhoto(
                          widget.cameraElement.cameraType == CameraType.front,
                        );

                        if (image != null) {
                          widget.cameraElement.value = image;

                          state.didChange(image);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(Dimensions.padding),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/camera.svg',
                              package: 'form_builder',
                              width: Dimensions.iconSize * 1.5,
                              height: Dimensions.iconSize * 1.5,
                              colorFilter: const ColorFilter.mode(
                                Colors.grey,
                                BlendMode.srcIn,
                              ),
                            ),
                            Text(
                              'Fotoğraf Çek', // TODO l10n
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
