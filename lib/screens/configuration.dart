import 'package:flutter/material.dart';
import 'package:playground_2502/providers/config_provider.dart';
import 'package:provider/provider.dart';

class ConfigurationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              'Adjust the settings below to customize your experience.',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: 24),
            // Size Option
            Text(
              'Size',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: context.watch<ConfigurationData>().size.toString(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Select Size',
              ),
              items: ['16', '18', '20', '22', '24']
                  .map((size) => DropdownMenuItem(
                        value: size,
                        child: Text(size),
                      ))
                  .toList(),
              onChanged: (value) {
                // Handle size selection
                context.read<ConfigurationData>().setSize(int.parse(value!));
              },
            ),
            SizedBox(height: 24),
            // Pallet Option
            Text(
              'Pallet',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Select Pallet',
              ),
              items: ['Light', 'Dark', 'Colorful']
                  .map((pallet) => DropdownMenuItem(
                        value: pallet,
                        child: Text(pallet),
                      ))
                  .toList(),
              onChanged: (value) {
                // Handle pallet selection
              },
            ),
          ],
        ),
      ),
    );
  }
}