import 'package:dio/dio.dart';
import 'package:dio_mini/data/network/client/network_client.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RegisterDataModule {

  // הזרקה של Dio על ידי שליפת הדיאו מתוך ה-NetworkClient
  // ה-NetworkClient עצמו יוזרק כאן אוטומטית על ידי Injectable
  @factoryMethod
  Dio getDio(NetworkClient networkClient) => networkClient.dio;
}