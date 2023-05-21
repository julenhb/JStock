import 'package:flutter/material.dart';
import 'package:tfg_jhb/main.dart';

import '../api_controls.dart';

class UserSignUpPage extends StatefulWidget {
  const UserSignUpPage({Key? key}) : super(key: key);

  @override
  State<UserSignUpPage> createState() => _UserSignUpPageState();
}

class _UserSignUpPageState extends State<UserSignUpPage> {
  bool hide = true;
  TextEditingController nick = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body:Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 20),
            child: Text("¡Nos encanta tener \n gente nueva!", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w300),),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              margin: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.45),
              width: double.infinity,
              height: 450,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(50), topLeft: Radius.circular(50))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Elige un nickname",style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),),
                  SizedBox(height: 15,),
                  TextField (
                    controller: nick,
                    decoration: InputDecoration(
                      hintText: "jhberja, chema, jose...",
                    ),
                  ), //EMAIL
                  Center(
                    child: ElevatedButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.amber,
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 60) //así se ha alargado el botón
                        ),
                        onPressed: () async {
                          if(nick.text.toString().isEmpty){         //CONTROL NICKNAME NULO
                            showDialog(context: context, builder: (context){
                              return AlertDialog(
                                title: Text("Nickname vacío"),
                                content: Text("No puedes dejar vacío el nickname"),
                              );
                            },
                          );
                            } else {
                              //CONTROL DE USUARIO EXISTENTE
                              var uExistente = await ApiControls.getUsuarioByNickname(nick.text.toString());
                              if(uExistente.id != 0) {
                                showDialog(context: context, builder: (context){
                                    return AlertDialog(
                                      title: Text("Usuario existente"),
                                      content: Text("El nickname que has elegido ya existe :("),
                                    );
                                  },
                                );
                            } else if (uExistente.id == 0){
                              var nickname = nick.text.toString();
                              Navigator.pushNamed(context, '/signUpPage', arguments: nickname);   //ME LLEVO EL NICKNAME PARA USARLO EN EL REGISTRO
                              print(nickname);
                            }
                          }
                        },
                        child:
                        Text("Siguiente")), //Botón para enviar el formulario, default login
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("¿Ya tienes una cuenta?"),
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                      }, child: Text("Inicia sesión"))
                    ],
                  ),
                ],
              )
          )
        ],
      ) ,
    );
  }
}