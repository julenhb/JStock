class Aula{
  late int id;
  late String nombre;
  late int idPlanta;
  late int numObjetos;

  Aula({
   this.id = 0,
   this.nombre = "",
   this.idPlanta = 0,
   this.numObjetos = 0,
});

  Aula.fromParameters(int id, String nombre, int idPlanta, int numObjetos){
    this.id = id;
    this.nombre = nombre;
    this.idPlanta = idPlanta;
    this.numObjetos = numObjetos;
  }

  factory Aula.fromJson(Map<String, dynamic> json){
    return Aula(id: json['id'], nombre: json['nombre']);
  }

}