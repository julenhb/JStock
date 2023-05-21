import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tfg_jhb/pantallas/itemsearch.dart';
import 'package:tfg_jhb/main.dart';
import 'package:tfg_jhb/pantallas/scantag.dart';

import '../api_controls.dart';
import '../entity/inventario.dart';
import '../entity/usuario.dart';

class MainMenu extends StatefulWidget {
  @override
    _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  List<Inventario> inventarios = [];
  List<DropdownMenuItem<String>> inventarioItems = [];
  String selectedInventario = 'Seleccionar';

  List<dynamic> bundle = [];

  @override
  void initState() {
    super.initState();
    fetchStockData();
  }

  Future<void> fetchStockData() async {                       //LLENAMOS EL DROPDOWN DE LAS ALAS
    final fetchedInventarios = await ApiControls.getAllInventarios();     //Obtenemos todas las alas desde la API
    setState(() {
      inventarios = fetchedInventarios;
      inventarioItems = buildDropdownAla();                        //Utilizamos el método que llena de valores el dropdown
    });
  }

  List<DropdownMenuItem<String>> buildDropdownAla() {
    List<DropdownMenuItem<String>> items = [];
    items.add(              //Añadimos el valor por defecto, si no da error
      DropdownMenuItem(
        value: "Seleccionar",
        child: Text("Seleccionar"),
      ),
    );
    for (Inventario stock in inventarios) {          //a partir de la Lista de alas obtemos los nombres para llenar el dropdown
      items.add(
        DropdownMenuItem(
          value: stock.nombre,
          child: Text(stock.nombre),
        ),
      );
    }
    return items;  //devolvemos la lista que contendrá los valores del dropdown
  }

  @override
  Widget build(BuildContext context) {
    final usu = ModalRoute.of(context)!.settings.arguments as Usuario;

    return Scaffold(
      appBar: AppBar(
        title: Text('Menú principal'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Aquí puedes agregar la lógica para manejar el botón de usuario
              // Por ejemplo, abrir un menú de usuario o realizar alguna acción relacionada
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 40, left: 30),
            child: Row(
              children: [
                Text(
                  'Inventario',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 8),
                DropdownButton(
                  value: selectedInventario,
                  items: inventarioItems,
                  onChanged: (value) {
                    setState(() {
                      selectedInventario = value as String;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: ElevatedButton(
                      onPressed: () {
                        if (selectedInventario == "Seleccionar"){
                          Fluttertoast.showToast(
                            msg: "Debes seleccionar un inventario para seguir avanzando",
                            toastLength: Toast.LENGTH_SHORT, // Duración del toast (Toast.LENGTH_SHORT o Toast.LENGTH_LONG)
                            gravity: ToastGravity.BOTTOM, // Posición del toast (TOP, BOTTOM, CENTER)
                            timeInSecForIosWeb: 1, // Duración para iOS y web (en segundos)
                            backgroundColor: Colors.grey[800], // Color de fondo del toast
                            textColor: Colors.white, // Color del texto del toast
                            fontSize: 16.0, // Tamaño de fuente del texto del toast
                          );
                        } else{
                          Usuario usu1 = usu;
                          Inventario stock = inventarios.firstWhere((element) => element.nombre == selectedInventario, orElse: () => Inventario());
                          bundle.add(usu1);
                          bundle.add(stock);
                          Navigator.pushNamed(context, '/itemSearch', arguments: bundle);
                        }
                      },
                      child: Text('Buscar objeto'),
                    ),
                  ),
                  SizedBox(height: 16),
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: ElevatedButton(
                      onPressed: () {
                        if (selectedInventario == "Seleccionar"){
                          Fluttertoast.showToast(
                            msg: "Debes seleccionar un inventario para seguir avanzando",
                            toastLength: Toast.LENGTH_SHORT, // Duración del toast (Toast.LENGTH_SHORT o Toast.LENGTH_LONG)
                            gravity: ToastGravity.BOTTOM, // Posición del toast (TOP, BOTTOM, CENTER)
                            timeInSecForIosWeb: 1, // Duración para iOS y web (en segundos)
                            backgroundColor: Colors.grey[800], // Color de fondo del toast
                            textColor: Colors.white, // Color del texto del toast
                            fontSize: 16.0, // Tamaño de fuente del texto del toast
                          );
                        } else{
                          Usuario usu1 = usu;
                          Inventario stock = inventarios.firstWhere((element) => element.nombre == selectedInventario, orElse: () => Inventario());
                          bundle.add(usu1);
                          bundle.add(stock);
                          Navigator.pushNamed(context, '/itemSearch', arguments: bundle);
                        }
                      },
                      child: Text('Ver inventario'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}