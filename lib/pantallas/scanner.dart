import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}


enum WidgetState {NONE, LOADING, LOADED, ERROR}



class _ScannerScreenState extends State<ScannerScreen> {
  WidgetState _widgetState = WidgetState.NONE;  //declaramos cuatro estados posibles para nuestro widget
  List<CameraDescription> _cameras = <CameraDescription>[]; //va a trabajar con la variable available cameras (básicamente recogerá las cámaras del dispositivo)
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    switch(_widgetState){
      case WidgetState.NONE:
      case WidgetState.LOADING:
        return _buildScaffold(context, Center(                      //mandamos al método que hicimos para generar la interfaz el círculo de carga como cuerpo
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
            )
        ));

      case WidgetState.LOADED:
        return _buildScaffold(context, CameraPreview(_cameraController));

      case WidgetState.ERROR:
        return _buildScaffold(context, Center(
            child: Text("Error: La cámara no se pudo inicializar, reinicia la aplicación")
        ));
    }
  }


  //MÉTODO AL QUE SE LLAMARÁ PARA CARGAR LA INTERFAZ (EL SCAFFOLD)
  Widget _buildScaffold(BuildContext context, Widget body){
    return Scaffold(
      appBar: AppBar(
        title: Text('JScaner'),
        backgroundColor: Colors.transparent,   //el background se deja transparente porque la cámara va a ocupar casi toda la pantalla
        elevation: 0, //se le quita la sombra
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final xfile = await _cameraController.takePicture(); //takePicture es asíncrono también //me va a devolver un xfile
          final imagen = InputImage.fromFilePath(xfile.path);
          final etiqueta = await leerEtiqueta(imagen);

          Fluttertoast.showToast(
            msg: etiqueta.toString(),
            toastLength: Toast.LENGTH_SHORT, // Duración del toast (Toast.LENGTH_SHORT o Toast.LENGTH_LONG)
            gravity: ToastGravity.BOTTOM, // Posición del toast (TOP, BOTTOM, CENTER)
            timeInSecForIosWeb: 1, // Duración para iOS y web (en segundos)
            backgroundColor: Colors.grey[800], // Color de fondo del toast
            textColor: Colors.white, // Color del texto del toast
            fontSize: 16.0, // Tamaño de fuente del texto del toast
          );
        },
        child: Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,     //se coloca el floating button abajo
    );
  }


  Future<String?> leerEtiqueta(InputImage inputImage) async {
    try{
      final lector = TextRecognizer();
      final resultado = await lector.processImage(inputImage);
      return resultado.text;
    }catch (e){
      return null;
    }
  }

  //INICIALIZACIÓN DE LA CÁMARA, DURANTE ESTA, EL WIDGET ESTARÁ CARGANDO
  Future initializeCamera() async {
    _widgetState = WidgetState.LOADING; //cambiamos el estado del widget como cargando

    if(mounted) setState((){});//comprobamos si ya se ha cargado (montado) gracias a esta función propia de widgetsate

    try{
    _cameras = await availableCameras();                     //available cameras devuelve un Future, así que tengo que añadir el async y el await
    _cameraController = new CameraController(_cameras[0], ResolutionPreset.ultraHigh);         //asignamos la cámara que utilizaremos y la resolución

    await _cameraController.initialize();           //la funcion initialize() también es asíncrona

    if(_cameraController.value.hasError) {
      _widgetState = WidgetState.ERROR; //Si ha habido algún error durante la carga, cambiamos el estado del widget a ERROR
      } else { //Si no hubo ningún error durante la carga, seteamos el estado a cargado (LOADED)
      _widgetState = WidgetState.LOADED;
    }
    } catch (e) {
      _widgetState = WidgetState.ERROR;
    }

    if(mounted) setState(() {});
  }
}
