import 'package:http/http.dart' as http;
import 'package:tfg_jhb/entity/aula.dart';
import 'package:tfg_jhb/entity/inventario.dart';
import 'package:tfg_jhb/entity/objeto.dart';
import 'package:tfg_jhb/entity/planta.dart';
import 'entity/ala.dart';
import 'dart:convert';
import 'entity/usuario.dart';

class ApiControls{

  //Declaramos una constante que va a contener la url base de nuestra api
  static const String apiUrl = 'http://chiriflus.com:1000';


  //GET
  //Obtenemos todas las alas
  static Future<List<Ala>> getAllAlas() async{
    final response = await http.get(Uri.parse('$apiUrl/ala/all'));        //pasamos la url de la petición

    if(response.statusCode == 200){                                       //CASO CORRECTO
      final jsonData = jsonDecode(response.body) as List<dynamic>;        //Obtenemos un cuerpo JSON
      final alas = jsonData.map((item) => Ala.fromJson(item)).toList();   //Creamos una lista de objetos Ala a partir del JSON
      return alas;
    } else{
      throw Exception('Error al obtener las alas');                       //CASO DE ERROR CONTROLADO
    }
  }


  //Obtenemos todas las plantas
  static Future<List<Planta>> getAllPlantas() async{
    final response = await http.get(Uri.parse('$apiUrl/planta/all'));

    if(response.statusCode == 200){
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      final plantas = jsonData.map((item) => Planta.fromJson(item)).toList();
      return plantas;
    } else{
      throw Exception('Error al obtener las alas');
    }
  }

  //Obtenemos todas las aulas
  static Future<List<Aula>> getAllAulas() async{
    final response = await http.get(Uri.parse('$apiUrl/aula/all'));

    if(response.statusCode == 200){
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      final aulas = jsonData.map((item) => Aula.fromJson(item)).toList();
      return aulas;
    } else{
      throw Exception('Error al obtener las alas');
    }
  }

  //Obtenemos todos los inventarios
  static Future<List<Inventario>> getAllInventarios() async{
    final response = await http.get(Uri.parse('$apiUrl/inventarios/all'));

    if(response.statusCode == 200){
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      final inventarios = jsonData.map((item) => Inventario.fromJson(item)).toList();
      return inventarios;
    } else{
      throw Exception('Error al obtener las alas');
    }
  }

  //Obtener un usuario por su nickname: si no hay un usuario con ese nickname, devuelve un usuario genérico, se coge el id = 0 y ahí habría que establecer la lógica del fallo del login
  static Future<Usuario> getUsuarioByNickname(String nickname) async{
    final response = await http.get(Uri.parse('$apiUrl/user/{$nickname}'));

    if(response.statusCode == 200){
      final jsonData = jsonDecode(response.body);
      final usuario = Usuario.fromJson(jsonData);
      return usuario;
    } else{
      throw Exception('Error: No se pudo obtener el usuario');
    }
  }

  //Comprobación del login:
  //La respuesta a esta solicitud devuelve un json 'respuesta', con valor true o false, por lo tanto el método debe devolver un tipo boolean
  static Future<bool> checkLogin(String nickname, String pwd) async{
    final response = await http.get(Uri.parse('$apiUrl/user/login/{$nickname}/{$pwd}'));      //enviamos el nickname y la contraseña

    if(response.statusCode == 200){                               //CASO CORRECTO
      final jsonData = jsonDecode(response.body);
      final respuesta = jsonData['respuesta'] as bool?;           //Otenemos la respuesta
      return respuesta ?? false;                                  //las interrogaciones es por control de nulos
    } else{
      throw Exception('Error: No se pudo verificar el inicio de sesión');
    }
  }




  //POST

  //Registro de un nuevo usuario
  static Future<Usuario> signUp(String nickname, String pwd) async{
    final response = await http.post(Uri.parse('$apiUrl/user/signup/{$nickname}/{$pwd}'));  //creo el usuario en BD con el post

    if(response.statusCode == 200){
      final jsonData = jsonDecode(response.body);                     //recupero el usuario creado
      final usuario = Usuario.fromJson(jsonData);
      return usuario;
    } else{
      throw Exception('Error: no se pudo proceder al registro del nuevo usuario');
    }
  }

}