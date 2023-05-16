class Etiqueta{
  late int registro;
  late int idObjeto;

  Etiqueta({
    this.registro = 0,
    this.idObjeto = 0,
});

  Etiqueta.fromParameters(int registro, int idObjeto){
    this.registro = registro;
    this.idObjeto = idObjeto;
  }

  factory Etiqueta.fromJson(Map<String, dynamic> json){
    return Etiqueta(registro: json['registro'], idObjeto: json['idObjeto']);
  }
}