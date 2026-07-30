class NaveBarStates {
  final int index;
  final int homeRefreshKey;

  NaveBarStates({this.index = 0, this.homeRefreshKey = 0});

  NaveBarStates copyWith({int? index, int? homeRefreshKey}) {
    return NaveBarStates(
      index: index ?? this.index,
      homeRefreshKey: homeRefreshKey ?? this.homeRefreshKey,
    );
  }
}
