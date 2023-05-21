import 'package:flutter/material.dart';
import 'package:tfg_jhb/pantallas/itemsearch.dart';
import 'package:tfg_jhb/main.dart';
import 'package:tfg_jhb/pantallas/scantag.dart';

import '../entity/usuario.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final usu = ModalRoute.of(context)!.settings.arguments as Usuario;
    final usu = Usuario.fromParameters(24332, "julen", "Julen", "1234567890", false, false);

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
                Navigator.pushNamed(context, '/itemSearch', arguments: usu);
              },
              child: Text('Buscar objeto'),
            ),
            ElevatedButton(
              onPressed: () {
                // Abrir pantalla de inventario
                Navigator.pushNamed(context, '/inventario');
              },
              child: Text('Ver inventario'),
            ),/*
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
            ),*/
          ],
        ),
      ),
    );
  }
}