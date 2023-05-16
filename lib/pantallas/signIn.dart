import 'package:flutter/material.dart';
import 'package:tfg_jhb/main.dart';

import 'mainmenu.dart';

class RegistroPage extends StatefulWidget {
  const RegistroPage({Key? key}) : super(key: key);

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  bool hide = true;
  TextEditingController password = TextEditingController();
  TextEditingController confPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 40),
              child: Text(
                "Siempre es bueno \n recibir nuevos \n miembros",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  margin: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.17),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(50), topLeft: Radius.circular(50)),
                  ),
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Únete",style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),),
                        SizedBox(height: 15,),
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Dirección de correo electrónico",
                          ),
                        ), //EMAIL
                        SizedBox(height: 15,),
                        TextField(
                          controller: password,
                          obscureText: hide,
                          decoration: InputDecoration(
                            hintText: "Contraseña",
                            suffixIcon: IconButton(
                              onPressed: (){
                                setState(() {
                                  hide = !hide;
                                });
                              },
                              icon:hide?Icon(Icons.visibility_off):Icon(Icons.visibility),
                            ),
                          ),
                        ), //CONTRASEÑA
                        SizedBox(height: 15,),
                        TextField(
                          controller: confPassword,
                          obscureText: hide,
                          decoration: InputDecoration(
                            hintText: "Confirmar contraseña",
                            suffixIcon: IconButton(
                              onPressed: (){
                                setState(() {
                                  hide = !hide;
                                });
                              },
                              icon:hide?Icon(Icons.visibility_off):Icon(Icons.visibility),
                            ),
                          ),
                        ), //Confirmar CONTRASEÑA
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: (){},
                            child: Text("¿Olvidaste tu contraseña?"),
                          ),
                        ),
                        Center(
                          child: ElevatedButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.amber,
                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 60), //así se ha alargado el botón
                            ),
                            onPressed: (){
                              if(password.text != confPassword.text){
                                showDialog(
                                  context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      title: Text("Mensajes"),
                                      content: Text("Las contraseñas no coinciden"),
                                    );
                                  },
                                );
                              }else{
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>MainMenu()));
                              }
                            },
                            child: Text("Registrarse"), //Botón para enviar el formulario, default login
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left:20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("¿Ya tienes una cuenta con nosotros?"),
                            TextButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                              },
                              child: Text("Inicia sesión"),
                            ),
                          ],
                        ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ),
        ],
      ),
      ),
      ),
    );
  }
}