import 'dart:ffi';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tfg_jhb/api_controls.dart';
import 'package:tfg_jhb/entity/respuesta.dart';
import 'package:tfg_jhb/main.dart';

import '../entity/usuario.dart';
import 'mainmenu.dart';

class CheckLoginPage extends StatefulWidget{
  const CheckLoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CheckLoginPageState();

}

class _CheckLoginPageState extends State<CheckLoginPage> {
  bool hide = true;
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final usu = ModalRoute.of(context)!.settings.arguments as Usuario;

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      backgroundColor: Colors.blue,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 50),
                child: Text("Introduce tu contraseña ${usu.nombre}", style: TextStyle(
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
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      margin: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.15),
                      width: double.infinity,
                      height: 365,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(50), topLeft: Radius.circular(50)),
                      ),
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Introduce tu contraseña",style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),),
                            SizedBox(height: 15,),
                            TextField(
                              controller: password,
                              obscureText: hide,
                              decoration: InputDecoration(
                                hintText: "yoAprobaríaAJulen1234!*",
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
                            Center(
                              child: ElevatedButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.amber,
                                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 60) //así se ha alargado el botón
                                  ),
                                  onPressed: () async {
                                    if (await ApiControls.checkLogin(usu.nickname.toString(), password.text.toString()) == true){
                                      var usu1 = usu;
                                      Navigator.pushNamed(context, '/mainMenu', arguments: usu1);
                                    }else{
                                      Fluttertoast.showToast(
                                        msg: "Contraseña incorrecta",
                                        toastLength: Toast.LENGTH_SHORT, // Duración del toast (Toast.LENGTH_SHORT o Toast.LENGTH_LONG)
                                        gravity: ToastGravity.BOTTOM, // Posición del toast (TOP, BOTTOM, CENTER)
                                        timeInSecForIosWeb: 1, // Duración para iOS y web (en segundos)
                                        backgroundColor: Colors.grey[800], // Color de fondo del toast
                                        textColor: Colors.white, // Color del texto del toast
                                        fontSize: 16.0, // Tamaño de fuente del texto del toast
                                      );
                                    }
                                  }, child: Text("Iniciar sesión")), //Botón para enviar el formulario, default login
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              )
            ],
          )
        ),
      ),
    );
  }
}