import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;


/******
 *
 *
 *
 *
 *
 * ESTO ESTÁ HECHO CON CHATGPT,
 * TENGO QUE ENTENDERLO MEJOR,
 * SOBRE TODO LA PARTE DEL MANEJO DE
 * LAS SINCRONÍAS Y DEMÁS, DE MOMENTO
 * SÉ QUE ME DEJA SACAR UNA FOTO, ESTOY IMPLEMENTANDO
 * QUE HAYA UNA VISTA PREVIA DE LO QUE ESTÁ CAPTANDO LA CÁMARA.
 *
 * ANTES DE ABRIR ESTA PANTALLA, SI ES LA PRIMERA VEZ,
 * SE PIDEN PERMISOS PARA PODER GRABAR ETC.
 *
 *
 *
 *
 *
 */



Future<CameraDescription> _getCamera() async {
  final cameras = await availableCameras();
  return cameras.first;
}

class ScanTag extends StatefulWidget {
  const ScanTag({Key? key}) : super(key: key);

  @override
  _ScanTagState createState() => _ScanTagState();
}

class _ScanTagState extends State<ScanTag> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    log("Pasa antes de la línea 53");
    _initializeCamera();
    log("Pasa antes de la línea 54");
  }

  void _initializeCamera() async {
    log("PATATAS CON QUESO PATATAS CON QUESOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");
    var camera = await _getCamera();
    _controller = CameraController(camera, ResolutionPreset.medium);
    log(_controller.toString());
    _initializeControllerFuture = _controller.initialize();
    log("bOBNAOSODFSAFIFAFADF");

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan Screen')),
      body: Container(
        color: Colors.black,
        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final size = MediaQuery.of(context).size;
              final deviceRatio = size.width / size.height;
              return Center(
                child: Transform.scale(
                  scale: _controller.value.aspectRatio / deviceRatio,
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: CameraPreview(_controller),
                    ),
                  ),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}