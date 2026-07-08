import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../../core/constant/enums.dart';

abstract class AddPropertyStates {}

class AddPropertyInitialState extends AddPropertyStates {}

class PickImageState extends AddPropertyStates {
  final Status status;
  final File? image;
  final String? message;
  PickImageState({required this.status, this.image, this.message});
}

class GetPropertyCardState extends AddPropertyStates {
  final Status status;
  final String? message;
  GetPropertyCardState({required this.status, this.message});
}
