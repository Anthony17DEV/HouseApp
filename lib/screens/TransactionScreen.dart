import 'package:flutter/material.dart';
import 'package:house_app/screens/add_receita_screen.dart';
import 'package:house_app/screens/AddDespesaScreen.dart';
import 'package:house_app/screens/AddTransferenciaScreen.dart';
import 'package:hive/hive.dart';
import 'package:house_app/models/receita.dart';
import 'package:house_app/models/despesa.dart';
import 'package:house_app/models/transferencia.dart';
import 'package:intl/intl.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  int _currentMonthIndex = DateTime.now().month - 1;
  final List<String> months = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro'
  ];
  String selectedCategory = "Geral";
  double totalBalance = 0.0;
  List<dynamic> transactions = [];
  Future<void> _loadTransactions() async {
    final receitaBox = await Hive.openBox<Receita>('receitas');
    final despesaBox = await Hive.openBox<Despesa>('despesas');
    final transferenciaBox =
        await Hive.openBox<Transferencia>('transferencias');

    final List<dynamic> allTransactions = [];

    // Adiciona receitas
    allTransactions.addAll(receitaBox.values.where((receita) {
      return receita.data.month - 1 == _currentMonthIndex; // Filtra pelo mês
    }));

    // Adiciona despesas
    allTransactions.addAll(despesaBox.values.where((despesa) {
      return despesa.data.month - 1 == _currentMonthIndex; // Filtra pelo mês
    }));

    // Adiciona transferências
    allTransactions.addAll(transferenciaBox.values.where((transferencia) {
      return transferencia.data.month - 1 ==
          _currentMonthIndex; // Filtra pelo mês
    }));

    // Ordena por data
    allTransactions.sort((a, b) => b.data.compareTo(a.data));

    // Calcula o balanço total
    final receitasTotal =
        receitaBox.values.fold(0.0, (sum, item) => sum + item.valor);
    final despesasTotal =
        despesaBox.values.fold(0.0, (sum, item) => sum + item.valor);
    final transferenciasTotal =
        transferenciaBox.values.fold(0.0, (sum, item) => sum + item.valor);

    setState(() {
      transactions = allTransactions; // Atualiza a lista de transações
      totalBalance = receitasTotal -
          despesasTotal -
          transferenciasTotal; // Calcula o balanço total
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Todos os lançamentos',
          style: TextStyle(color: Colors.black54, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt, color: Colors.black54),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Carrossel de Meses
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: months.length,
              itemBuilder: (context, index) {
                bool isSelected = index == _currentMonthIndex;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentMonthIndex = index;
                      });
                      _loadTransactions();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isSelected ? Colors.black87 : Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      months[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black54,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Filtro de Categorias
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCategoryButton("Geral"),
                _buildCategoryButton("Cartões"),
                _buildCategoryButton("Contas"),
              ],
            ),
          ),
          // Lista de Transações
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                final isReceita = transaction is Receita;
                final isDespesa = transaction is Despesa;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        isReceita ? Colors.green[100] : Colors.red[100],
                    child: Icon(
                      isReceita
                          ? Icons.attach_money
                          : (isDespesa ? Icons.money_off : Icons.swap_horiz),
                      color: isReceita ? Colors.green : Colors.red,
                    ),
                  ),
                  title: Text(
                    transaction.descricao,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle:
                      Text(DateFormat('dd/MM/yyyy').format(transaction.data)),
                  trailing: Text(
                    (isReceita ? '+ ' : '- ') +
                        'R\$ ${transaction.valor.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: isReceita ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),

          // Balanço Total
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'balanço total',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  'R\$ ${totalBalance.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: totalBalance >= 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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

  // Construtor de botões de categoria
  Widget _buildCategoryButton(String category) {
    bool isSelected = selectedCategory == category;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedCategory = category;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green : Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black54,
        ),
      ),
    );
  }
}
