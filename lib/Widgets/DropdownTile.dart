import 'package:flutter/material.dart';

// DropdownTile widget class, which accepts a hint text and a list of items
class DropdownTile extends StatefulWidget {
  final String hintText; // Hint text for the dropdown
  final List<String> items; // List of dropdown items
  final Function(String?) onChanged; // Callback for when a value is selected

  // Constructor for DropdownTile
  const DropdownTile({
    super.key,
    required this.hintText, // Initialize hintText with a required value
    required this.items,
    required this.onChanged, // Initialize items with a required value
  });

  @override
  _DropdownTileState createState() =>
      _DropdownTileState(); // Creates the mutable state for the widget
}

// State class for DropdownTile
class _DropdownTileState extends State<DropdownTile> {
  String? selectedValue; // Holds the currently selected item from the dropdown

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 16.0), // Adds horizontal padding
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.grey), // Adds a grey border around the container
        borderRadius:
            BorderRadius.circular(8.0), // Rounds the corners of the border
      ),
      child: DropdownButtonHideUnderline(
        // Hides the default underline of the dropdown button
        child: DropdownButton<String>(
          hint: Text(
              widget.hintText), // Displays hint text when no item is selected
          value:
              selectedValue, // Sets the current selected value of the dropdown
          isExpanded:
              true, // Makes the dropdown take full width of the container
          items: widget.items.map((String value) {
            // Maps each item in the list to a DropdownMenuItem
            return DropdownMenuItem<String>(
              value: value, // Sets the value of this dropdown item
              child: Text(value), // Displays the item text
            );
          }).toList(),
          onChanged: (String? newValue) {
            // Triggered when an item is selected
            setState(() {
              selectedValue = newValue; // Updates the selected value
              widget.onChanged(newValue); // Calls the onChanged callback
            });
          },
        ),
      ),
    );
  }
}
