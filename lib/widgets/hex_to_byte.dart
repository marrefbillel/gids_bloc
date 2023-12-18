import 'dart:typed_data';

Uint8List hexToBytes(String hex) {
  hex = hex.replaceAll(' ', '');
  return Uint8List.fromList(List<int>.generate(hex.length ~/ 2,
      (i) => int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16)));
}
