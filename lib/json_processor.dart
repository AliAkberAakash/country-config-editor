import 'dart:convert';

List iterateJson(String jsonString, countryCode, key, value) {
  final json = jsonDecode(jsonString);

  if (json is List) {
    for (int i = 0; i < json.length; i++) {
      if(json[i]["countryCode"] == countryCode) {
        json[i] = processJson(json[i], key, value);
      }
    }
    return json;
  } else {
    throw Exception("Invalid json");
  }
}

Map<String, dynamic> processJson(
    Map<String, dynamic> map, dynamic key, dynamic value) {
  for (var element in map.entries) {
    if (element.key == key) {
      map[key] = value;
      return map;
    }

    if (element.value is Map) {
      map[element.key] = processJson(element.value, key, value);
    }
  }

  return map;
}
