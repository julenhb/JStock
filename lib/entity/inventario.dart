class Inventario{
  late int id;
  late String nombre;
  late DateTime fecha;

  Inventario({
    this.id = 0,
    this.nombre = "",
    required DateTime fecha,        //Aquí es required, puesto que no puede ser nulo (si no se pone ni requiered ni ? da error)
}) : this.fecha = DateTime.now();

  Inventario.fromParameters(int id, String nombre, DateTime fecha){
    this.id = id;
    this.nombre = nombre;
    this.fecha = fecha;
  }

  factory Inventario.fromJson(Map<String, dynamic> json){
    return Inventario(id: json['id'], nombre: json['nombre'], fecha: json['fecha']);
  }
}