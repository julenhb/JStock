import 'package:flutter/material.dart';

import '../api_controls.dart';
import '../entity/aula.dart';
import '../entity/inventario.dart';
import '../entity/objeto.dart';
import '../entity/usuario.dart';

class GeneralStock extends StatefulWidget {
  @override
  _GeneralStockState createState() => _GeneralStockState();
}

class _GeneralStockState extends State<GeneralStock> {

  late List<Objeto> objetos = [];
  late List<Aula> aulas = [];
  late List<String> aulasNombre = [];
  late Usuario user;
  late String ayuda1;
  late String ayuda2;
  bool loadingAulas = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bundle = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    user = bundle[0];
    final Inventario stock = bundle[1];

    ayuda1 = stock.nombre;
    ayuda2 = user.nombre;

    fetchData(stock.id);
  }

  Future<void> fetchData(int idInventario) async {
    final fetchedObjetos = await ApiControls.getObjetosByInventario(idInventario);
    setState(() {
      objetos = fetchedObjetos;
    });

    final idAulas = objetos.map((objeto) => objeto.idAula).toSet();
    final aulasMap = <int, String>{};

    for (final idAula in idAulas) {
      final fetchedAula = await ApiControls.getAulaById(idAula) as Aula;
      aulasMap[idAula] = fetchedAula.nombre;
    }

    setState(() {
      aulasNombre = objetos.map((objeto) => aulasMap[objeto.idAula] ?? '').toList();
      loadingAulas = false;
    });
  }

  Future<void> fetchAulaData(int idAula) async {
    final fetchedAula = await ApiControls.getNombreAulaById(idAula);
    setState(() {
      aulas = fetchedAula;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bundle = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    Usuario userToGo = bundle[0];
    Inventario stockToGo = bundle[1];

    late int selectedAula;
    late Aula aulaToGo;

    return Scaffold(
      appBar: AppBar(
        title: Text(ayuda1),
        backgroundColor: Colors.green,
      ),
      body: loadingAulas
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
              ),
            )
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DataTable(
                      columns: [
                        DataColumn(label: Text('Nombre')),
                        DataColumn(label: Text('Aula')),
                        // Puedes agregar más columnas si es necesario
                      ],
                      rows: objetos.map((objeto) {
                        final aulaNombre = aulasNombre[objetos.indexOf(objeto)];
                        return DataRow(
                          cells: [
                            DataCell(Text(objeto.nombre)),
                            DataCell(
                              Text(aulaNombre),
                              onTap: () async {
                                setState(() {
                                  selectedAula = objeto.idAula;
                                });

                                final aulaToGo = await ApiControls.getAulaById(selectedAula);
                                String aux = "auxiliar";
                                final List<dynamic> args = [userToGo, stockToGo, aux, aulaToGo];
                                await Navigator.pushNamed(context, '/roomStock', arguments: args);
                              },
                            ),
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
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            children: [
              Text(
                ayuda2,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}