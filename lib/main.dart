import 'package:flutter/material.dart';
import 'package:tfg_jhb/mainmenu.dart';
import 'package:tfg_jhb/signIn.dart';

void main (){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
  ));
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hide = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body:Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 20),
            child: Text("Bienvenido \nde nuevo", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w300),),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
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
                  Text("Inicia sesión",style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),),
                  SizedBox(height: 15,),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Dirección de correo electrónico",

                    ),
                  ), //EMAIL
                  SizedBox(height: 15,),
                  TextField(
                      obscureText: hide,
                    decoration: InputDecoration(
                      hintText: "Contraseña",
                      suffixIcon: IconButton(onPressed: (){
                        setState(() {
                          hide = !hide;
                        });
                      }, icon:hide?Icon(Icons.visibility_off):Icon(Icons.visibility),)
                    ),
                  ), //CONTRASEÑA
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(onPressed: (){}, child: Text("¿Olvidaste tu contraseña?"),),
                  ),
                  Center(
                    child: ElevatedButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.amber,
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 60) //así se ha alargado el botón
                        ),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>MainMenu()));
                        }, child: Text("Iniciar sesión")), //Botón para enviar el formulario, default login
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("¿No estás registrado todavía?"),
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> RegistroPage()));
                      }, child: Text("Regístrate"))
                    ],
                  )
                ],
              )
          )
        ],
      ) ,
    );
  }
}


