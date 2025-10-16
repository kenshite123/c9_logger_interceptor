extension ArrayExtension<T> on List<T>? {
  bool isNullOrEmpty() {
    return this == null || this!.isEmpty == true;
  }

  bool isNotNullAndNotEmpty() {
    return !isNullOrEmpty();
  }

  List<T> filter(bool Function(T element) test) {
    List<T> listData = [];
    if (isNotNullAndNotEmpty()) {
      for (var element in this!) {
        if (test(element)) {
          listData.add(element);
        }
      }
    }

    return listData;
  }

  List<R> mapIndexed<R>(R Function(int index, T element) f) {
    if (isNullOrEmpty()) return [];
    return List.generate(this!.length, (int index) => f(index, this!.elementAt(index)));
  }

  void forEachIndexed(void Function(int index, T element) action) {
    if (isNotNullAndNotEmpty()) {
      var index = 0;
      for (var element in this!) {
        action(index, element);
        index++;
      }
    }
  }

  T? removeFirstOrNull() {
    if (isNullOrEmpty()) return null;
    return this!.removeAt(0);
  }

  T? removeLastOrNull() {
    if (isNullOrEmpty()) return null;
    return this!.removeAt(this!.length - 1);
  }

  T? firstWhereOrNull(bool Function(T element) test) {
    if (isNullOrEmpty()) return null;
    for (var element in this!) {
      if (test(element)) return element;
    }
    return null;
  }
}