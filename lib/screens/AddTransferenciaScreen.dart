// lib/screens/add_transferencia_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import '../models/transferencia.dart';

class AddTransferenciaScreen extends StatefulWidget {
  const AddTransferenciaScreen({super.key});

  @override
  _AddTransferenciaScreenState createState() => _AddTransferenciaScreenState();
}

class _AddTransferenciaScreenState extends State<AddTransferenciaScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final MoneyMaskedTextController _amountController = MoneyMaskedTextController(
    leftSymbol: 'R\$ ',
    decimalSeparator: ',',
    thousandSeparator: '.',
  );
  DateTime _selectedDate = DateTime.now();
  String _recurrence = 'único';
  String? _selectedOriginAccount;
  String? _selectedDestinationAccount;

  // Função para selecionar uma data
  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Função para salvar a transferência
  void _saveTransferencia() async {
    if (_formKey.currentState!.validate()) {
      final descricao = _nameController.text;
      final valor = _amountController.numberValue;
      final data = _selectedDate;
      final contaOrigem = _selectedOriginAccount ?? 'Não especificado';
      final contaDestino = _selectedDestinationAccount ?? 'Não especificado';

      // Criar a transferência
      final transferencia = Transferencia(
        contaOrigem: contaOrigem,
        contaDestino: contaDestino,
        valor: valor,
        data: data,
      );

      // Salvar no Hive
      final box = await Hive.openBox<Transferencia>('transferencias');
      await box.add(transferencia);

      // Exibir confirmação
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transferência adicionada com sucesso!')),
      );

      Navigator.pop(context); // Fecha a tela após salvar
    }
  }

  // Função para selecionar conta de origem
  void _selectOriginAccount() async {
    final List<String> accounts = ['Conta Corrente', 'Cartão de Crédito'];
    final String? selected = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Selecione a conta de origem'),
          children: accounts.map((String account) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, account);
              },
              child: Text(account),
            );
          }).toList(),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _selectedOriginAccount = selected;
      });
    }
  }

  // Função para selecionar conta de destino
  void _selectDestinationAccount() async {
    final List<String> accounts = ['Conta Corrente', 'Cartão de Crédito'];
    final String? selected = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Selecione a conta de destino'),
          children: accounts.map((String account) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, account);
              },
              child: Text(account),
            );
          }).toList(),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _selectedDestinationAccount = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        elevation: 0,
        title: const Text('Transferência', style: TextStyle(fontSize: 20)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Campo de Valor
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'Valor',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 30, color: Colors.grey),
                              decoration: const InputDecoration(
                                hintText: 'R\$ 0,00',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (_amountController.numberValue <= 0) {
                                  return 'Insira um valor válido';
                                }
                                return null;
                              },
                            ),
                          ),
                          const Icon(Icons.edit, color: Colors.grey),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Nome da Transferência
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nome da transferência',
                    labelStyle: const TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um nome';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Data
                TextFormField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: DateFormat('dd/MM/yyyy').format(_selectedDate),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Data',
                    labelStyle: const TextStyle(color: Colors.black54),
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 10),

                // Conta de Origem
                TextFormField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: _selectedOriginAccount ?? 'Selecione',
                  ),
                  decoration: InputDecoration(
                    labelText: 'Conta de origem',
                    labelStyle: const TextStyle(color: Colors.black54),
                    suffixIcon: const Icon(Icons.arrow_forward_ios),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onTap: _selectOriginAccount,
                ),
                const SizedBox(height: 10),

                // Conta de Destino
                TextFormField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: _selectedDestinationAccount ?? 'Selecione',
                  ),
                  decoration: InputDecoration(
                    labelText: 'Conta de destino',
                    labelStyle: const TextStyle(color: Colors.black54),
                    suffixIcon: const Icon(Icons.arrow_forward_ios),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onTap: _selectDestinationAccount,
                ),
                const SizedBox(height: 10),

                // Lançamento
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ChoiceChip(
                      label: const Text('Único'),
                      selected: _recurrence == 'único',
                      selectedColor: Colors.grey,
                      onSelected: (_) => setState(() {
                        _recurrence = 'único';
                      }),
                    ),
                    ChoiceChip(
                      label: const Text('Recorrente'),
                      selected: _recurrence == 'recorrente',
                      selectedColor: Colors.grey,
                      onSelected: (_) => setState(() {
                        _recurrence = 'recorrente';
                      }),
                    ),
                    ChoiceChip(
                      label: const Text('Parcelado'),
                      selected: _recurrence == 'parcelado',
                      selectedColor: Colors.grey,
                      onSelected: (_) => setState(() {
                        _recurrence = 'parcelado';
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Botão Adicionar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveTransferencia,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Adicionar',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
