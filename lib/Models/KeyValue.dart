class KeyValue {
  String key;
  Object value;

  KeyValue(this.key, this.value);

  String toJson() {
    return '"' + key + '": "' + value.toString() + '"';
  }
}
