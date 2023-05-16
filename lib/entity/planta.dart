class Planta{
  late int id;
  late String nombre;
  late int idAla;
  late String mapa;

  Planta({
    this.id = 0,
    this.nombre = "",
    this.idAla = 0,
    this.mapa = "",
});

  Planta.fromParameters(int id, String nombre, int idAla, String mapa){
    this.id = id;
    this.nombre = nombre;
    this.idAla = idAla;
    this.mapa = mapa;
  }

  factory Planta.fromJson(Map<String, dynamic> json){
    return Planta(id: json['id'], nombre: json['nombre'], idAla: json['idAla'], mapa: json['mapa']);
  }
}