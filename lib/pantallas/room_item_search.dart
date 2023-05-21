
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../api_controls.dart';
import '../entity/aula.dart';
import '../entity/planta.dart';

class RoomItemSearch extends StatefulWidget {

  @override
  _RoomItemSearchState createState() => _RoomItemSearchState();
}

class _RoomItemSearchState extends State<RoomItemSearch> {

  List<Aula> aulas = [];
  List<DropdownMenuItem<String>> aulaItems = [];
  String selectedAula = 'Seleccionar';
  late Planta planta;
  bool dataLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    planta = ModalRoute.of(context)!.settings.arguments as Planta;
    fetchAulaData(planta.id);

  }

  Future<void> fetchAulaData(int idAula) async {
    final fetchedAulas = await ApiControls.getAulasByPlanta(planta.id);
    setState(() {
      aulas = fetchedAulas;
      aulaItems = buildDropdownAla();
      dataLoaded = true;
    });
  }

  List<DropdownMenuItem<String>> buildDropdownAla() {
    List<DropdownMenuItem<String>> items = [];
    items.add(
      DropdownMenuItem(
        value: "Seleccionar",
        child: Text("Seleccionar"),
      ),
    );
    for (Aula aula in aulas) {
      items.add(
        DropdownMenuItem(
          value: aula.nombre,
          child: Text(aula.nombre),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text('Búsqueda de objetos'),
        backgroundColor: Colors.redAccent,
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
            width: double.infinity,
            height: 450,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(50), topLeft: Radius.circular(50)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Selecciona un ala', style: TextStyle(fontSize: 20)),
                      SizedBox(height: 10,),
                      DropdownButton(
                        value: selectedAula,
                        items: aulaItems,
                        onChanged: (value) {
                          setState(() {
                            selectedAula = value as String;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (aulaItems.isEmpty) // Mostrar el círculo de carga dentro del contenedor
            Container(
              width: double.infinity,
              height: 450,
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.arrow_forward),
        onPressed: () {
          if (selectedAula == "Seleccionar") {
            final aula = aulas.firstWhere((element) =>
            element.nombre == selectedAula, orElse: () => Aula());
            Navigator.pushNamed(context, 'roomStock', arguments: aula);
          }else{
            print("0");
          }
        },
      ),
    );
  }
}