class Usuario{
  late int id;
  late String nickname;
  late String nombre;
  late String pwd;
  late bool admn;
  late bool activo;

  Usuario({
    this.id = 0,
    this.nickname = "",
    this.nombre = "",
    this.pwd = "",
    this.admn = false,
    this.activo = false,
});

  Usuario.fromParameters(int id, String nickname, String nombre, String pwd, bool admn, bool activo){
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

  factory Usuario.fromJsonById(List<dynamic> json) {
    final firstItem = json[0];
    return Usuario(
      id: firstItem['id'],
      nickname: firstItem['nickname'],
      nombre: firstItem['nombre'],
      pwd: firstItem['pwd'],
      admn: firstItem['admin'],
      activo: firstItem['activo']
    );
  }

}