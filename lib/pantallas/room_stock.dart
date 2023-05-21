import 'package:flutter/material.dart';
import 'package:tfg_jhb/entity/inventario.dart';
import 'package:tfg_jhb/entity/usuario.dart';

import '../api_controls.dart';
import '../entity/aula.dart';
import '../entity/objeto.dart';

class RoomStock extends StatefulWidget {
  @override
  _RoomStockState createState() => _RoomStockState();
}

class _RoomStockState extends State<RoomStock> {
  late List<Objeto> objetos = [];
  late Usuario user;
  late String ayuda1;
  late String ayuda2;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bundle = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    user = bundle[0];
    final Inventario stock = bundle[1];
    final Aula aula = bundle[3];

    ayuda1 = stock.nombre;
    ayuda2 = aula.nombre;

    fetchObjetosData(stock.id, aula.id);
  }

  Future<void> fetchObjetosData(int idInventario, int idAula) async {
      final fetchedObjetos = await ApiControls.getoObjetosByRoomStock(idInventario, idAula);
      setState(() {
        objetos = fetchedObjetos;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Stock'),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DataTable(
                columns: [
                  DataColumn(label: Text('Nombre')),
                  DataColumn(label: Text('Nº de Serie')),
                  // Puedes agregar más columnas si es necesario
                ],
                rows: objetos.map((objeto) {
                  return DataRow(
                    cells: [
                      DataCell(Text(objeto.nombre)),
                      DataCell(Text(objeto.numSerie))
                      // Puedes agregar más celdas si es necesario
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text(
                '$ayuda1 - $ayuda2',
                style: TextStyle(fontSize: 16),
              ),
              Spacer(),
              FloatingActionButton(
                onPressed: () {
                  // Lógica al presionar el botón flotante
                },
                backgroundColor: Colors.deepPurple,
                child: Icon(Icons.qr_code_scanner),
              ),
            ],
          ),
        ),
      ),
    );
  }
}