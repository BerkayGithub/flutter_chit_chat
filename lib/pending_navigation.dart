class PendingNavigation {
  PendingNavigation._();
  static final PendingNavigation instance = PendingNavigation._();

  Map<String, dynamic>? _data;

  void save(Map<String, dynamic> data) {
    _data = data;
  }

  Map<String, dynamic>? consume() {
    final temp = _data;
    _data = null;
    return temp;
  }
}
