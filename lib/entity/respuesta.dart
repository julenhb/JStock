class Respuesta{
  late bool resultado;

  Respuesta({
    this.resultado = false
});

  Respuesta.fromParameters(bool resultado){
    this.resultado = resultado;
  }

  factory Respuesta.fromJson(List<dynamic> json) {
    final firstItem = json[0];
    return Respuesta(
        resultado: firstItem['resultado']
    );
  }
}