import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField(
      {super.key,
      required this.controller,
      required this.onSearch,
      required this.hintText});

  final TextEditingController controller;
  final Function(String) onSearch;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          suffixIcon: IconButton(
              onPressed: () {
                controller.clear();
                onSearch('');
              },
              icon: Icon(
                Icons.clear,
                color:
                    controller.text.isEmpty ? Colors.white : Colors.red,
              ))),
      onChanged: (value) {
        onSearch(value);
      },
    );
  }
}
