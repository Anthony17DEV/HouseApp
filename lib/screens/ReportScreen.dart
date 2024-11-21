import 'package:flutter/material.dart';
import 'package:house_app/screens/add_receita_screen.dart';
import 'package:house_app/screens/AddDespesaScreen.dart';
import 'package:house_app/screens/AddTransferenciaScreen.dart';
import 'package:hive/hive.dart';
import 'package:house_app/models/receita.dart';
import 'package:house_app/models/despesa.dart';
import 'package:house_app/models/transferencia.dart';

List<Receita> receitas = [];
List<Despesa> despesas = [];
List<Transferencia> transferencias = [];
double totalEntradas = 0.0;
double totalSaidas = 0.0;
Map<String, double> despesasPorCategoria = {};

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String selectedPeriod = "Esse mês";

  Future<void> _loadData() async {
    final receitaBox = await Hive.openBox<Receita>('receitas');
    final despesaBox = await Hive.openBox<Despesa>('despesas');
    final transferenciaBox =
        await Hive.openBox<Transferencia>('transferencias');

    // Filtra os dados com base no período selecionado
    final DateTime now = DateTime.now();
    DateTime startDate;
    DateTime endDate = now;

    if (selectedPeriod == "Esse mês") {
      startDate = DateTime(now.year, now.month, 1);
    } else if (selectedPeriod == "Essa semana") {
      startDate = now.subtract(Duration(days: now.weekday - 1));
    } else if (selectedPeriod == "Mês passado") {
      final previousMonth = now.month == 1 ? 12 : now.month - 1;
      final previousYear = now.month == 1 ? now.year - 1 : now.year;
      startDate = DateTime(previousYear, previousMonth, 1);
      endDate =
          DateTime(now.year, now.month, 1).subtract(const Duration(days: 1));
    } else {
      startDate = DateTime(2000); // Exibe tudo para "período"
    }

    setState(() {
      receitas = receitaBox.values
          .where((receita) =>
              receita.data.isAfter(startDate) && receita.data.isBefore(endDate))
          .toList();
      despesas = despesaBox.values
          .where((despesa) =>
              despesa.data.isAfter(startDate) && despesa.data.isBefore(endDate))
          .toList();
      transferencias = transferenciaBox.values
          .where((transferencia) =>
              transferencia.data.isAfter(startDate) &&
              transferencia.data.isBefore(endDate))
          .toList();

      // Calcula os totais
      totalEntradas = receitas.fold(0.0, (sum, item) => sum + item.valor);
      totalSaidas = despesas.fold(0.0, (sum, item) => sum + item.valor) +
          transferencias.fold(0.0, (sum, item) => sum + item.valor);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Relatório detalhado',
          style: TextStyle(color: Colors.black54, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync, color: Colors.black54),
            onPressed: _loadData, // Atualiza os dados
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filtro de Período
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPeriodButton("Esse mês"),
                _buildPeriodButton("Essa semana"),
                _buildPeriodButton("Mês passado"),
                _buildPeriodButton("Período"),
              ],
            ),
            const SizedBox(height: 20),

            // Resumo de Entradas e Saídas
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Entradas',
                          style:
                              TextStyle(color: Colors.black54, fontSize: 12)),
                      Text('R\$ ${totalEntradas.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Saídas',
                          style:
                              TextStyle(color: Colors.black54, fontSize: 12)),
                      Text('R\$ ${totalSaidas.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Seções de Entradas e Saídas
            const Text(
              'Entradas',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 10),
            _buildTransactionCard(
              'Receitas',
              'R\$ ${receitas.fold(0.0, (sum, receita) => sum + receita.valor).toStringAsFixed(2)}',
              Icons.attach_money,
            ),
            const SizedBox(height: 20),

            const Text(
              'Saídas',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 10),
            _buildTransactionCard(
              'Despesas',
              'R\$ ${despesas.fold(0.0, (sum, despesa) => sum + despesa.valor).toStringAsFixed(2)}',
              Icons.shopping_cart,
            ),
            const SizedBox(height: 20),

            // Gráfico de Despesas por Categoria
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Despesas por categoria',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                TextButton(
                  onPressed: () {
                    // Adicione uma ação para exibir mais detalhes, se necessário
                  },
                  child: const Text(
                    'Ver mais',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
            Center(
              child: SizedBox(
                width: 120,
                height: 120,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CustomPaint(
                    painter: RingChartPainter(despesasPorCategoria),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: despesasPorCategoria.entries.map((entry) {
                final percent =
                    ((entry.value / totalSaidas) * 100).toStringAsFixed(1);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.green,
                          child: const Icon(Icons.shopping_cart,
                              color: Colors.white, size: 16),
                        ),
                        const SizedBox(width: 8),
                        Text(entry.key,
                            style: const TextStyle(color: Colors.green)),
                        Text(" ($percent%)",
                            style: const TextStyle(color: Colors.black54)),
                      ],
                    ),
                    Text(
                      "R\$ ${entry.value.toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Balanço Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Balanço total',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black54),
                ),
                Text(
                  'R\$ ${(totalEntradas - totalSaidas).toStringAsFixed(2)}',
                  style: TextStyle(
                    color: (totalEntradas - totalSaidas) < 0
                        ? Colors.red
                        : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
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

  // Construtor de botões de período
  Widget _buildPeriodButton(String period) {
    bool isSelected = selectedPeriod == period;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedPeriod = period;
        });
        _loadData(); // Recarrega os dados
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green : Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        period,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black54,
        ),
      ),
    );
  }

  // Construtor de cartões de transação
  Widget _buildTransactionCard(String title, String amount, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: Icon(icon, color: Colors.green),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 14))),
          Text(amount,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}

// Custom Painter para desenhar o gráfico de anel
class RingChartPainter extends CustomPainter {
  final Map<String, double> despesasPorCategoria;

  RingChartPainter(this.despesasPorCategoria);

  @override
  void paint(Canvas canvas, Size size) {
    final total =
        despesasPorCategoria.values.fold(0.0, (sum, value) => sum + value);
    double startAngle = -3.14 / 2;

    final backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      backgroundPaint,
    );

    despesasPorCategoria.forEach((category, value) {
      final sweepAngle = (value / total) * (3.14 * 2);
      final paint = Paint()
        ..color = Colors.primaries[
            despesasPorCategoria.keys.toList().indexOf(category) %
                Colors.primaries.length]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12;

      canvas.drawArc(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2,
        ),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      startAngle += sweepAngle;
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
