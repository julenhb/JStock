
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tfg_jhb/entity/inventario.dart';
import 'package:tfg_jhb/entity/usuario.dart';
import 'package:tfg_jhb/pantallas/general_stock.dart';
import 'package:tfg_jhb/pantallas/itemsearch.dart';
import 'package:tfg_jhb/pantallas/login.dart';
import 'package:tfg_jhb/pantallas/mainmenu.dart';
import 'package:tfg_jhb/pantallas/room_item_search.dart';
import 'package:tfg_jhb/pantallas/room_stock.dart';
import 'package:tfg_jhb/pantallas/scanner.dart';
import 'package:tfg_jhb/pantallas/signUp.dart';
import 'package:http/http.dart';
import 'package:tfg_jhb/api_controls.dart';
import 'package:tfg_jhb/pantallas/usersignup.dart';

import 'entity/planta.dart';

void main (){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
    routes: {
      '/loginPage': (context) => LoginPage(),
      '/checkLoginPage': (context) => CheckLoginPage(),
      '/userSignUpPage': (context) => UserSignUpPage(),
      '/signUpPage': (context) => RegistroPage(),
      '/mainMenu': (context) => MainMenu(),
      '/itemSearch': (context) => ItemSearch(),
      '/roomItemSearch': (context) => RoomItemSearch(),
      '/roomStock': (context) => RoomStock(),
      '/allStock': (context) => GeneralStock(),
      '/scanTag': (context) => ScannerScreen(),
    },
  ));
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hide = true;
  TextEditingController nick = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body:SingleChildScrollView(
        child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 20),
            child: Text("Bienvenido \nde nuevo", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w300),),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            margin: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.23),
            width: double.infinity,
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(50), topLeft: Radius.circular(50))
            ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Inicia sesión",style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),),
                  SizedBox(height: 15,),
                  TextField (
                    controller: nick,
                    decoration: InputDecoration(
                      hintText: "Nickname (jhberja, chema, jose...)",
                    ),
                  ), //EMAIL
                  Center(
                    child: ElevatedButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.amber,
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 60) //así se ha alargado el botón
                        ),
                        onPressed: () async {
                          if(nick.text.toString().isEmpty){
                            Fluttertoast.showToast(msg: "No puedes dejar campos vacíos");
                          } else {
                            var usu = await ApiControls.getUsuarioByNickname(
                                nick.text.toString());

                            if (usu.id != 0) {
                              Navigator.pushNamed(context, '/checkLoginPage',
                                  arguments: usu); //ASÍ NOS MOVEMOS ENTRE PANTALLAS PARA LLEVAR OBJETOS
                              nick.text = "";
                            } else {
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                  title: Text("Error de credenciales"),
                                  content: Text(
                                      "El nickname que has introducido no existe :("),
                                );
                              },
                              );
                            }
                          }
                        },
                        child:
                          Text("Siguiente")), //Botón para enviar el formulario, default login
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("¿No estás registrado todavía?"),
                      TextButton(onPressed: (){
                        Navigator.pushNamed(context, '/userSignUpPage');
                        nick.text = "";
                      }, child: Text("Regístrate"))
                    ],
                  ),
                ],
              )
          )
        ],
        ),
      ) ,
    );
  }
}


