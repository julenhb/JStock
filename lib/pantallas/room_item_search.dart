import 'package:flutter/material.dart';
import '../api_controls.dart';
import '../entity/aula.dart';
import '../entity/inventario.dart';
import '../entity/planta.dart';
import '../entity/usuario.dart';

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
    final bundle = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    planta = bundle[2];
    Usuario usuario = bundle[0];
    Inventario inventario = bundle[1];

    print(usuario.nombre);
    print(inventario.nombre.toString());
    print(planta.nombre);

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
    final bundle = ModalRoute.of(context)!.settings.arguments as List<dynamic>;

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
                      Text('Selecciona un aula', style: TextStyle(fontSize: 20)),
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
          if (aulaItems.isEmpty)
            // Mostrar el círculo de carga dentro del contenedor
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
        onPressed: () async {
          if (selectedAula != "Seleccionar") {
            List<dynamic> paquete = bundle;
            final aula = aulas.firstWhere((element) => element.nombre == selectedAula, orElse: () => Aula());
            if(paquete.length >= 4){
              paquete.removeAt(3);
            }
            paquete.add(aula);
            await Navigator.pushNamed(context, '/roomStock', arguments: paquete);
            paquete.remove(aula);
          }else{
            print("0");
          }
        },
      ),
    );
  }
}