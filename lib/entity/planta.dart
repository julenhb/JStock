class Planta{
  late int id;
  late String nombre;
  late int idAla;

  Planta({
    this.id = 0,
    this.nombre = "",
    this.idAla = 0
});

  Planta.fromParameters(int id, String nombre, int idAla){
    this.id = id;
    this.nombre = nombre;
    this.idAla = idAla;
  }

  factory Planta.fromJson(Map<String, dynamic> json){
    return Planta(id: json['id'], nombre: json['nombre'], idAla: json['idAla']);
  }
}