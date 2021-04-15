import 'dart:math';

import 'package:despesastable/provider/providerGastos.dart';
import 'package:despesastable/screens/listarDespesas.dart';
import 'package:despesastable/utils/approutes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  var descricaoController = TextEditingController();
  var valorController = TextEditingController();
  var pagouController = TextEditingController();
  var formaPagamentoController = TextEditingController();
  var salarioController = TextEditingController();
  bool fieldSalario = true;
  var _key = GlobalKey<FormState>();
  var _formData = Map<String, dynamic>();
  List<String> _options = ['Não', 'Sim'];
  List<String> _methodPayment = [
    'Dinheiro',
    'Cartão de Débito',
    'Cartão de Crédito',
    'Transferência',
    'Boleto'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final received =
        ModalRoute.of(context).settings.arguments as ProviderGastos;

    if (received != null) {
      if (_formData.isEmpty) {
        _formData['id'] = received.id;
        _formData['descricao'] = received.descricao;
        _formData['valor'] = received.valor;
        _formData['formaPagamento'] = received.formaPagamento;
        _formData['pagou'] = received.pagou;
        _formData['salario'] = received.salario;
        descricaoController.text = _formData['descricao'];
        valorController.text = _formData['valor'].toString();
        salarioController.text = _formData['salario'].toString() ?? 0;
        fieldSalario = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final gastosProvider = Provider.of<ProviderGastos>(context);

    void addGastos() {
      if (!_key.currentState.validate()) {
        return;
      }

      _key.currentState.save();

      final valuesGastos = ProviderGastos(
        id: _formData['id'],
        descricao: _formData['descricao'],
        valor: double.parse(_formData['valor']),
        formaPagamento: _formData['formaPagamento'],
        pagou: _formData['pagou'],
        salario: double.parse(_formData['salario']),
      );

      if (_formData['id'] == null) {
        gastosProvider.adicionarGastos(valuesGastos);
        gastosProvider.calcularGastos();
        fieldSalario = false;
      } else if (_formData['id'] != null) {
        gastosProvider.atualizarGastos(valuesGastos);
        gastosProvider.calcularGastos();
      }
    }

    void clear() {
      descricaoController.text = "";
      valorController.text = "";
      pagouController.text = "";
      formaPagamentoController.text = "";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Despesa'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _key,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextFormField(
                      onSaved: (newValue) => _formData['salario'] = newValue,
                      enabled: fieldSalario,
                      controller: salarioController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.monetization_on),
                        labelText: 'Digite seu saldo atual',
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                    TextFormField(
                      onSaved: (newValue) => _formData['descricao'] = newValue,
                      controller: descricaoController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.description_outlined),
                        labelText: 'Digite a descrição',
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                    TextFormField(
                      onSaved: (newValue) => _formData['valor'] = newValue,
                      controller: valorController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        icon: Icon(Icons.attach_money),
                        labelText: 'Valor',
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                    SizedBox(height: 20),
                    DropdownButton(
                      icon: Icon(Icons.payment),
                      isExpanded: true,
                      value: _formData['formaPagamento'],
                      onChanged: (value) {
                        setState(() {
                          _formData['formaPagamento'] = value;
                        });
                      },
                      hint: Text('Forma de Pagamento'),
                      items: _methodPayment
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: 20),
                    DropdownButton(
                      icon: Icon(Icons.attach_money),
                      isExpanded: true,
                      value: _formData['pagou'],
                      onChanged: (value) {
                        setState(() {
                          _formData['pagou'] = value;
                        });
                      },
                      hint: Text('Pagou?'),
                      items: _options
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      child: TextButton.icon(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        onPressed: () {
                          addGastos();
                          clear();
                        },
                        icon: Icon(Icons.add, color: Colors.white),
                        label: Text(
                          'Adicionar gasto',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: TextButton.icon(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed(AppRoutes.FORM);
                        },
                        icon: Icon(
                          Icons.table_rows,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Tabela',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
