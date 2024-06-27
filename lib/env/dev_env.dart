import 'env.dart';

class DevEnv extends Env {
  @override
  String domain = "http://localhost:55454/";

  @override
  String hostUrlAuth = "http://192.168.5.57:8007/";

  @override
  String hostUrlChat = "http://192.168.5.57:8009/";

  @override
  String socketUrl = "//192.168.5.57:8009/";

}