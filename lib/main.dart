import 'dart:convert';

import 'package:country_config_editor/json_processor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _countryCodeController = TextEditingController();
  final TextEditingController _featureNameController = TextEditingController();
  final TextEditingController _fieldToUpdateController =
      TextEditingController();
  final TextEditingController _updatedValueController = TextEditingController();
  String formattedJson = "";
  String variableType = "Other";
  List<String> variableList = ["Map", "Other"];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Config Editor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        TextField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            labelText: 'Paste the full country config',
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _countryCodeController,
                          decoration: const InputDecoration(
                              labelText: 'Enter Country Codes',
                              hintText: 'example: bd,co,ml'),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _featureNameController,
                          decoration: const InputDecoration(
                            labelText: 'Enter feature name',
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _fieldToUpdateController,
                          decoration: const InputDecoration(
                            labelText: 'Enter field name',
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _updatedValueController,
                          decoration: const InputDecoration(
                            labelText: 'Enter new value',
                          ),
                        ),
                        const SizedBox(height: 20),
                        MaterialButton(
                          color: theme.primaryColor,
                          onPressed: () {
                            final jsonString = _textController.text;
                            final countryCodes = _countryCodeController.text;
                            final featureName = _featureNameController.text;
                            final fieldToUpdate = _fieldToUpdateController.text;
                            final updatedValue = _updatedValueController.text;
                            final countryCodeList =
                                countryCodes.split(",").where((element) {
                              return element.isNotEmpty;
                            }).toList();

                            try {
                              final list = iterateJson(
                                jsonString,
                                countryCodeList,
                                featureName,
                                fieldToUpdate,
                                updatedValue,
                              );
                              jsonEncode(list);
                              formattedJson = list.toString();
                              setState(() {});
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: theme.colorScheme.error,
                                  content: Text(
                                    e.toString(),
                                  ),
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Apply Changes',
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimary,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "How to use",
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 32,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "1. Paste the full country config file exactly as it is",
                          ),
                          Text(
                            "2. Enter the country code, the feature name, the field you want to change and the new value",
                          ),
                          Text(
                            "3. Hit apply changes",
                          ),
                          Text(
                            "4. Copy the updated json and use it!",
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            "Upcoming Features",
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 32,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "- Fields validation",
                          ),
                          Text(
                            "- File selection from the computer",
                          ),
                          Text(
                            "- Change multiple fields at once",
                          ),
                          Text(
                            "- MacOs app to update and upload directly into firebase",
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            "For any inquiry or feedback reach out to me at ali.akber@deliveryhero.com",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                    ),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        child: Text(
                          formattedJson,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(
                            text: formattedJson,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Copied to Clipboard'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
