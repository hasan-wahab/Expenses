class SettingsEntityModel {
  final String? name;
  final String? email;
  final String? imageUrl;
  bool isEnableFingerPrint;
  SettingsEntityModel({
    this.name = '',
    this.email = '',
    this.imageUrl = '',
    this.isEnableFingerPrint = false,
  });

  SettingsEntityModel copyWith({
    String? name,
    String? email,
    String? imageUrl,
    bool isEnableFingerPrint = false,
  }) {
    return SettingsEntityModel(
      name: name ?? this.name,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      isEnableFingerPrint: isEnableFingerPrint,
    );
  }
}
