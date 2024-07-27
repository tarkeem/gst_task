import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String? city;
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
    void submit() {
      setState(() {
        autovalidateMode = AutovalidateMode.always;
      });

      final form = formKey.currentState;

      if (form != null && form.validate()) {
        form.save();
        Navigator.pop(context, city!.trim());
      }
    }

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Search')),
      body: Form(
        key: formKey,
        autovalidateMode: autovalidateMode,
        child: Column(
          children: [
            const SizedBox(height: 60.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TextFormField(
                autofocus: true,
                style: const TextStyle(fontSize: 18.0),
                decoration: const InputDecoration(
                  labelText: 'City',
                  hintText: 'Enter The Name of the City',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                validator: (String? input) {
                  if (input == null || input.trim().length < 2||input=="") {
                    return 'Please Enter The Name of the City';
                  }
                  return null;
                },
                onSaved: (String? input) {
                  city = input;
                },
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: submit,
              child: const Text(
                "What's The weather Today?",
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
