import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  final bool? isConected;
  const UserProfilePage({Key? key, this.isConected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.bottomCenter,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                _buildInformationSection(context),
                // _buildApartmentSection(),
              ],
            ),
          )),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.4,
      alignment: Alignment.center,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(
                'assets/profile.jpg'), // Reemplazar con la imagen de perfil real
          ),
          const SizedBox(height: 8),
          const Text(
            'Leonardo Villanueva Medina',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            'leoxdmed97@gmail.com',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Editar'),
          ),
        ],
      ),
    );
  }

  Widget _buildInformationSection(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 184, 54, 54),
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            'Mis Ajustes',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.payment, color: Colors.white),
            title: const Text('Ajustes de Estadisticas',
                style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.language, color: Colors.white),
            title: const Text('Estado de Conexión',
                style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 200,
                      color: Colors.white,
                      child: Center(
                          child: isConected!
                              ? const Text('Conectado al server',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))
                              : const Text('Desconectado del server',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))),
                    );
                  });
            },
          ),
          ListTile(
            leading: const Icon(Icons.help, color: Colors.white),
            title: const Text('Ayuda', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.white),
            title: const Text('Cerrar Sesión',
                style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            onTap: () {
              Navigator.of(context).pushNamed('/');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildApartmentSection() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sensores',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 8),
          Card(
            color: Colors.grey[850],
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(
                    'assets/apartment.jpg'), // Reemplazar con la imagen del apartamento real
              ),
              title: const Text('Unit 4088',
                  style: TextStyle(color: Colors.white)),
              subtitle: const Text('Model: Z6708\nStatus: Active',
                  style: TextStyle(color: Colors.grey)),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'El tiempo de respuesta de los sensores puede variar.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const UserProfilePage(),
    );
  }
}
