import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MaterialApp(home: FotoAPdfApp()));
}

class FotoAPdfApp extends StatefulWidget {
  @override
  _FotoAPdfAppState createState() => _FotoAPdfAppState();
}

class _FotoAPdfAppState extends State<FotoAPdfApp> {
  final picker = ImagePicker();
  Uint8List? _imagenWeb;

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      Uint8List bytes = await pickedFile.readAsBytes();
      setState(() {
        _imagenWeb = bytes;
      });
      convertirAPdf(bytes);
    } else {
      print('No se seleccionó ninguna imagen.');
    }
  }

  Future<void> convertirAPdf(Uint8List imageData) async {
    final pdf = pw.Document();
    final image = pw.MemoryImage(imageData);

    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Center(child: pw.Image(image));
    }));

    try {
      final directory = await getExternalStorageDirectory();
      print('pruebas');
      final file = File("${directory!.path}/DocumetosAcuses/imagen.pdf");
      print('pruebass1');
      await file.create(recursive: true);
      print('pruebasss12');
      await file.writeAsBytes(await pdf.save());
      print('pruebando');
      print('PDF Guardado en ${file.path}');
    } catch (e) {
      print("Error al guardar PDF: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Foto a PDF'),
      ),
      body: Center(
        child: _imagenWeb == null
            ? Text('No se ha seleccionado ninguna imagen.')
            : Image.memory(_imagenWeb!),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Capturar Imagen',
        child: Icon(Icons.add_a_photo),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// import 'dart:typed_data';
// import 'dart:html' as html;
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:path_provider/path_provider.dart';
//
// void main() {
//   runApp(MaterialApp(home: FotoAPdfApp()));
// }
//
// class FotoAPdfApp extends StatefulWidget {
//   @override
//   _FotoAPdfAppState createState() => _FotoAPdfAppState();
// }
//
// class _FotoAPdfAppState extends State<FotoAPdfApp> {
//   final picker = ImagePicker();
//   Uint8List? _imagenWeb;
//
//   Future getImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedFile != null) {
//       Uint8List bytes = await pickedFile.readAsBytes();
//       setState(() {
//         _imagenWeb = bytes;
//       });
//       convertirAPdf(bytes);
//     } else {
//       print('No se seleccionó ninguna imagen.');
//     }
//   }
//   Future<void> convertirAPdf(Uint8List imageData) async {
//     final pdf = pw.Document();
//     final image = pw.MemoryImage(imageData);
//
//     pdf.addPage(pw.Page(build: (pw.Context context) {
//       return pw.Center(child: pw.Image(image));
//     }));
//
//     try {
//       final bytes = await pdf.save();
//       final blob = html.Blob([bytes], 'application/pdf');
//       final url = html.Url.createObjectUrlFromBlob(blob);
//       html.window.open(url, "_blank");
//       html.Url.revokeObjectUrl(url);
//     } catch (e) {
//       print("Error al crear PDF: $e");
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Foto a PDF'),
//       ),
//       body: Center(
//         child: _imagenWeb == null
//             ? Text('No se ha seleccionado ninguna imagen.')
//             : Image.memory(_imagenWeb!),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: getImage,
//         tooltip: 'Capturar Imagen',
//         child: Icon(Icons.add_a_photo),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
// }
