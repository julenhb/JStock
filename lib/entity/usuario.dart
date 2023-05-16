class Usuario{
  late int id;
  late String nickname;
  late String nombre;
  late String pwd;
  late int admn;
  late int activo;

  Usuario({
    this.id = 0,
    this.nickname = "",
    this.nombre = "",
    this.pwd = "",
    this.admn = 0,
    this.activo = 0,
});

  Usuario.fromParameters(int id, String nickname, String nombre, String pwd, int admn, int activo){
    this.id = id;
    this.nickname = nickname;
    this.nombre = nombre;
    this.pwd = pwd;
    this.admn = admn;
    this.activo = activo;
  }

  factory Usuario.fromJson(Map<String, dynamic> json){
    return Usuario(id: json['id'], nickname: json['nickname'], nombre: json['nombre'], pwd: json['pwd'], admn: json['admn'], activo: json['activo']);
  }
}