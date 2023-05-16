class Proveedor{
  late int id;
  late String nombre;

  Proveedor({
    this.id = 0,
    this.nombre = "",
});

  Proveedor.fromParameters(int id, String nombre){
    this.id = id;
    this.nombre = nombre;
  }

  factory Proveedor.fromJson(Map<String, dynamic> json){
    return Proveedor(id: json['id'], nombre: json['nombre']);
  }
}