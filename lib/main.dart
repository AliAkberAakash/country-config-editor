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
  final TextEditingController _fieldToUpdateController =
      TextEditingController();
  final TextEditingController _updatedValueController = TextEditingController();
  String formattedJson = "";
  String variableType = "Other";
  List<String> variableList = ["Map","Other"];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualize JSON'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Enter JSON String',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _countryCodeController,
              decoration: const InputDecoration(
                labelText: 'Enter Country Code',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _fieldToUpdateController,
              decoration: const InputDecoration(
                labelText: 'Enter Field to update',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _updatedValueController,
                    decoration: const InputDecoration(
                      labelText: 'Enter value to update',
                    ),
                  ),
                ),
                DropdownButton<String>(
                  value: variableType,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      variableType = value!;
                    });
                  },
                  items: variableList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
              ],
            ),
            const SizedBox(height: 20),
            MaterialButton(
              color: theme.primaryColor,
              onPressed: () {
                final jsonString = _textController.text;
                final countryCode = _countryCodeController.text;
                final fieldToUpdate = _fieldToUpdateController.text;
                final updatedValue = _updatedValueController.text;

                try {
                  final list = iterateJson(
                    jsonString,
                    countryCode,
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Apply Changes',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontSize: 20,
                  ),
                ),
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
