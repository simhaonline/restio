import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:ip/ip.dart';
import 'package:restio/src/encodings.dart';

Encoding obtainEncodingByName(
  String name, [
  Encoding defaultValue = utf8,
]) {
  final encoding = Encoding.getByName(name);
  if (encoding == null) {
    name = name?.toLowerCase();
    if (name == 'utf-16') {
      return utf16;
    }

    if (name == 'utf-16le') {
      return utf16le;
    }

    if (name == 'utf-16be') {
      return utf16be;
    }

    if (name == 'utf-32') {
      return utf32;
    }

    return defaultValue;
  } else {
    return encoding;
  }
}

final _random = Random();
const _allowedChars = 'abcdefghijklmnopqrstuvwxyz0123456789';

String generateNonce(int length) {
  final nonce = StringBuffer('');

  for (var i = 0; i < length; i++) {
    nonce.write(_allowedChars[(_random.nextInt(_allowedChars.length))]);
  }

  return nonce.toString();
}

Future<List<int>> readAsBytes(Stream<List<int>> source) {
  final completer = Completer<List<int>>();

  final sink = ByteConversionSink.withCallback(completer.complete);

  source.listen(
    sink.add,
    onError: completer.completeError,
    onDone: sink.close,
    cancelOnError: true,
  );

  return completer.future;
}

bool isIp(String ip) {
  try {
    return IpAddress.parse(ip) != null;
  } catch (e) {
    return false;
  }
}
