import 'package:flutter/material.dart';
import 'package:tfg_jhb/itemsearch.dart';
import 'package:tfg_jhb/main.dart';
import 'package:tfg_jhb/scantag.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú principal'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                // Abrir pantalla de búsqueda
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ItemSearch()));
              },
              child: Text('Buscar objeto'),
            ),
            ElevatedButton(
              onPressed: () {
                // Abrir pantalla de inventario
                Navigator.pushNamed(context, '/inventario');
              },
              child: Text('Ver inventario'),
            ),
            InkWell(
              onTap: () {
                // Abrir pantalla de escaneo
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ScanTag()));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Identificar objeto',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}