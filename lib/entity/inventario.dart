class Inventario{
  late int id;
  late String nombre;

  Inventario({
    this.id = 0,
    this.nombre = "",        //Aquí es required, puesto que no puede ser nulo (si no se pone ni requiered ni ? da error)
});

  Inventario.fromParameters(int id, String nombre){
    this.id = id;
    this.nombre = nombre;
  }

  factory Inventario.fromJson(Map<String, dynamic> json){
    return Inventario(id: json['id'], nombre: json['nombre']);
  }
}