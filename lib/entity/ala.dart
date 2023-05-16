class Ala{
  late int id;
  late String nombre;

  Ala({                   //CONSTRUCTOR VACÍO
    this.id = 0,
    this.nombre = "",
  });

  Ala.fromParameters(int id, String nombre){        //CONSTRUCTOR PARAMETRIZADO
    this.id = id;
    this.nombre = nombre;
  }

  factory Ala.fromJson(Map<String, dynamic> json){          //RECOGOJO EL JSON DE LA API Y LO MAPEO
    return Ala(id: json['id'], nombre: json['nombre']);
  }
}