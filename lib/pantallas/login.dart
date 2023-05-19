import 'dart:ffi';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
                            Text("Únete",style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),),
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
                                      print("está cascando");
                                    }
                                  }, child: Text("Iniciar sesión")), //Botón para enviar el formulario, default login
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
                )
              )
            ],
          )
        ),
      ),
    );
  }
}