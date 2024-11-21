import 'package:flutter/material.dart';
import 'package:house_app/screens/add_receita_screen.dart';
import 'package:house_app/screens/AddDespesaScreen.dart';
import 'package:house_app/screens/AddTransferenciaScreen.dart';
import 'package:path/path.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Perfil',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      AssetImage('lib/assets/images/user_avatar.png'),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Olá, Vinicius!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Text(
              'Editar perfil',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.black),
              title: const Text('Editar perfil'),
              trailing:
                  const Icon(Icons.arrow_forward_ios, color: Colors.black),
              onTap: () {
                // Ação para editar perfil
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              color: Colors.black,
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            IconButton(
              icon: const Icon(Icons.attach_money),
              color: Colors.black,
              onPressed: () {
                Navigator.pushNamed(context, '/transaction');
              },
            ),
            const SizedBox(width: 40), // Espaço para o botão central
            IconButton(
              icon: const Icon(Icons.bar_chart),
              color: Colors.black,
              onPressed: () {
                Navigator.pushNamed(context, '/reports');
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              color: Colors.black,
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddOptions(context); // Mostra as opções de adicionar
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  // Exibe o modal com opções de adicionar
  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Escolha o que você deseja adicionar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.add, color: Colors.green),
                title: const Text('Receita'),
                onTap: () {
                  Navigator.pop(context); // Fecha o modal
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddReceitaScreen()),
                  ); // Navega para a tela de receita
                },
              ),
              ListTile(
                leading: const Icon(Icons.remove, color: Colors.red),
                title: const Text('Despesa'),
                onTap: () {
                  Navigator.pop(context); // Fecha o modal
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddDespesaScreen()),
                  ); // Navega para a tela de despesa
                },
              ),
              ListTile(
                leading: const Icon(Icons.swap_horiz, color: Colors.grey),
                title: const Text('Transferência'),
                onTap: () {
                  Navigator.pop(context); // Fecha o modal
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddTransferenciaScreen()),
                  ); // Navega para a tela de transferência
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Cria uma opção de adicionar no modal
  Widget _buildAddOption(String label, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        onTap: () {
          // Ação para cada opção
          Navigator.pop(context as BuildContext); // Fecha o modal
        },
        leading: Icon(icon, color: color),
        title: Text(
          label,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }
}
