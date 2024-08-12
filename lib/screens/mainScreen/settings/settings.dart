import 'package:flutter/material.dart';
import 'settings_card.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),*/
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue,
            ),
            SizedBox(height: 20),
            InfoCard(title: 'Nombre'),
            SizedBox(height: 10),
            InfoCard(title: 'Info'),
            SizedBox(height: 10),
            InfoCard(title: 'ID de Institución'),
            SizedBox(height: 10),
            InfoCard(title: 'Contraseña'),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                
              ),
              child: Text('Restablecer contraseña'),
            ),
          ],
        ),
      ),
    );
  }
}

