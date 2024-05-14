import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<List<BiometricType>> hasBiometrics() async {
    try {
      final checkBiometrics = await _auth.canCheckBiometrics;
      if (checkBiometrics) {
        List<BiometricType> availableBiometrics =
            await _auth.getAvailableBiometrics();
        debugPrint(availableBiometrics.toString());
        return availableBiometrics;
      }
      return [];
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  static Future<bool> authenticate() async {
    final availableBiometrics = await hasBiometrics();

    try {
      if (availableBiometrics.contains(BiometricType.fingerprint) ||
          availableBiometrics.contains(BiometricType.strong)) {
        final autent = await _auth.authenticate(
            authMessages: const <AuthMessages>[
              AndroidAuthMessages(
                  signInTitle: 'Ingrese Huella Digital',
                  biometricHint: 'Verificacion Requerida'),
            ],
            localizedReason: 'Ingrese su huella en el sensor',
            options: const AuthenticationOptions(
                useErrorDialogs: true, stickyAuth: false));
        return autent;
      }
      if (availableBiometrics.contains(BiometricType.face) ||
          availableBiometrics.contains(BiometricType.weak)) {
        final autent = await _auth.authenticate(
            authMessages: const <AuthMessages>[
              AndroidAuthMessages(
                  signInTitle: 'Ingrese su rostro',
                  biometricHint: 'Verificacion Requerida'),
            ],
            localizedReason: 'Ingrese su rostro en el sensor',
            options: const AuthenticationOptions(
                useErrorDialogs: true, stickyAuth: false));
        return autent;
      }
      return false;
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
