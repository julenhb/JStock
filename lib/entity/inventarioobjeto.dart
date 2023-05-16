class InventarioObjeto{
  late int id;
  late int idInventario;
  late int idObjeto;
  late int idAula;
  late int idUsuario;
  late DateTime fechaRegistro;

  InventarioObjeto({
    this.id = 0,
    this.idInventario = 0,
    this.idObjeto = 0,
    this.idAula = 0,
    this.idUsuario = 0,
    required DateTime fechaRegistro
}) : this.fechaRegistro = DateTime.now();

  InventarioObjeto.fromParameters(int id, int idInventario, int idObjeto, int idAula, int idUsuario, DateTime fechaRegistro){
    this.id = id;
    this.idInventario = idInventario;
    this.idObjeto = idObjeto;
    this.idAula = idAula;
    this.idUsuario = idUsuario;
    this.fechaRegistro = fechaRegistro;
  }

  factory InventarioObjeto.fromJson(Map<String, dynamic> json){
    return InventarioObjeto(id: json['id'], idInventario: json['idInventario'], idObjeto: json['idObjeto'], idAula: json['idAula'], idUsuario: json['idUsuario'],
                            fechaRegistro: json['fechaRegistro']);
  }
}