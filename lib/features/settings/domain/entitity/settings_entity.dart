class SettingsEntityModel {
  final String? name;
  final String? email;
  final String? imageUrl;
  final String? phone;
  bool isEnableFingerPrint;
  SettingsEntityModel({
    this.name = '',
    this.email = '',
    this.imageUrl = '',
    this.isEnableFingerPrint = false,
    this.phone,
  });

  SettingsEntityModel copyWith({
    String? name,
    String? email,
    String? imageUrl,
    String? phone,
    bool isEnableFingerPrint = false,
  }) {
    return SettingsEntityModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      imageUrl: imageUrl ?? this.imageUrl,
      isEnableFingerPrint: isEnableFingerPrint,
    );
  }
}
