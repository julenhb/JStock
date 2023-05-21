class Objeto {
  late int id;
  late String nombre;
  late String descripcion;
  late String numSerie;
  late int categoria;
  late String motivoAlta;
  late DateTime fechaAlta;
  late DateTime fechaBaja;
  late double precio;
  late String proveedor;
  late int idAula;

  Objeto({
    this.id = 0,
    this.nombre = "",
    this.descripcion = "",
    this.numSerie = "",
    this.categoria = 0,
    this.motivoAlta = "",
    DateTime? fechaAlta,
    DateTime? fechaBaja,              //En este caso los campos de fechas pueden ser nulos, por lo tanto se utiliza el ?
    this.precio = 0.0,
    this.proveedor = "",
    this.idAula = 0,
  }) : fechaAlta = fechaAlta ?? DateTime.now(),
        fechaBaja = fechaBaja ?? DateTime.now();

  Objeto.fromParameters(int id, String nombre, String descripcion, String numSerie, int categoria, String motivoAlta,
      DateTime fechaAlta, DateTime fechaBaja, double precio, String proveedor, int idAula,) {
    this.id = id;
    this.nombre = nombre;
    this.descripcion = descripcion;
    this.numSerie = numSerie;
    this.categoria = categoria;
    this.motivoAlta = motivoAlta;
    this.fechaAlta = fechaAlta;
    this.fechaBaja = fechaBaja;
    this.precio = precio;
    this.proveedor = proveedor;
    this.idAula = idAula;
  }

  /*
  factory Objeto.fromJson(Map<String, dynamic> json){
    return Objeto(id: json['id'], nombre: json['nombre'], descripcion: json['descripcion'], numSerie: json['numSerie'], categoria: json['categoria'],
        motivoAlta: json['motivoAlta'], fechaAlta: json['fechaAlta'], fechaBaja: json['fechaBaja'], precio: json['precio'], proveedor: json['proveedor'],
        idAula: json['idAula']);
  }*/
  factory Objeto.fromJson(Map<String, dynamic> json){
    return Objeto(id: json['id'], nombre: json['nombre'], numSerie: json['numserie']);
  }

  factory Objeto.fromInventario(Map<String, dynamic> json){  //PARA EL INVENTARIO GENERAL
    return Objeto(id: json['id'], nombre: json['nombre']);
  }
}