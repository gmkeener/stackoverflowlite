extension TimeConvertDouble on double {
  String getTimeTwoSpaces() {
    return this.toString().padLeft(2, '0');
  }
}

extension TimeConvertInt on int {
  String getTimeTwoSpaces() {
    return this.toString().padLeft(2, '0');
  }
}
