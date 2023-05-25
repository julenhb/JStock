import 'package:flutter/material.dart';
import 'package:tfg_jhb/api_controls.dart';
import '../entity/ala.dart';
import '../entity/inventario.dart';
import '../entity/planta.dart';
import '../entity/usuario.dart';

class ItemSearch extends StatefulWidget {
  @override
  _ItemSearchState createState() => _ItemSearchState();
}

class _ItemSearchState extends State<ItemSearch> {

  List<Ala> alas = [];
  List<DropdownMenuItem<String>> alaItems = [];
  String selectedAla = 'Seleccionar';

  List<Planta> plantas = [];
  List<DropdownMenuItem<String>> plantaItems = [];
  late String selectedPlanta = "Seleccionar";

  @override
  void initState() {
    super.initState();
    fetchAlaData();
    fetchPlantaData();
  }

  Future<void> fetchAlaData() async {                       //LLENAMOS EL DROPDOWN DE LAS ALAS
    final fetchedAlas = await ApiControls.getAllAlas();     //Obtenemos todas las alas desde la API
    setState(() {
      alas = fetchedAlas;
      alaItems = buildDropdownAla();                        //Utilizamos el método que llena de valores el dropdown
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
    for (Ala ala in alas) {          //a partir de la Lista de alas obtemos los nombres para llenar el dropdown
      items.add(
        DropdownMenuItem(
          value: ala.nombre,
          child: Text(ala.nombre),
        ),
      );
    }
    return items;  //devolvemos la lista que contendrá los valores del dropdown
  }


  Future<void> fetchPlantaData() async {
    final fetchedPlantas = await ApiControls.getAllPlantas();
    plantaItems = buildDropdownPlanta(selectedAla); // Relleno los elementos del segundo DropdownButton
    setState(() {
      plantas = fetchedPlantas;
    });
  }

  // Listener del primer DropdownButton, lo llamos en el metodo onChanged del primero
  void onAlaSelected(String value) {
    setState(() {
      selectedAla = value;
      selectedPlanta = "Seleccionar";
    });
    fetchPlantaData(); // Obtener y actualizar los datos de las plantas según el ala seleccionada
  }


  List<DropdownMenuItem<String>> buildDropdownPlanta(String alaNombre) {      //Construyo el dropdown de las plantas a través del valor seleccionado en el de las Alas
    List<DropdownMenuItem<String>> items = [];
    Ala ala = alas.firstWhere((element) => element.nombre == alaNombre, orElse: () => Ala());      //creo un objeto ala buscando en la lista de alas una instancia con el mismo nombre que el que envío al método
    items.add(
      DropdownMenuItem(
        value: "Seleccionar",
        child: Text("Seleccionar"),
      ),
    );
    for (Planta planta in plantas) {
      if (ala.id == planta.idAla) {      //lleno el dropdown con las plantas que pertenecen a las alas seleccionadas
        items.add(
          DropdownMenuItem(
            value: planta.nombre,
            child: Text(planta.nombre),
          ),
        );
      }
    }
      return items;
    }


  @override
  Widget build(BuildContext context) {
    final bundle = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    Usuario usuario = bundle[0];
    Inventario inventario = bundle[1];

    print(usuario.nombre);
    print(inventario.nombre.toString());

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
            margin: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.25),
            width: double.infinity,
            height: 450,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(50), topLeft: Radius.circular(50))
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10), // Ajusta el valor según tus necesidades
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Selecciona un ala', style: TextStyle(fontSize: 20)),
                      DropdownButton(
                        value: selectedAla,
                        items: alaItems,
                        onChanged: (value) {
                          setState(() {
                            selectedAla = value as String;
                            onAlaSelected(selectedAla);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 60), // Ajusta el valor según tus necesidades
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Selecciona una planta', style: TextStyle(fontSize: 20)),
                      DropdownButton(
                        value: selectedPlanta,
                        items: plantaItems,
                        onChanged: (value) {
                          setState(() {
                            selectedPlanta = value as String;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.arrow_forward),
        onPressed: () async {
          final ala = alas.firstWhere((element) => element.nombre == selectedAla, orElse: () => Ala());
          Planta planta = plantas.firstWhere(
                (element) =>
            element.nombre == selectedPlanta && element.idAla == ala.id,
            orElse: () => Planta(),
          );
          if(planta.id != 0) {
            List<dynamic> paquete = bundle;
            paquete.add(planta);
            print(planta.id);
            await Navigator.pushNamed(context, '/roomItemSearch', arguments: paquete);
            paquete.removeAt(2);
          }
          else{
            print(planta.id);
          }
        },
      ),
    );
  }
}