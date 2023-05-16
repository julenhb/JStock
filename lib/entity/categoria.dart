class Categoria{
  late int id;
  late String nombre;

  Categoria({
    this.id = 0,
    this.nombre = "",
});

  Categoria.fromParameters(int id, String nombre){
    this.id = id;
    this.nombre = nombre;
  }

  factory Categoria.fromJson(Map<String, dynamic> json){
    return Categoria(id: json['id'], nombre: json['nombre']);
  }
}