import 'package:flutter/material.dart';
import 'screens/cep_list_screen.dart';
import 'services/parse_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const String appId = 'YOUR_BACK4APP_APP_ID';
  const String clientKey = 'YOUR_BACK4APP_CLIENT_KEY';
  const String parseServerUrl = 'https://parseapi.back4app.com';

  final parseService = ParseService(
    appId: appId,
    clientKey: clientKey,
    parseServerUrl: parseServerUrl,
  );

  await parseService.initialize();

  runApp(MyApp(parseService: parseService));
}

class MyApp extends StatelessWidget {
  final ParseService parseService;

  const MyApp({Key? key, required this.parseService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CEP Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CepListScreen(parseService: parseService),
    );
  }
}
