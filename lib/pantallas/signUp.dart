import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tfg_jhb/api_controls.dart';
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
  bool passwordsMatch = true;

  @override
  void initState() {
    super.initState();
    confPassword.addListener(checkPasswordsMatch);
  }

  @override
  void dispose() {
    confPassword.removeListener(checkPasswordsMatch);
    password.dispose();
    confPassword.dispose();
    super.dispose();
  }

  void checkPasswordsMatch() {
    setState(() {
      passwordsMatch = password.text == confPassword.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final nickname = ModalRoute.of(context)!.settings.arguments as String;
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
                "Selecciona una contraseña \nsegura",
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
                  height: 394,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(50), topLeft: Radius.circular(50)),
                  ),
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Contraseña",style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),), //EMAIL
                        SizedBox(height: 15,),
                        TextField(
                          controller: password,
                          obscureText: hide,
                          decoration: InputDecoration(
                            hintText: "1234ñ!*",
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
                        ),
                        if (!passwordsMatch)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              "Las contraseñas no coinciden",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),//Confirmar CONTRASEÑA
                        Center(
                          child: ElevatedButton(
                            child: Text("Registrarse"), //Botón para enviar el formulario, default login
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.amber,
                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 60), //así se ha alargado el botón
                            ),
                            onPressed: passwordsMatch? () async{
                              if(password.text.toString().isEmpty || confPassword.text.toString().isEmpty){
                                Fluttertoast.showToast(msg: "No puedes dejar campos vacíos");
                              } else {
                                var usu = await ApiControls.signUp(nickname, confPassword.text.toString());
                                await Navigator.pushNamed(context, '/mainMenu', arguments: usu);
                                Navigator.pop(context);
                                }
                              }
                                : null, //con esto se deshabilita el botón de registro si las contraseñas no coinciden
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