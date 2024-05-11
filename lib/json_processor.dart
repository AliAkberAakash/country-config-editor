import 'dart:convert';

const COUNTRY_CODE = "countryCode";
const CONFIG = "config";

String iterateJson(String jsonString, List<String> countryCodeList, featureName, key, value) {
  final json = jsonDecode(jsonString);

  if (json is List) {
    for (int i = 0; i < json.length; i++) {
      if(countryCodeList.contains(json[i][COUNTRY_CODE])) {
        if(json[i][CONFIG][featureName] != null) {
          json[i][CONFIG][featureName] = processJson(json[i][CONFIG][featureName], key, value);
        }
      }
    }
    return jsonEncode(json);
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
