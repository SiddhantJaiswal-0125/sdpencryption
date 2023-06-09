import 'dart:io';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:file_saver/file_saver.dart';
import 'package:firebaseencrytion/Utils/Utility.dart';

import 'package:path_provider/path_provider.dart';
class FileEcryptionApi {
  static Future<keyDataStructure?> encryptFile(data, key1) async {
    Key key = Key.fromSecureRandom(16);
    IV iv = IV.fromLength(16);


    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    Utility.customlogger("KEY IS : ${key.base64}:endofline");
    Utility.customlogger("iv is ${iv.base64}:endofline");
    IV iv2 = IV.fromBase64(iv.base64);
    Utility.customlogger("CHECKING THE VALUE ${iv2.base64}");

    final encryptedFile = encrypter.encryptBytes(data, iv: iv);


    keyDataStructure kds  = keyDataStructure(encryptedFile.bytes, key.base64, iv.base64);
    return kds;
  }

  static void test(File doc) async {
    final result = await FileEcryptionApi.encryptFile(
        doc!.readAsBytesSync(), 14); //Changing the file into a list of bytes

    bool isEncrypting = true;
    String fileName = "sid";
    await FileSaver.instance //Saving the encrypted document to local storage
        .saveAs(fileName, result!.data, "aes", MimeType.OTHER)
        .whenComplete(() {
      isEncrypting = false;

    });
  }


  static Future<File> decrypter( file, String key1,String  iv1) async
  {

    Key key = Key.fromBase64(key1);
    IV iv = IV.fromBase64(iv1);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    List<int> decryptededdata =  encrypter.decryptBytes(file, iv: iv);
    final dir = await getApplicationDocumentsDirectory();
    var file2 = File('${dir.path}/testing.pdf');
    await file2.writeAsBytes(decryptededdata, flush: true);
   return  file2;
  }
}
class keyDataStructure
{
  final Uint8List data;
 final String key;
 final String iv;

  keyDataStructure(this.data, this.key, this.iv);

}
