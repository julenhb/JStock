import 'package:flutter/material.dart';
import 'package:tfg_jhb/scantag.dart';

class ItemSearch extends StatelessWidget {

  List<String> listaAlas = [];                  //VAMOS A CREAR ESTAS LISTAS PARA CADA UNA DE LAS OCURRENCIAS DE ESTAS TRES TABLAS
  List<String> listaPlantas = [];
  List<String> listaAulas = [];

                                              //EN LA VERSIÓN FINAL SE DEBERÁ RELLENAR A TRAVÉS DE LA API, PERO PARA PROBAR EL FUNCIONAMIENTO
                                              //SETEAREMOS VALORES POR DEFECTO DIRECTAMENBTE
  ItemSearch(){
    listaAlas.addAll(['Ala Izquierda', 'Ala Derecha']);
    listaPlantas.addAll(['Planta 1', 'Planta 2', 'Planta 3']);
    listaAulas.addAll(['Aula 0', 'Aula 1', 'Aula 2', 'Aula 3', 'Aula 4', 'Aula 5', 'Aula 6', 'Aula 7', 'Aula 8']);
  }


  //CÓMO VOY A MANEJAR MÁS DE UN DropDown ITEM, LO QUE VOY A HACER PARA DIFERENCIARLOS ES METERLOS EN UN MÉTODO CON LISTAS CON OBJETOS
  // DE ESE TIPO DE ITEMS, DE MANERA QUE ASÍ ABAJO SÓLO TENGO QUE LLAMARLOS POR EL NOMBRE QUE LES DOY AQUÍ

  List<DropdownMenuItem<String>> buildDropdownMenuItems(List<String> items){
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems.add(
      DropdownMenuItem(
        value: 'Seleccionar',
        child: Text('Seleccionar'),
      ),
    );
    for (String item in items){
      menuItems.add(
        DropdownMenuItem(
          value: item,
          child: Text(item),
        ),
      );
    }
    return menuItems;
  }


  @override
  Widget build(BuildContext context) {

    bool hideFloor = true;      //PARA ESCONDER EL DDButton DE LAS PLANTAS HASTA QUE NO SE SELECCIONE UN ALA
    bool hideRoom = true;       //PARA ESCONDER EL DDButton DE LAS AULAS HASTA QUE NO SE SELECCIONES UNA PLANTA
    bool hideIButton = true;    //PARA ESCONDER EL BOTÓN QUE NOS LLEVA AL INVENTARIO HASTA QUE NO SE HAYA SELECCIONADO EL AULA

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text('Búsqueda de objetos'),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            margin: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.15),
            width: double.infinity,
            height: 550,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(50), topLeft: Radius.circular(50))
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Selecciona un ala', style: TextStyle(fontSize: 20),),
                DropdownButton(
                  value: 'Seleccionar',
                  items: buildDropdownMenuItems(listaAlas),
                  onChanged: (value){},
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text('Selecciona una planta', style: TextStyle(fontSize: 20),),
                    IconButton(
                      color: Colors.red,
                      icon: Icon(Icons.location_on),
                      onPressed: () {
                        // NOS TIENE QUE LLEVAR A LA PANTALLA DE LOS MAPAS
                      },
                    ),
                  ],
                ),
                DropdownButton(
                  value: 'Seleccionar',
                  items: buildDropdownMenuItems(listaPlantas),
                  onChanged: (value) {},
                ),
                Text('Selecciona un aula', style: TextStyle(fontSize: 20),),
                DropdownButton(
                  value: 'Seleccionar',
                  items: buildDropdownMenuItems(listaAulas),
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
               // Navigator.push(context,
                //    MaterialPageRoute(builder: (context) => Inventario()));
              },
              child: Text('Ver inventario del aula seleccionada'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}