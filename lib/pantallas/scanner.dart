import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tfg_jhb/api_controls.dart';
import 'package:tfg_jhb/entity/objeto.dart';

import '../entity/aula.dart';
import '../entity/inventario.dart';
import '../entity/usuario.dart';

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
    final tagPack = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    final Usuario user = tagPack[2];
    final Inventario stock = tagPack[1];
    final Aula aula = tagPack[0];

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
          if(etiqueta != null){
            final obTag = await ApiControls.getObjetosByTag(etiqueta);
            //Objeto obTag = Objeto.fromScan(params[0], params[1], params[7], params[8], params[12]);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Información del objeto'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Nombre: ${obTag.nombre}'),
                      Text('Nº de serie: ${obTag.numSerie}'),
                      Text('Precio: ${obTag.precio}€'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: Text('Cancelar'),
                      onPressed: () {
                        Navigator.of(context).pop(); // Cierro el dialog
                      },
                    ),
                    TextButton(
                      child: Text('Inventariar'),
                      onPressed: () async {
                        final conteo = await ApiControls.countItem(obTag.id, stock.id, aula.id, user.id);
                        if(conteo){
                          Fluttertoast.showToast(
                            msg: 'El objeto ya está inventariado',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.grey[800],
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          Navigator.of(context).pop();
                        } else{
                          _showConfirmationDialog(obTag, stock.id, aula.id, user.id);
                        }
                      },
                    ),
                  ],
                );
              },
            );
          }else{
            print(null);
          }

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


  Future<int?> leerEtiqueta(InputImage inputImage) async {
    try {
      final lector = TextRecognizer();
      final etiqueta = await lector.processImage(inputImage);
      final regex = RegExp(r'Registro (\d+)'); //con el \d+ le digo que va a ver uno o más números y lo guardamos entre paréntesis como grupo

      final match = regex.firstMatch(etiqueta.text);

      if (match != null) {
        final int numeros = int.parse(match.group(1).toString());  //obtenemos sólo los números
        return numeros;
      }else{
        Fluttertoast.showToast(
          msg: "No se encontró ninguna etiqueta",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[800],
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }

      return null;
    } catch (e) {
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

  //DIÁLOGO DE ACTUALIZACIÓN
  Future<void> _showConfirmationDialog(Objeto obj, int idInventario, int idAula, int idUsuario) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Objeto ya inventariado'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('El objeto ya está en el inventario,'),
                Text('¿quieres actualizar su información?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Actualizar'),
              onPressed: () async {
                final updated = await ApiControls.updateItem(obj.id, idInventario, idAula, idUsuario);
                if(updated){
                  Fluttertoast.showToast(
                    msg: "${obj.nombre} actualizado",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey[800],
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }else{
                  Fluttertoast.showToast(
                      msg: "No se pudo actualizar",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey[800],
                      textColor: Colors.white,
                      fontSize: 16.0,
                  );
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
