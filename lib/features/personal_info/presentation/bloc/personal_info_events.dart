import 'package:image_picker/image_picker.dart';

import '../../../settings/domain/entitity/settings_entity.dart';

abstract class PersonalInfoEvents {}

class PickImageEvent extends PersonalInfoEvents {
  ImageSource? source;
  PickImageEvent({this.source});
}

class UpdatePersonalInfoEvent extends PersonalInfoEvents {
  SettingsEntityModel entityModel;
  UpdatePersonalInfoEvent({required this.entityModel});
}
