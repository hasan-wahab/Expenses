import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../../core/constant/enums.dart';

abstract class AddPropertyStates {}

class AddPropertyInitialState extends AddPropertyStates {}

class PickImageState extends AddPropertyStates {
  final Status status;
  final XFile? imagePath;
  final String? message;
  PickImageState({required this.status, this.imagePath, this.message});
}

class GetAddedPropertyCardState extends AddPropertyStates {
  final Status status;
  final String? message;
  GetAddedPropertyCardState({required this.status, this.message});
}

//
