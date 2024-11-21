import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:house_app/screens/add_receita_screen.dart';
import 'package:house_app/screens/AddDespesaScreen.dart';
import 'package:house_app/screens/AddTransferenciaScreen.dart';
import 'package:hive/hive.dart';
import 'package:house_app/models/receita.dart';
import 'package:house_app/models/despesa.dart';
import 'package:house_app/models/transferencia.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isBalanceVisible = true; // Controla a visibilidade dos valores
  double totalReceitas = 0.0;
  double totalDespesas = 0.0;
  double totalTransferencias = 0.0;

  Future<void> _calcularTotais() async {
    // Abrir as caixas Hive e calcular os totais
    final receitaBox = await Hive.openBox<Receita>('receitas');
    final despesaBox = await Hive.openBox<Despesa>('despesas');
    final transferenciaBox =
        await Hive.openBox<Transferencia>('transferencias');

    setState(() {
      totalReceitas =
          receitaBox.values.fold(0.0, (sum, receita) => sum + receita.valor);
      totalDespesas =
          despesaBox.values.fold(0.0, (sum, despesa) => sum + despesa.valor);
      totalTransferencias = transferenciaBox.values
          .fold(0.0, (sum, transferencia) => sum + transferencia.valor);
    });
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR', null);
    _calcularTotais(); // Calcula os totais ao iniciar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(
                  'lib/assets/images/user_avatar.png'), // Imagem do usuário
              radius: 20,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá',
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
                Text(
                  'Usuário', // Nome do usuário
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'lib/assets/images/logo.png', // Logo da House
                        width: 40,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Saiba como usar\nnosso APP',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const Icon(Icons.close, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Mês e ano com botão de visibilidade e atualizar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat.yMMMM('pt_BR').format(
                      DateTime.now()), // Formata o mês e ano em português
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _isBalanceVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        setState(() {
                          _isBalanceVisible = !_isBalanceVisible;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.sync, color: Colors.black54),
                      onPressed:
                          _calcularTotais, // Atualiza os valores ao clicar
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Cartões de saldo, receitas e despesas
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.5,
              children: [
                _buildInfoCard(
                  'Saldo atual',
                  'R\$ ${(totalReceitas - totalDespesas - totalTransferencias).toStringAsFixed(2)}',
                  Colors.green,
                  Icons.account_balance_wallet,
                  _isBalanceVisible,
                ),
                _buildInfoCard(
                  'Receitas',
                  'R\$ ${totalReceitas.toStringAsFixed(2)}',
                  Colors.blue,
                  Icons.attach_money,
                  _isBalanceVisible,
                ),
                _buildInfoCard(
                  'Despesas',
                  'R\$ ${totalDespesas.toStringAsFixed(2)}',
                  Colors.red,
                  Icons.money_off,
                  _isBalanceVisible,
                ),
                _buildInfoCard(
                  'Gastos conta',
                  'R\$ 0,00',
                  Colors.orange,
                  Icons.credit_card,
                  _isBalanceVisible,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Minhas contas
            _buildSectionHeader('Minhas contas', onAddPressed: () {}),
            _buildAccountItem('Dinheiro Físico', 'R\$ 0,00',
                'lib/assets/images/cash_icon.png', _isBalanceVisible),
            const SizedBox(height: 20),

            // Meus cartões
            _buildSectionHeader('Meus cartões', onAddPressed: () {}),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Você não tem nenhum cartão cadastrado',
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ],
        ),
      ),

      // Barra de navegação inferior
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Navigator.pop(context); // Fecha o modal
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

  // Widget para os cartões de informação (saldo, receita, despesa)
  Widget _buildInfoCard(
      String title, String amount, Color color, IconData icon, bool isVisible) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(fontSize: 12, color: Colors.black54)),
              Text(
                isVisible ? amount : '*****',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget para cabeçalho de seções (minhas contas, meus cartões)
  Widget _buildSectionHeader(String title, {VoidCallback? onAddPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        IconButton(
          icon: const Icon(Icons.add, color: Colors.green),
          onPressed: onAddPressed,
        ),
      ],
    );
  }

  // Widget para itens de conta (Dinheiro Físico, Banco do Brasil)
  Widget _buildAccountItem(
      String accountName, String balance, String iconPath, bool isVisible) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Image.asset(iconPath, width: 40), // Ícone da conta
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(accountName,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold)),
              Text(
                isVisible ? 'Saldo de $balance' : 'Saldo de *****',
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
