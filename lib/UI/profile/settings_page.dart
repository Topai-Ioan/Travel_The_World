import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_the_world/themes/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('This is the Settings Page!'),
            SizedBox(height: 20),
            // Add your settings widgets here
            ThemeButton(),
          ],
        ),
      ),
    );
  }
}

class ThemeButton extends StatelessWidget {
  const ThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Show a pop-up with theme options
        showThemeDialog(context);
      },
      child: Text(
        'Change Theme',
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }

  void showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Theme',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
          content: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  var themeProvider =
                      Provider.of<ThemeProvider>(context, listen: false);
                  await themeProvider.setDarkThemeAsync();
                },
                child: Text('Dark Theme',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary)),
              ),
              ElevatedButton(
                onPressed: () async {
                  var themeProvider =
                      Provider.of<ThemeProvider>(context, listen: false);
                  await themeProvider.setSystemThemeAsync();
                },
                child: Text('System Default',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary)),
              ),
              ElevatedButton(
                onPressed: () async {
                  var themeProvider =
                      Provider.of<ThemeProvider>(context, listen: false);
                  await themeProvider.setWhiteThemeAsync();
                },
                child: Text('Light Theme',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary)),
              ),
            ],
          ),
        );
      },
    );
  }
}
