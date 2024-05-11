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

      if(map[key] is bool) {
        bool result = bool.parse(value.toString());
        map[key] = result;
      }else if(map[key] is int){
        int result = int.parse(value.toString());
        map[key] = result;
      }else if(map[key] is double) {
        double result = double.parse(value.toString());
        map[key] = result;
      }else if (map[key] is List) {
        final tmpList = value.toString().split(",");
        map[key] = tmpList;
      }else{
        map[key] = value;
      }

      return map;
    }

    if (element.value is Map) {
      map[element.key] = processJson(element.value, key, value);
    }
  }

  return map;
}
